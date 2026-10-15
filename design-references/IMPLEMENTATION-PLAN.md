# JCRTP theme — full-site implementation plan

Status after the Phase 3 review (homepage). Prepared from renders of the
`editorialjournal` theme on a disposable OJS 3.5.0.5 install (seeded test
journal, issue, articles, PDF galley, announcements; plus an empty journal),
compared with the images in `design-references/`.

## Wireframes available

| File | Covers |
|---|---|
| `Homepage.png` | Homepage, shared header, shared footer (primary reference) |
| `homepage.jfif` | Earlier homepage concept (superseded by `Homepage.png`) |
| `header-navigation.png` | Header and primary navigation (Phase 2) |
| `about-journal-desktop.png` | About the Journal (desktop only) |
| `current-issue-desktop.png` | Current Issue (desktop only) |
| `Logo.png` / `logo.jfif` | Official logo |

`editorial-process-preview.png` (repo root) is a screenshot of an earlier
build, not a wireframe. No mobile/tablet wireframes exist; responsive layouts
follow the desktop designs.

## Page matrix

Priority: **P0** broken/blocking · **P1** wireframe exists, large gap ·
**P2** no wireframe, apply the design system · **P3** polish.

| # | Page | Wireframe | OJS template (theme override?) | Status | Missing vs design | Required work | Priority |
|---|---|---|---|---|---|---|---|
| 0 | **Shared inner-page layout** | (implied by About / Current Issue) | `frontend/components/header.tpl`/`footer.tpl` (overridden) + parent default theme | **Broken on full-width pages** | Content column collapses: parent rule `.pkp_structure_main:first-child:last-child { margin:auto }` makes the main column shrink-to-fit inside the grid. Contact renders 212 px wide ("Princip/al/Contact"); About, Privacy and Login are narrow and centred | One rule in `base.css` resetting that margin (homepage already does this in `home.css`), then a shared page banner (breadcrumb + title + summary over the hero artwork, as in both inner wireframes) and a 3-column grid (left section nav / content / right info cards) | **P0** |
| 1 | Homepage | `Homepage.png` | `frontend/pages/indexJournal.tpl` + `components/jcrtp/*` (overridden) | **Done (Phase 3)** — close match | Photographic hero render; reversed (white) logo in footer; header items listed under 12 | Asset delivery only (see "Assets") | P3 |
| 2 | About the Journal | `about-journal-desktop.png` | `frontend/pages/about.tpl` (not overridden) | Default OJS output with theme typography | Page banner; left "About" section nav; "Journal Overview" + 4 value tiles; Mission / Vision / Values blocks; right "Key Information", "Indexing & Abstracting", "Contact the Editorial Office" cards; Open Access promo card | Override `about.tpl`. Overview/Mission/Vision/Values come from the journal's own *About* content (Settings > Journal > Masthead) — styled, not hard-coded. Key Information uses OJS data only (ISSN, open-access mode, primary locale, publisher, APC from payment settings). Indexing logos **only** from a theme option list the editor fills in — no logos shipped by default | P1 |
| 3 | Current Issue | `current-issue-desktop.png` | `frontend/pages/issue.tpl` → `objects/issue_toc.tpl` (not overridden; `objects/article_summary.tpl` is) | Default TOC list, ISO dates | Page banner; left issue card (cover, volume/issue, description, View Full Issue / Download Issue PDF); section filter tabs with counts; in-issue search; article rows with badge, pages, date, PDF + View Abstract; right "Issue Information", "Download", "Share This Issue", "Related Links" cards | Override `issue_toc.tpl` + `article_summary.tpl`. Tabs from the issue's sections; counts, pages, DOI, dates from OJS; issue galleys for downloads (hide card when none). The theme's existing "issue filter" option drives the in-issue search. "Most Read / Most Cited" only if a metrics source is configured — otherwise omit | P1 |
| 4 | Archives | none | `frontend/pages/issueArchive.tpl` | Default list, plain | Card grid of issues with covers | Override with an issue-card grid reusing the homepage cover component; pagination kept | P2 |
| 5 | Article page | none | `frontend/pages/article.tpl` → `objects/article_details.tpl` | Default layout, works (metadata, citation tags, PDF galley verified) | Banner/breadcrumb styling, badge, metadata sidebar cards consistent with Current Issue design | Style `article_details.tpl` (prefer CSS + minimal override; keep all `citation_*` meta, galleys, DOIs, licence, how-to-cite) | P2 |
| 6 | Editorial Board | none (custom) | `frontend/pages/editorialMasthead.tpl` (overridden, data in `data/editorial-board.json`) | Custom design implemented | Page banner consistency | Adopt the shared banner from row 0 | P3 |
| 7 | Submissions / For Authors | none | `frontend/pages/submissions.tpl` | Default content, works | Section nav, checklist styling, CTA card | Shared layout + CSS for checklist/guidelines; content stays in OJS settings | P2 |
| 8 | Editorial Process | none (custom) | `frontend/pages/editorialProcess.tpl` + `data/editorial-process.html` | Custom page implemented | Banner consistency. **Content flag:** the page publicly shows an "Editorial confirmation required" draft notice from `data/editorial-process.html` — needs editor sign-off or removal | Shared banner; editor to confirm the text | P2 (content: P0 for the editor) |
| 9 | Policies (Privacy, etc.) | none | `frontend/pages/privacy.tpl`, custom pages via Static Pages | Default; affected by row 0 | Section nav + readable measure | Shared layout + prose styles | P2 |
| 10 | Contact | none | `frontend/pages/contact.tpl` | **Broken by row 0** | Contact cards | Fix row 0, then two-column contact cards from OJS contact settings | P0 → P2 |
| 11 | Search results | none | `frontend/pages/search.tpl` | Works (search verified), default form | Styled filter panel + result cards matching article rows | Override result list to reuse the article-row component; keep all form fields | P2 |
| 12 | Shared header | `header-navigation.png`, `Homepage.png` | `components/header.tpl` (Phase 2) | Implemented (Phase 2) | Horizontal logo lockup (needs asset), "Impact Factor" slot, header social icons, language switcher, search-icon variant | Only data-backed items: language switcher when >1 locale; header socials can reuse the footer social options. **No Impact Factor** unless the journal has a verified one (make it an optional theme field). Requires approval as it touches Phase 2 | P3 |
| 13 | Shared footer | `Homepage.png` | `components/footer.tpl` (Phase 3) | **Done (Phase 3)** | White/reversed logo variant (asset) | Asset delivery only | P3 |

## Data and claims policy (applies to all phases)

Wireframe placeholders that must **not** be rendered unless the journal
supplies verified data through OJS or a theme setting:
"Impact Factor", "XXXX-XXXX" ISSN, "120+" / "50+ Countries" / "Global
Readers", DOAJ / Crossref / Google Scholar / Scopus / PubMed / Dimensions
logos, "Publication Frequency: Quarterly", "APC: None", "Most Cited",
page ranges and DOIs (shown only when present on the record).

Open item: the Phase 2 header tagline reads "An International Peer-Reviewed
Open Access Journal". "Peer-reviewed" is supported by the Editorial Process
page; "International" and the unconditional "Open Access" are not verified
from repository data. Recommended: confirm the wording, or make "Open
Access" conditional on the OJS publishing mode.

## Assets required (not in the repository)

1. **Hero artwork** — the photographic cancer-cell + DNA render used in
   `Homepage.png`, `about-journal-desktop.png` and `current-issue-desktop.png`.
   Needed: original, licensed, ≥ 2400 × 1000 px (JPEG/WebP), no text or UI
   baked in, subject weighted to the centre-right. The wireframe PNGs are
   ~1300–1500 px mockups with text and cards on top, so they cannot be cropped
   for production. Until supplied, the theme's own SVG artwork
   (`images/jcrtp-hero-art.svg`) is used.
2. **Reversed (white) logo** for the dark footer, as drawn in the wireframe.
   It must come from the logo's designer; recolouring `Logo.png` with CSS
   would alter the official mark, so the footer shows the unaltered logo on a
   white plate.
3. **Horizontal logo lockup** (mark + wordmark side by side) used in the
   wireframe header, if the journal wants that layout.

## Duplicate theme folders — findings and safe cleanup

| Item | Effect |
|---|---|
| `plugins/themes/editorialjournal_backup/` | Not a valid plugin directory name (`_`). OJS throws `Invalid product name "editorialjournal_backup"` on every **disk scan** of plugins: Settings > Website > Plugins list, creating a journal, installing, upgrading. The public site keeps working because enabled plugins load from the database. It also declares the same PHP class as the live theme. |
| `plugins/themes/editorialjournal - Copy/` | Same failure (`Invalid product name "editorialjournal - Copy"`). |
| `plugins/themes/editorialjournal.rar` | Not scanned by OJS (a file, not a folder), but downloadable from the web root, exposing theme source. |
| `styles/* - Copy.css`, `styles/home - backup.css` inside the live theme | Not loaded by the theme; publicly downloadable; confusing for maintenance. |

Reproduced on the test install: with either folder present,
`PluginRegistry::loadCategory('themes')` fails; without them it lists
`defaultthemeplugin, editorialjournalthemeplugin`.

Recommended cleanup (needs approval, nothing deleted yet):
1. Keep the originals: they are in git history (commit `32794c3b`); also
   download a copy of the server's `plugins/themes/` folder before changing it.
2. Move the two folders, the `.rar` and the `* - Copy.css` / `* - backup.css`
   files to a location **outside the web root and outside `plugins/`**
   (e.g. `D:\xampp\ojs-backups\theme-backups\` locally; equivalent on the server).
3. In the repository, `git mv` them to `archive/theme-backups/` (outside
   `plugins/`, so OJS never scans them) or remove them in a reviewed commit.
4. Visit Settings > Website > Plugins once to confirm the list loads.

## Recommended next phase (Phase 4)

**Shared inner-page framework + About + Current Issue**, in this order:

1. Fix the full-width main column (row 0) — one CSS rule, all inner pages.
2. Shared page banner component (breadcrumb, title, optional summary,
   hero artwork) and the 3-column inner layout with section navigation.
3. About the Journal per `about-journal-desktop.png` (data-backed only).
4. Current Issue per `current-issue-desktop.png`, reused by issue pages
   from the Archives.
5. Archives grid and article-page styling to match (P2), then
   Submissions, Policies, Contact, Search (P2).

Test matrix per page: 1440 / 1100 / 820 / 600 / 390 / 360 px, no overflow,
no console errors, logo ratio, dropdowns, search, PDF galley download,
empty states.
