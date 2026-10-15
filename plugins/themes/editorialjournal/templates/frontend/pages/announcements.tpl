{**
 * plugins/themes/editorialjournal/templates/frontend/pages/announcements.tpl
 *
 * Announcements list in the inner-page design. Replaces the OJS 3.5 core
 * announcements.tpl; keeps the introduction text, edit link and the core
 * announcement list component.
 *}
{include file="frontend/components/header.tpl" pageTitle="announcement.announcements" isFullWidth=true}

<div class="page page_announcements jcrtp-inner jcrtp-doc">
    {capture assign=jcrtpBannerTitle}{translate key="announcement.announcements"}{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$jcrtpBannerTitle bannerSummary="" bannerCrumbs="" bannerCurrent="" bannerEyebrow="" bannerSubtitle=""}

    <div class="jcrtp-inner__body jcrtp-doc__layout">
        <div class="jcrtp-doc__nav">
            {include file="frontend/components/jcrtp/infoLinks.tpl" current="announcements"}
        </div>
        <div class="jcrtp-doc__main">
            {include file="frontend/components/editLink.tpl" page="management" op="settings" path="announcements" anchor="announcements" sectionTitleKey="announcement.announcements"}
            {if $announcementsIntroduction}
                <div class="jcrtp-doc__section jcrtp-prose">{$announcementsIntroduction}</div>
            {/if}
            {if $announcements && $announcements|@count}
                {include file="frontend/components/announcements.tpl"}
            {else}
                <div class="jcrtp-empty">
                    <span class="jcrtp-empty-icon" aria-hidden="true">{include file="frontend/components/jcrtp/icon.tpl" name="document" size=32}</span>
                    <p>{translate key="announcement.noneExist"}</p>
                </div>
            {/if}
        </div>
    </div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl" isFullWidth=true}
