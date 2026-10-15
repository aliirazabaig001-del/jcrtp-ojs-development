# Editorial Journal Theme for OJS 3.5.0-5

An OJS child theme based on the selected Scholara editorial design. It changes
the reader-facing appearance while keeping the OJS default theme's accessible
navigation, forms, authentication, submissions, search, metadata, article
galleys, and editorial workflow. It does **not** install the standalone React
app or contain sample journal records.

The journal title comes from **Settings → Journal → Masthead** in OJS. Upload a
journal logo in OJS's Website/Appearance settings if desired; this theme does
not hardcode “Scholara” or any journal name into the public pages.

## Install on OJS 3.5.0-5

1. Back up your OJS installation and test on your localhost/staging copy first.
2. Sign in with **site administrator** access. Go to **Settings → Website →
   Plugins → Installed Plugins → Upload a New Plugin** and upload
   `editorialjournal-ojs-3.5.0-5.tar.gz`. If your installation disables plugin
   uploads, extract the archive on the server so the entry point is at
   `plugins/themes/editorialjournal/index.php` (not one directory deeper).
3. Enable **Editorial Journal** under the Theme Plugins list if necessary.
4. In the journal's **Settings → Website → Appearance**, select
   **Editorial Journal** as the theme and save.
5. Refresh the journal homepage, issue, article, archive, search, sign-in, and
   submission pages. If old styling remains, clear OJS's template/cache files
   according to your administrator's normal procedure.

The archive contains one top-level `editorialjournal/` directory. The included
`.zip` alternative is for manual extraction; use `.tar.gz` for OJS's plugin
upload form.

## Scope and compatibility

- Targeted to the official OJS **3.5.0-5** theme API and default templates.
- Extends OJS's `defaultthemeplugin`; that theme must remain installed.
- Uses the OJS-native `issue_toc.tpl`, issue/article pages, search, login,
  submission routes, and navigation menus. Journal content is never bundled.
- The homepage preserves OJS highlights, uploaded homepage image, current
  issue, announcements, and additional homepage content when configured.
- Includes English theme labels and copy. OJS's built-in content remains
  localized by OJS.
- No database migrations or changes to OJS core files are included.

This workspace does not contain your localhost OJS installation. PHP syntax,
package structure, and source-template references can be checked here, but
activation and visual rendering **must be verified on your OJS 3.5.0-5 staging
instance before enabling it on a live site**. If a screen fails, switch back to
the Default theme in Appearance and report the OJS error log.