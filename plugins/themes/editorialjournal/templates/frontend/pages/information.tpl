{**
 * plugins/themes/editorialjournal/templates/frontend/pages/information.tpl
 *
 * OJS information pages (for readers / authors / librarians) in the shared
 * document layout. Replaces the OJS 3.5 core information.tpl, including its
 * $contentOnly mode (content without header and footer).
 *}
{capture assign=jcrtpEditLink}{include file="frontend/components/editLink.tpl" page="management" op="settings" path="website" anchor="setup/information" sectionTitleKey="manager.website.information"}{/capture}
{if $contentOnly}
    <div class="page page_information">
        <h1>{translate key=$pageTitle}</h1>
        {$jcrtpEditLink}
        <div class="description">{$content}</div>
    </div>
{else}
    {include file="frontend/components/header.tpl" pageTitle=$pageTitle isFullWidth=true}
    {capture assign=jcrtpTitle}{translate key=$pageTitle}{/capture}
    {include file="frontend/components/jcrtp/documentPage.tpl" docClass="page_information" docTitle=$jcrtpTitle docCrumbs="" docHtml=$content docCurrent="" docEditLink=$jcrtpEditLink}
    {include file="frontend/components/footer.tpl" isFullWidth=true}
{/if}
