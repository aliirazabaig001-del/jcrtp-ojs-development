{**
 * plugins/themes/editorialjournal/templates/plugins/generic/staticPages/templates/content.tpl
 *
 * Static Pages plugin content (e.g. journal policy pages) in the theme's
 * shared document layout. Overrides the plugin's content.tpl; title and
 * content are the static page's own OJS data.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$title isFullWidth=true}
{include file="frontend/components/jcrtp/documentPage.tpl" docClass="page_static" docTitle=$title|escape docCrumbs="" docHtml=$content docCurrent="" docEditLink=""}
{include file="frontend/components/footer.tpl" isFullWidth=true}
