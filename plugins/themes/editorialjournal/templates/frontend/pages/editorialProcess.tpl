{**
 * Editorial & Peer Review Process (content: data/editorial-process.html via
 * EditorialProcessHandler) in the shared inner-page layout.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle isFullWidth=true}

<div class="page jcrtp-process-page jcrtp-inner">
    {capture assign=jcrtpBannerCrumbs}<li><a href="{url page="about" op="submissions"}">{translate key="plugins.themes.editorialjournal.nav.forAuthors"}</a></li>{/capture}
    {capture assign=jcrtpBannerSummary}{translate key="plugins.themes.editorialjournal.process.summary"}{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$pageTitle|escape bannerSummary=$jcrtpBannerSummary bannerCrumbs=$jcrtpBannerCrumbs bannerCurrent="" bannerEyebrow="" bannerSubtitle=""}

    <div class="jcrtp-inner__body jcrtp-doc__layout">
        <aside class="jcrtp-doc__nav">
            {include file="frontend/components/jcrtp/infoLinks.tpl" current="process"}
        </aside>
        <div class="jcrtp-doc__main">
            {$editorialProcessContent}
        </div>
    </div>
</div>

{include file="frontend/components/footer.tpl" isFullWidth=true}
