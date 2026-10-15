# JCRTP Responsive — OJS 3.5.0-5

Release 1.1.0. This is an installable **OJS theme**, not a standalone static
website or the earlier paper-and-teal demo. It follows the supplied JCRTP
navy/blue/magenta stylesheet, with redesigned responsive layouts and progressive
JavaScript interactions. Its internal plugin directory remains `editorialjournal`
so it can replace the earlier Editorial Journal theme.

## What changes

- Responsive journal homepage with the actual OJS journal title, configured
  description, ISSNs, homepage banner, current issue, and native article list.
- Journal-wide search using OJS, plus an optional instant title/author filter
  for the current issue only. Filtering does not query unpublished records.
- Restyled native issue, archive, article, search, account and public submission
  information pages, plus sidebar, navigation and footer.
- Mobile navigation retains OJS's own menu controls, with ARIA state and Escape
  support. Article pages get jump links when the relevant sections exist.
- Back-to-top control, keyboard focus, reduced motion and print styles.
- Navy/accent colour options and a filter switch in Appearance.

No sample articles, editorial names, indexing claims, usage counts, policies
or fabricated journal metrics are included. Logo, homepage banner and content
are read from OJS. No external fonts, frontend server, build process, database
migration or OJS core edits are required. English theme labels are included.

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
   in the hero. Keep/upload your logo and homepage image in OJS. Choose primary
   and accent colours and whether to enable the current issue filter.
7. Clear OJS template/data caches using your normal administrator procedure,
   then hard-refresh the public journal page. Private admin screens are not
   restyled by this reader-facing theme.

The tar.gz is for OJS plugin upload. The ZIP is for manual extraction. Both
contain a single `editorialjournal/` directory. Do not upload the old
`editorialjournal-ojs-3.5.0-5.tar.gz` or `scholara.zip`.

## Verify on your installation

Check homepage with and without a published issue; uploaded banner/logo;
filter and Clear; journal-wide search; issue/archive pagination; article
abstract, citation tools and actual PDF/galley links; mobile menu and keyboard;
login and submission information; enabled sidebar blocks and announcements.
If the old blue-only layout remains, confirm the **selected** theme and removal
of the old uploaded stylesheet, then inspect your browser's Network panel for
the new CSS files and `js/theme.js`.

The code targets official OJS tag `3_5_0-5` and uses the Default theme's native
templates and hooks. PHP, CSS, JavaScript and package checks can be run in this
workspace; your localhost installation cannot be reached here. Live activation,
Smarty rendering and your installed plugin combinations must be checked on
your OJS instance before production use.