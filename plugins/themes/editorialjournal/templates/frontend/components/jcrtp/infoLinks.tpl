{**
 * "Journal Information" card: links to the journal's information pages,
 * all existing OJS routes (plus the theme's editorial-process route).
 *
 * @uses $current string Key of the page being shown (about, board, process,
 *       submissions, privacy, contact, announcements)
 *}
{capture assign=jcrtpChevron}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}{/capture}
<nav class="jcrtp-card jcrtp-section-nav" aria-labelledby="jcrtp-info-links-heading">
    <h2 class="jcrtp-card__title" id="jcrtp-info-links-heading">{include file="frontend/components/jcrtp/icon.tpl" name="book" size=24}{translate key="plugins.themes.editorialjournal.page.journalInformation"}</h2>
    <ul>
        <li><a href="{url page="about"}"{if $current == 'about'} class="is-current" aria-current="page"{/if}>{translate key="about.aboutContext"}{$jcrtpChevron}</a></li>
        <li><a href="{url page="about" op="editorialMasthead"}"{if $current == 'board'} class="is-current" aria-current="page"{/if}>{translate key="plugins.themes.editorialjournal.nav.editorialBoard"}{$jcrtpChevron}</a></li>
        <li><a href="{url page="editorial-process"}"{if $current == 'process'} class="is-current" aria-current="page"{/if}>{translate key="plugins.themes.editorialjournal.nav.editorialProcess"}{$jcrtpChevron}</a></li>
        <li><a href="{url page="about" op="submissions"}"{if $current == 'submissions'} class="is-current" aria-current="page"{/if}>{translate key="about.submissions"}{$jcrtpChevron}</a></li>
        <li><a href="{url page="about" op="privacy"}"{if $current == 'privacy'} class="is-current" aria-current="page"{/if}>{translate key="about.privacyStatement"}{$jcrtpChevron}</a></li>
        {if $currentContext && $currentContext->getData('enableAnnouncements')}
            <li><a href="{url page="announcement"}"{if $current == 'announcements'} class="is-current" aria-current="page"{/if}>{translate key="announcement.announcements"}{$jcrtpChevron}</a></li>
        {/if}
        <li><a href="{url page="about" op="contact"}"{if $current == 'contact'} class="is-current" aria-current="page"{/if}>{translate key="about.contact"}{$jcrtpChevron}</a></li>
    </ul>
</nav>
