{**
 * Editorial Process in the shared inner-page layout. Public content is the
 * confirmed workflow (data/editorial-process.html via EditorialProcessHandler).
 * The earlier long-form draft, which still needs editorial confirmation, is
 * shown only to journal managers and editors ($editorialProcessDraft), in a
 * collapsed panel labelled as unpublished.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle isFullWidth=true}

<div class="page jcrtp-process-page jcrtp-inner">
    {capture assign=jcrtpBannerCrumbs}<li><a href="{url page="about" op="submissions"}">{translate key="plugins.themes.editorialjournal.nav.forAuthors"}</a></li>{/capture}
    {capture assign=jcrtpBannerSummary}{translate key="plugins.themes.editorialjournal.process.summary"}{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$pageTitle|escape bannerSummary=$jcrtpBannerSummary bannerCrumbs=$jcrtpBannerCrumbs bannerCurrent="" bannerEyebrow="" bannerSubtitle=""}

    <div class="jcrtp-inner__body jcrtp-doc__layout">
        <div class="jcrtp-doc__nav">
            {include file="frontend/components/jcrtp/infoLinks.tpl" current="process"}
        </div>
        <div class="jcrtp-doc__main">
            {$editorialProcessContent}

            {if $editorialProcessDraft}
                <details class="jcrtp-ep-draft">
                    <summary>
                        <strong>{translate key="plugins.themes.editorialjournal.process.draftTitle"}</strong>
                        <span>{translate key="plugins.themes.editorialjournal.process.draftNote"}</span>
                    </summary>
                    <div class="jcrtp-ep-draft__body">{$editorialProcessDraft}</div>
                </details>
            {/if}
        </div>
    </div>
</div>

{include file="frontend/components/footer.tpl" isFullWidth=true}
