{**
 * Inner-page banner shared by all inner pages (layout of
 * design-references/about-journal-desktop.png and current-issue-desktop.png):
 * breadcrumb trail, page title (the page's only h1) and an optional summary
 * over the theme's decorative artwork.
 *
 * @uses $bannerTitle string Escaped (or sanitised HTML) page title
 * @uses $bannerSummary string Optional plain-text summary
 * @uses $bannerCrumbs string Optional <li> items between Home and the title
 * @uses $bannerCurrent string Optional escaped label for the last breadcrumb
 *       (defaults to the title)
 * @uses $bannerEyebrow string Optional escaped label above the title
 * @uses $bannerSubtitle string Optional sanitised HTML subtitle
 * @uses $bannerVariant string Optional modifier, e.g. "document" for long titles
 *}
<section class="jcrtp-banner{if $bannerVariant} jcrtp-banner--{$bannerVariant|escape}{/if}" aria-labelledby="jcrtp-page-title">
    <div class="jcrtp-banner__inner">
        <nav class="cmp_breadcrumbs jcrtp-banner__crumbs" aria-label="{translate|escape key="navigation.breadcrumbLabel"}">
            <ol>
                <li><a href="{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}">{translate key="common.homepageNavigationLabel"}</a></li>
                {$bannerCrumbs}
                <li><span aria-current="page">{if $bannerCurrent}{$bannerCurrent}{else}{$bannerTitle}{/if}</span></li>
            </ol>
        </nav>
        {if $bannerEyebrow}
            <p class="jcrtp-banner__eyebrow">{$bannerEyebrow}</p>
        {/if}
        <h1 class="jcrtp-banner__title" id="jcrtp-page-title">{$bannerTitle}</h1>
        {if $bannerSubtitle}
            <p class="jcrtp-banner__subtitle">{$bannerSubtitle}</p>
        {/if}
        {if $bannerSummary}
            <p class="jcrtp-banner__summary">{$bannerSummary|escape}</p>
        {/if}
    </div>
</section>
