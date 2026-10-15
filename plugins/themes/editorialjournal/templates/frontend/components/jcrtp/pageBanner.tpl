{**
 * Inner-page banner shared by About and the issue pages (layout of
 * design-references/about-journal-desktop.png and current-issue-desktop.png):
 * breadcrumb trail, page title (the page's only h1) and an optional summary
 * over the theme's decorative artwork.
 *
 * @uses $bannerTitle string Escaped page title
 * @uses $bannerSummary string Optional plain-text summary
 * @uses $bannerCrumbs string Optional <li> items between Home and the title
 *}
<section class="jcrtp-banner" aria-labelledby="jcrtp-page-title">
    <div class="jcrtp-banner__inner">
        <nav class="cmp_breadcrumbs jcrtp-banner__crumbs" aria-label="{translate|escape key="navigation.breadcrumbLabel"}">
            <ol>
                <li><a href="{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}">{translate key="common.homepageNavigationLabel"}</a></li>
                {$bannerCrumbs}
                <li><span aria-current="page">{$bannerTitle}</span></li>
            </ol>
        </nav>
        <h1 class="jcrtp-banner__title" id="jcrtp-page-title">{$bannerTitle}</h1>
        {if $bannerSummary}
            <p class="jcrtp-banner__summary">{$bannerSummary|escape}</p>
        {/if}
    </div>
</section>
