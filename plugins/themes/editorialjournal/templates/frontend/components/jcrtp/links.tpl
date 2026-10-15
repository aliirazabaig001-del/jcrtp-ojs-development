{**
 * Homepage "Important Links" panel. Every target is an existing OJS route
 * (or the theme's registered editorial-process route); Submit Manuscript only
 * appears while OJS accepts submissions.
 *}
<section class="jcrtp-side-panel" aria-labelledby="jcrtp-links-heading">
    <h2 class="jcrtp-side-panel__title" id="jcrtp-links-heading">
        <svg aria-hidden="true" focusable="false" viewBox="0 0 40 40" width="26" height="26"><path fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" d="M17 23a7 7 0 0 0 10 0l6-6a7 7 0 0 0-10-10l-2 2M23 17a7 7 0 0 0-10 0l-6 6a7 7 0 0 0 10 10l2-2"/></svg>
        {translate key="plugins.themes.editorialjournal.home.importantLinks"}
    </h2>
    <ul class="jcrtp-side-panel__list jcrtp-side-panel__list--links">
        {if !$currentJournal->getData('disableSubmissions')}
            <li><a href="{url page="submission"}"><span class="jcrtp-side-panel__text">{translate key="plugins.themes.editorialjournal.header.submitManuscript"}</span><span class="jcrtp-chevron" aria-hidden="true"></span></a></li>
        {/if}
        <li><a href="{url page="about" op="submissions"}"><span class="jcrtp-side-panel__text">{translate key="plugins.themes.editorialjournal.home.authorGuidelines"}</span><span class="jcrtp-chevron" aria-hidden="true"></span></a></li>
        <li><a href="{url page="editorial-process"}"><span class="jcrtp-side-panel__text">{translate key="plugins.themes.editorialjournal.nav.editorialProcess"}</span><span class="jcrtp-chevron" aria-hidden="true"></span></a></li>
        <li><a href="{url page="about" op="editorialMasthead"}"><span class="jcrtp-side-panel__text">{translate key="plugins.themes.editorialjournal.nav.editorialBoard"}</span><span class="jcrtp-chevron" aria-hidden="true"></span></a></li>
        <li><a href="{url page="about" op="privacy"}"><span class="jcrtp-side-panel__text">{translate key="about.privacyStatement"}</span><span class="jcrtp-chevron" aria-hidden="true"></span></a></li>
        <li><a href="{url page="about" op="contact"}"><span class="jcrtp-side-panel__text">{translate key="plugins.themes.editorialjournal.home.contactUs"}</span><span class="jcrtp-chevron" aria-hidden="true"></span></a></li>
    </ul>
</section>
