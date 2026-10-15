# JCRTP production release runbook (Phase 7)

Scope: deploy the `editorialjournal` theme from an approved release commit to the
existing OJS 3.5 installation on the Hostinger VPS. **Only
`plugins/themes/editorialjournal/` changes.** The database, uploaded files,
users, submissions, `config.inc.php`, OJS core and other plugins are not
modified by this procedure. Never reinstall OJS, never restore a database over
a working site, never change DNS as part of this release.

Scripts in this folder (tested end to end against a disposable OJS 3.5 +
PostgreSQL install; **not yet run against production**):

| Script | Changes anything? | Purpose |
|---|---|---|
| `01-discover.sh` | No | Host, Docker, containers, mounts, TLS, DNS, web server |
| `02-backup.sh` | Writes backups only | DB dump, uploaded files, public files + themes, config, compose files, checksums, integrity checks |
| `03-deploy-theme.sh` | Theme folder + caches | Refuses to run without a verified backup < 12 h old; PHP syntax check in the production container; swaps the theme; keeps the previous copy; clears caches |
| `04-smoke-test.sh` | No | Anonymous checks of the main pages, sitemap, logo, data folder protection, certificate |
| `05-rollback.sh` | Theme folder + caches | Restores the previous theme copy |

All scripts read `/root/jcrtp-ops/jcrtp.env` (template: `jcrtp.env.example`).
Credentials are never stored in it: database credentials are read from the live
`config.inc.php` at run time and passed to the dump tool over stdin, so they do
not appear in logs, shell history or process lists.

## 1. Prerequisites (one-time)

```bash
ssh jcrtp-production                       # or the VPS address with your key
mkdir -p /root/jcrtp-ops /root/jcrtp-backups && chmod 700 /root/jcrtp-ops /root/jcrtp-backups
cd /root/jcrtp-ops
git clone --depth 50 https://github.com/aliirazabaig001-del/jcrtp-ojs-development.git repo
cp repo/ops/*.sh repo/ops/jcrtp.env.example . && chmod +x *.sh
```

## 2. Discovery (read-only)

```bash
./01-discover.sh /docker/jcrtp          # use the real compose directory
```

Record and confirm before going further:

1. OJS version (`dbscripts/xml/version.xml` in the app container) is 3.5.x.
   The theme was tested on **3.5.0.5**. If production differs, stop and report.
2. PHP version and extensions (`php -v`, `php -m`): PHP 8.2+ with `intl`,
   `mbstring`, `xml`, `gd`, `zip`, `bcmath` and the PDO driver for the DB.
3. Database engine and version (MySQL/MariaDB or PostgreSQL) → `DB_ENGINE`.
4. Service names → `APP_SERVICE`, `DB_SERVICE`; OJS root → `OJS_ROOT`;
   `files_dir` from `config.inc.php` → `OJS_FILES_DIR`.
5. **How the theme reaches the container.** From the mount list:
   * If `plugins/` or the OJS root is a bind mount → `THEME_VIA_DOCKER_CP=no`,
     `THEME_HOST_DIR=<host path>/plugins/themes/editorialjournal`.
   * If OJS code lives only in the image → `THEME_VIA_DOCKER_CP=yes`.
     **Warning:** files copied into a container are lost when it is recreated
     (`docker compose up` after an image change). In that case also add a bind
     mount for `plugins/themes/editorialjournal` to `docker-compose.yml` in a
     separately approved maintenance step.
6. Web server (nginx or Apache) and whether `.htaccess` files are honoured.
7. Which folders exist in `plugins/themes/` (look for
   `editorialjournal_backup`, `editorialjournal - Copy`, `.rar` files).
8. Free disk space ≥ 3 × (database size + files_dir size).
9. TLS certificate validity and renewal (certbot/Traefik/Caddy).

Fill in `/root/jcrtp-ops/jcrtp.env` and `chmod 600` it.

## 3. Backup and verification

```bash
./02-backup.sh
cat /root/jcrtp-backups/LATEST              # backup directory
```

The script fails unless the dump contains the `journals`, `submissions`,
`publications`, `issues` and `users` tables and every archive passes `gzip -t`
or `tar -t`. Recommended once per release: prove the dump restores, using a
throwaway database container that is deleted afterwards (never the production
database):

```bash
B=$(cat /root/jcrtp-backups/LATEST)
# MySQL/MariaDB example (match the production major version):
docker run -d --name jcrtp-restore-test -e MYSQL_ROOT_PASSWORD=tmp -e MYSQL_DATABASE=t mariadb:10.11
sleep 25; zcat "$B/database.sql.gz" | docker exec -i jcrtp-restore-test mariadb -uroot -ptmp t
docker exec jcrtp-restore-test mariadb -uroot -ptmp t -e "select count(*) from submissions; select count(*) from issues;"
docker rm -f jcrtp-restore-test
```

Copy the backup off the server as well (e.g. `rsync -a "$B" user@other-host:`).

## 4. Release candidate

The approved release is a commit SHA on `claude/phase-6-release` (or on
`main` after the PRs are merged in order #1 → #2 → #3 → #4).

```bash
cd /root/jcrtp-ops/repo && git fetch origin && git checkout <APPROVED_SHA>
git archive --format=tar.gz -o /root/jcrtp-ops/theme-<APPROVED_SHA>.tar.gz <APPROVED_SHA>:plugins/themes/editorialjournal
```

## 5. Deploy (no expected downtime)

```bash
cd /root/jcrtp-ops
./03-deploy-theme.sh /root/jcrtp-ops/theme-<APPROVED_SHA>.tar.gz <APPROVED_SHA>
./04-smoke-test.sh https://jcrtp.com/index.php/jcrtp      # use the real journal URL
```

The theme folder is swapped in one rename; pages are never served half-updated.
The first requests after the cache clear are slower while templates recompile.

Then, in a browser:

1. Log in as a journal manager. Open **Settings → Website → Appearance**. Confirm
   the active theme is "Editorial Journal" and that the theme options (colours,
   issue filter, social links, Indexing & Abstracting) still hold their values.
   Fill in social links / indexing services only with verified information.
2. **Administration → Clear Data Caches** and **Clear Template Cache** (supported
   OJS procedure; the script already did the equivalent).
3. Check: homepage, About, Current Issue (tabs + search), Archives, one article
   (metadata, DOI, "How to Cite", PDF download), Editorial Board, Editorial
   Process, Submissions (logged out and logged in), Contact, Privacy, Search,
   Announcements, one static page, Login. Repeat key pages on a phone.
4. Watch logs for a few minutes: `docker compose logs --since 10m APP_SERVICE`.

## 6. Server-side clean-up (separate approval)

Only after the release is confirmed good, and only with explicit approval:

```bash
# Move invalid/duplicate theme folders OUT of plugins/themes (they break the
# Plugins page and plugin scans). Keep them in the backup area, do not delete.
docker compose exec APP_SERVICE sh -c 'ls -la plugins/themes'
# for each of: "editorialjournal_backup", "editorialjournal - Copy", "editorialjournal.rar"
docker compose cp "APP_SERVICE:/var/www/html/plugins/themes/<name>" "/root/jcrtp-backups/server-theme-copies/"
docker compose exec APP_SERVICE rm -rf "/var/www/html/plugins/themes/<name>"   # only after the copy is verified
```

Optional, approval required (bundled plugin, not theme code): the Static Pages
plugin in this repository contains a leftover debug line that writes to the
PHP error log on **every** front-end request:
`plugins/generic/staticPages/StaticPagesPlugin.php` line 148
`error_log('JCRTP static page diagnostic: ...');`. If production has it too
(`grep -n "static page diagnostic" plugins/generic/staticPages/StaticPagesPlugin.php`),
removing that single line restores the upstream plugin behaviour.

## 7. Web server rules

The theme's `data/` folder (Editorial Board JSON, Editorial Process public text
and the editor-only draft) is read by PHP and should not be web-readable.
`data/.htaccess` covers Apache. For **nginx**, add inside the server block and
reload:

```nginx
location ~* ^/plugins/themes/editorialjournal/data/ { deny all; return 404; }
location ~* /(archive|ops)/ { deny all; return 404; }     # only if the whole repository is ever placed in the web root
```

`04-smoke-test.sh` warns if `data/` is still readable.

Recommended (not part of the theme): add the OJS sitemap to `robots.txt` in the
OJS root, e.g. `Sitemap: https://jcrtp.com/index.php/jcrtp/sitemap`.

Caching: do not add full-page caching in front of OJS; logged-in users,
submission forms and CSRF tokens require dynamic pages. Static assets
(`/plugins/themes/editorialjournal/images|styles|js`) may be cached for a long
time; the theme's CSS/JS URLs change version with OJS.

## 8. Rollback

Theme only (the normal case; database and files were not touched):

```bash
./05-rollback.sh && ./04-smoke-test.sh https://jcrtp.com/index.php/jcrtp
```

Full restore (only if the database or uploaded files were damaged by something
outside this procedure; requires a maintenance window and approval):

1. Stop the app container: `docker compose stop APP_SERVICE`.
2. Restore the database from `$B/database.sql.gz` into an **empty** database
   with the same name and credentials (`mariadb`/`mysql` or `psql`).
3. Restore uploaded files: extract `$B/files_dir.tar.gz` over `OJS_FILES_DIR`;
   public files and themes from `$B/public_and_themes.tar.gz`.
4. Restore `config.inc.php` from `$B/config.inc.php` only if it was changed.
5. `docker compose start APP_SERVICE`, clear caches, run the smoke test.

## 9. Maintenance

* **Update the theme:** change files in `plugins/themes/editorialjournal/` on a
  branch, test, merge, then repeat sections 3–5 with the new SHA.
* **Journal content and settings** (About text, author guidelines, policies,
  contact, ISSN, announcements, issues, articles): edit in OJS under Settings,
  Issues and Submissions. No theme change is needed; the theme reads OJS data.
* **Theme options:** Settings → Website → Appearance → Theme (colours, issue
  filter, social links, Indexing & Abstracting list).
* **Editorial Board:** `plugins/themes/editorialjournal/data/editorial-board.json`
  and portraits in `images/editorial-board/` (theme change).
* **Editorial Process:** public text `data/editorial-process.html`; the draft
  shown only to managers is `data/editorial-process-draft.html`. Move only
  editor-approved wording into the public file.
* **Caches:** Administration → Clear Data Caches / Clear Template Cache.
