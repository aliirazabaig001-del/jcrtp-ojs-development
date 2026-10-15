# JCRTP Responsive — OJS 3.5.0-5

Release 1.1.0. This is an installable **OJS theme**, not a standalone static
website or the earlier paper-and-teal demo. It follows the supplied JCRTP
navy/blue/magenta stylesheet, with redesigned responsive layouts and progressive
JavaScript interactions. Its internal plugin directory remains `editorialjournal`
so it can replace the earlier Editorial Journal theme.

Public-facing content uses a restrained clinical-white and academic-navy visual
system with minimal magenta accents. The OJS masthead structure, DNA banner,
primary navigation, dropdown behavior and account links are preserved. The
official JCRTP logo (`images/jcrtp-logo-official.png`, a byte-identical copy
of `design-references/Logo.png`, 1896x830, opaque off-white background) is
used in the masthead and footer. The masthead and footer logo panel use the
logo's own edge colour (`#fdfdfd`) so the opaque image sits seamlessly; the
artwork is not altered. `images/jcrtp-favicon.png` (192px) and
`images/jcrtp-favicon-32.png` are square crops of the logo's monogram. The
child theme's `templates/frontend/components/header.tpl` and `footer.tpl`
(copies of the OJS 3.5.0-5 core templates) render the logo as a real `<img>`;
the uploaded OJS page-header banner stays stored in OJS but is not displayed.
Re-diff these two templates against `lib/pkp/templates` when upgrading OJS.

## What changes

- Homepage follows `design-references/Homepage.png` and is full width (no
  OJS sidebar): hero with the journal description's first sentence and
  Submit/About actions, an "at a glance" card built only from OJS values
  (current issue, published-article count, ISSN, open access, submissions
  status), a feature strip, then Current Issue | Latest Articles (three most
  recent published articles, with OJS galley/PDF links) | Announcements (when
  enabled in OJS) and Important Links. The hero artwork is the theme's own
  decorative `images/jcrtp-hero-art.svg`; the uploaded OJS homepage image is
  still not displayed. Empty states appear when nothing is published.

- Header follows `design-references/header-navigation.png`: a purple utility
  bar (tagline, account links), a white masthead with the logo left-aligned at
  its native 1896:830 ratio (64–116px tall) and Open Access/ISSN facts on the
  right (shown only when set in OJS), and a purple navigation bar with an
  inline journal search form. Below 992px the hamburger sits right of the logo.
- Primary and user menus render through
  `templates/frontend/components/jcrtp/navigationMenu.tpl`. Links come only
  from Website → Appearance → Navigation Menus; the theme regroups the primary
  items by OJS type into Home, About, Current Issue, Archives, Editorial Board,
  For Authors (Submissions), Editorial Process (custom page path
  `editorial-process`), Policies (Privacy Statement) and Contact, uses the
  theme's labels for them, and never outputs a URL twice. Unrecognised items
  keep their own title and follow Contact. Dropdowns are keyboard, hover and
  touch accessible (`js/theme.js`); between 992 and 1279px the search collapses
  to an icon that expands on focus.

- Asymmetric, responsive journal homepage with the actual OJS title,
  configured description, ISSNs and search. An editorial directory sits beside
  the journal introduction, with a separate navigation grid, prominent
  current-issue/article sections, and a compact no-issue state. No second hero
  image is added below the DNA banner.
- Journal-wide search using OJS, plus an optional instant title/author filter
  for the current issue only. Filtering does not query unpublished records.
- Editorial-style current-issue and archive rows, plus article summaries that
  link to the OJS article/abstract page and display available DOI and galley
  links using published OJS metadata.
- Restyled native issue, archive, article, search, account and public submission
  information pages, plus sidebar, navigation and footer.
- Journal-provided Editorial Board profiles on OJS's native Editorial Masthead
  route, presented in a responsive two-column academic layout with uncropped
  verified source portraits where supplied. Native appointments, peer-reviewer
  list, and editorial-history link remain available.
- An OJS-registered `/editorial-process` route and `/pages/view/editorial-process`
  compatibility URL for an accessible, responsive Editorial & Peer Review
  Process page. Its expandable timeline, decision pathway, policy guidance and
  FAQs use the supplied stages without asserting unapproved review rules,
  deadlines, appeals procedures or charges. The page visibly flags details
  that require editorial confirmation; resolve those notices against approved
  journal policy before publication.
- Sidebar information is presented as integrated editorial sections rather
  than a stack of boxed OJS blocks; the configured footer uses a responsive
  multi-column journal/contact layout while preserving its configured content
  and OJS/PKP attribution.
- Mobile navigation retains OJS's own menu controls, with ARIA state and Escape
  support. Article pages get jump links when the relevant sections exist.
- Back-to-top control, keyboard focus, reduced motion and print styles.
- Navy/accent colour options and a filter switch in Appearance.

No sample articles, indexing claims, usage counts, policies or fabricated
journal metrics are included. The board profiles in `data/editorial-board.json`
come from the journal-provided `reference-files/BOARD MEMBER.docx`; their
corresponding portraits are in `images/editorial-board/`. Update the JSON and
approved portraits together when the journal supplies revisions. The
reference-only directory is denied by Apache; only the profile copies in the
theme image directory are served publicly. The detached portrait remains
unmapped and unpublished until its identity is confirmed. Logo, homepage banner
and publication content are read from OJS. No external fonts, frontend server,
build process, database migration or OJS core edits are required. English theme
labels are included.

## Install / upgrade — important

1. Back up OJS and test on localhost first.
2. **Remove the old custom journal stylesheet** in Website → Appearance
   (usually under Advanced → Journal Style Sheet). Keep a backup of that CSS.
   A separately uploaded stylesheet can override an active theme. Also disable
   any custom header/footer HTML that injects that old CSS.
3. Sign in as a **site administrator** and upload
   `jcrtp-responsive-1.1.0-ojs-3.5.0-5.tar.gz` under Website → Plugins →
   Installed Plugins → Upload a New Plugin.
4. If OJS rejects the upload because `editorialjournal` is already installed,
   use the plugin's Upgrade action if offered. Otherwise switch to Default
   Theme first, back up the old `plugins/themes/editorialjournal/` directory,
   and replace that directory with the new archive's `editorialjournal/`.
   Do not nest it inside another directory. The entry point must be
   `plugins/themes/editorialjournal/index.php`.
5. In **Website → Appearance → Theme**, select **JCRTP Responsive** and save.
   Enabling a checkbox in Plugins does not select the theme for the journal.
   Keep Default Theme installed because this child theme depends on it.
6. Enable the inherited journal description option if you want your description
   in the hero. The theme supplies the masthead/footer logo and favicon without
   changing the OJS logo setting; keep/upload your homepage image in OJS. Choose
   primary and accent colours and whether to enable the current issue filter.
7. In Website → Appearance → Navigation Menus, add an Editorial Process custom
   item to the existing About menu with the path `editorial-process`. Keep the
   existing menu entries and order otherwise unchanged. The alternate
   `/pages/editorial-process` and `/pages/view/editorial-process` URLs render the
   same theme page; no separate OJS Static Pages entry is required.
8. Clear OJS template/data caches using your normal administrator procedure,
   then hard-refresh the public journal page. Private admin screens are not
   restyled by this reader-facing theme.

The tar.gz is for OJS plugin upload. The ZIP is for manual extraction. Both
contain a single `editorialjournal/` directory. Do not upload the old
`editorialjournal-ojs-3.5.0-5.tar.gz` or `scholara.zip`.

## Verify on your installation

Check homepage with and without a published issue; uploaded banner/logo;
filter and Clear; journal-wide search; issue/archive pagination; article
abstract, citation tools and actual PDF/galley links; mobile menu and keyboard;
login and submission information; the Editorial Process route, About-menu
link, timeline/FAQ disclosures and policy-confirmation notices; enabled
sidebar blocks and announcements.
If the old blue-only layout remains, confirm the **selected** theme and removal
of the old uploaded stylesheet, then inspect your browser's Network panel for
the new CSS files and `js/theme.js`.

The code targets official OJS tag `3_5_0-5` and uses the Default theme's native
templates and hooks. On the configured localhost instance, the homepage,
Editorial Board, Archives, Current Issue, author information and submissions
routes were opened and checked in Chromium at common responsive widths. This
installation currently has no published issues or articles, so populated issue,
archive-row and article-detail/galley rendering could not be exercised against
live publication records. Recheck those routes once published content exists.
Opera was not independently tested. PHP syntax, editor diagnostics, and the
Smarty pages rendered by the live routes were checked; no separate theme build
or automated test suite is configured.