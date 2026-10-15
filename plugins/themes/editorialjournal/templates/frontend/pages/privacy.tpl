{**
 * plugins/themes/editorialjournal/templates/frontend/pages/privacy.tpl
 *
 * Privacy Statement in the shared document layout. Replaces the OJS 3.5 core
 * privacy.tpl; the text is the journal's $privacyStatement setting.
 *}
{include file="frontend/components/header.tpl" pageTitle="manager.setup.privacyStatement" isFullWidth=true}
{capture assign=jcrtpTitle}{translate key="manager.setup.privacyStatement"}{/capture}
{include file="frontend/components/jcrtp/documentPage.tpl" docClass="page_privacy" docTitle=$jcrtpTitle docCrumbs="" docHtml=$privacyStatement docCurrent="privacy" docEditLink=""}
{include file="frontend/components/footer.tpl" isFullWidth=true}
