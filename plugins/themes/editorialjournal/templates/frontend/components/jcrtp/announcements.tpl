{**
 * Homepage announcements panel. Rendered only when OJS supplies
 * $announcements (announcements enabled with a homepage count).
 *}
<section class="jcrtp-side-panel" aria-labelledby="jcrtp-announcements-heading">
    <h2 class="jcrtp-side-panel__title" id="jcrtp-announcements-heading">
        <svg aria-hidden="true" focusable="false" viewBox="0 0 40 40" width="26" height="26"><path fill="none" stroke="currentColor" stroke-width="2.4" stroke-linejoin="round" d="M6 16h7l15-8v24l-15-8H6zM13 24l3 9h5l-2-9M32 14a6 6 0 0 1 0 12"/></svg>
        {translate key="announcement.announcements"}
    </h2>
    <ul class="jcrtp-side-panel__list">
        {foreach from=$announcements item=announcement}
            <li>
                <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="announcement" op="view" path=$announcement->id}">
                    <span class="jcrtp-side-panel__text">
                        <strong>{$announcement->getLocalizedData('title')|escape}</strong>
                        {assign var=announcementSummary value=$announcement->getLocalizedData('descriptionShort')|strip_tags|trim}
                        {if $announcementSummary}<small>{$announcementSummary|truncate:110:"…"|escape}</small>{/if}
                    </span>
                    <span class="jcrtp-chevron" aria-hidden="true"></span>
                </a>
            </li>
        {/foreach}
    </ul>
    <a class="jcrtp-more-link jcrtp-side-panel__more" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="announcement"}">{translate key="plugins.themes.editorialjournal.allAnnouncements"} <span aria-hidden="true">→</span></a>
</section>
