{**
 * plugins/themes/editorialjournal/templates/frontend/pages/announcement.tpl
 *
 * Single announcement in the inner-page design: the announcement title is
 * the banner h1; date, image and full text (or summary) follow, as in the
 * OJS 3.5 core announcement_full.tpl.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$announcement->getLocalizedData('title')|escape isFullWidth=true}

<div class="page page_announcement jcrtp-inner jcrtp-doc">
    {capture assign=jcrtpBannerCrumbs}<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="announcement"}">{translate key="announcement.announcements"}</a></li>{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$announcement->getLocalizedData('title')|escape bannerSummary="" bannerCrumbs=$jcrtpBannerCrumbs bannerCurrent="" bannerEyebrow="" bannerSubtitle=""}

    <div class="jcrtp-inner__body jcrtp-doc__layout">
        <div class="jcrtp-doc__nav">
            {include file="frontend/components/jcrtp/infoLinks.tpl" current="announcements"}
        </div>
        <article class="jcrtp-doc__main obj_announcement_full">
            <p class="date jcrtp-doc__date"><time datetime="{$announcement->datePosted->format('Y-m-d')}">{$announcement->datePosted->format('j F Y')}</time></p>
            {if $announcement->image}
                <img class="obj_announcement_full_image" src="{$announcement->imageUrl}" alt="{$announcement->imageAltText}" />
            {/if}
            <div class="description jcrtp-doc__section jcrtp-prose">
                {if $announcement->getLocalizedData('description')}
                    {$announcement->getLocalizedData('description')|strip_unsafe_html}
                {else}
                    {$announcement->getLocalizedData('descriptionShort')|strip_unsafe_html}
                {/if}
            </div>
            <a class="jcrtp-more-link" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="announcement"}"><span aria-hidden="true">←</span> {translate key="plugins.themes.editorialjournal.allAnnouncements"}</a>
        </article>
    </div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl" isFullWidth=true}
