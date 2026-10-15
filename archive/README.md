# Archived theme material

Moved here in Phase 6 (unchanged; full history is kept in git) so that it is
no longer inside `plugins/`, where OJS scans every folder:

| Item | Original location | Why it was moved |
|---|---|---|
| `theme-backups/editorialjournal_backup/` | `plugins/themes/` | Invalid plugin folder name: OJS throws `Invalid product name` on every plugin scan (Plugins page, journal creation, install/upgrade). |
| `theme-backups/editorialjournal - Copy/` | `plugins/themes/` | Same failure (`Invalid product name "editorialjournal - Copy"`). |
| `theme-backups/editorialjournal.rar` | `plugins/themes/` | Archive of theme source; publicly downloadable from the web root. |
| `theme-backups/styles/*` | `plugins/themes/editorialjournal/styles/` | Old CSS copies, never loaded by the theme but publicly downloadable. |
| `reference-files/` | `plugins/themes/editorialjournal/` | Source material (board member document, portrait). Its `.htaccess` only protects it on Apache. |

Nothing in this folder is used by the site. It must **not** be deployed to the
production web root; deployment copies only `plugins/themes/editorialjournal/`
(see `ops/DEPLOYMENT.md`). Delete it only once the journal confirms these
copies are no longer needed.
