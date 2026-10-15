# JCRTP theme release candidate — Phases 1–6

Branch `claude/phase-6-release` contains, in order: the initial JCRTP
development (Phases 1–2: logo, header, navigation), Phase 3 (homepage, footer;
PR #1), Phase 4 (inner-page width fix, About, Current Issue; PR #2), Phase 5
(all remaining reader pages; PR #3) and Phase 6 (PR #4). Merge order:
#1 → #2 → #3 → #4 (each PR is based on the previous branch).

Deployable unit: `plugins/themes/editorialjournal/` only.

## Verification (disposable OJS 3.5.0.5 + PostgreSQL, seeded test data)

* 27 routes × 6 widths (1440, 1100, 820, 600, 390, 360): HTTP 200, no
  horizontal overflow, exactly one `h1`, no duplicate IDs, footer present, logo
  proportions correct, no console errors except the external Creative Commons
  badge (sandbox has no internet).
* Functional: navigation and dropdowns, mobile menu, OJS search (keyword and
  author), issue tabs and in-issue search, issue and article PDF downloads,
  DOI links, citation metadata (49 `citation_*`/`DC.*` tags on a full test
  article), "How to Cite", submission links logged out / logged in, contact
  mailto, static page anchors, theme settings save/load, subscription mode
  (restricted galleys; anonymous download redirected).
* Accessibility: axe-core WCAG 2.1 A/AA + best practice — 0 violations on 15
  pages (desktop) and 5 pages (mobile); keyboard order and focus visible.
* Regression: Phase 3–5 pages unchanged apart from the documented logo delivery
  copies and the late-Phase-5 paragraph-spacing correction.
* Ops scripts: backup → restore (row counts match, files identical) → deploy →
  smoke test → rollback exercised against the disposable install.

Not verified: anything on the production server or the live domain (no SSH
access or DNS from the build environment).

## Known issues and decisions for the journal

| Severity | Item | Recommendation |
|---|---|---|
| High (process) | Production not yet inspected: OJS/PHP versions, DB engine, mounts and web server are unconfirmed | Run `01-discover.sh` before approving deployment |
| Medium | `plugins/generic/staticPages/StaticPagesPlugin.php:148` (bundled plugin, not theme) logs a debug line on every front-end request | Remove the line with approval (see DEPLOYMENT.md §6) |
| Medium | Theme `data/` is web-readable on nginx (Apache is covered by `.htaccess`) | Add the nginx rule in DEPLOYMENT.md §7 |
| Medium | Duplicate theme folders may also exist on the server | Move them out of `plugins/themes/` after backup (DEPLOYMENT.md §6) |
| Editorial | Editorial Process long-form draft awaits confirmation (review model, deadlines, appeals, charges) | Editors review the manager-only draft; approved text moves to the public file |
| Editorial | Header tagline "An International Peer-Reviewed Open Access Journal": "International" unverified; "Open Access" shown regardless of OJS publishing mode | Confirm wording |
| Asset | No licensed photographic hero render; no white/reversed logo | Supply originals; current SVG art and logo-on-white plate remain |
| Low | Missing-article URLs return OJS core's bare "404 Not Found" | Core behaviour; not themeable |
| Low | PDF.js viewer toolbar uses the plugin's own colours | Plugin styling; optional future override |
| Info | Creative Commons badge loads from `i.creativecommons.org` (OJS core) | Failed only in the offline sandbox; confirm on live site |
