{**
 * plugins/themes/editorialjournal/templates/frontend/pages/article.tpl
 *
 * Article landing page in the inner-page design: the shared banner carries
 * the breadcrumb trail (Archives > issue), the section name, the article
 * title (the page's h1) and subtitle; frontend/objects/article_details.tpl
 * lays out the metadata. Replaces the OJS 3.5 core article.tpl and keeps its
 * Templates::Article::Footer::PageFooter hook.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$article->getCurrentPublication()->getLocalizedFullTitle(null, 'html')|strip_unsafe_html isFullWidth=true}

<div class="page page_article jcrtp-inner jcrtp-article-page">
    {capture assign=jcrtpBannerCrumbs}
        <li><a href="{url page="issue" op="archive"}">{translate key="plugins.themes.editorialjournal.nav.archives"}</a></li>
        {if $issue}
            <li><a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">{include file="frontend/components/jcrtp/issueLabel.tpl" issue=$issue}</a></li>
        {/if}
    {/capture}
    {capture assign=jcrtpBannerCurrent}{if $section}{$section->getLocalizedTitle()|escape}{else}{translate key="common.publication"}{/if}{/capture}
    {capture assign=jcrtpBannerTitle}{$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}{/capture}
    {capture assign=jcrtpBannerSubtitle}{if $publication->getLocalizedData('subtitle')}{$publication->getLocalizedSubTitle(null, 'html')|strip_unsafe_html}{/if}{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$jcrtpBannerTitle bannerSummary="" bannerCrumbs=$jcrtpBannerCrumbs bannerCurrent=$jcrtpBannerCurrent bannerEyebrow="" bannerSubtitle=$jcrtpBannerSubtitle bannerVariant="document"}

    {include file="frontend/objects/article_details.tpl"}

    {call_hook name="Templates::Article::Footer::PageFooter"}
</div><!-- .page -->

{include file="frontend/components/footer.tpl" isFullWidth=true}
