{**
 * JCRTP Responsive homepage. Targets OJS 3.5.0-5.
 * Layout follows design-references/Homepage.png. All publication data comes
 * from OJS: $issue (current issue), $announcements, and the theme's
 * $jcrtpLatestArticles/$jcrtpPublishedArticleCount/$jcrtpHeroSummary
 * (EditorialJournalThemePlugin::assignHomepageData). Sections without data
 * show an honest empty state or are left out.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName() isFullWidth=true}

<div class="page_index_journal jcrtp-home">
    {call_hook name="Templates::Index::journal"}

    {include file="frontend/components/jcrtp/hero.tpl"}
    {include file="frontend/components/jcrtp/features.tpl"}

    {if $highlights && $highlights->count()}
        <div class="jcrtp-home__highlights">
            {include file="frontend/components/highlights.tpl" highlights=$highlights}
        </div>
    {/if}

    <div class="jcrtp-home__columns">
        {include file="frontend/components/jcrtp/currentIssue.tpl"}
        {include file="frontend/components/jcrtp/latestArticles.tpl"}
        <aside class="jcrtp-home__aside" aria-label="{translate|escape key="plugins.themes.editorialjournal.home.asideLabel"}">
            {if $numAnnouncementsHomepage && $announcements && $announcements->count()}
                {include file="frontend/components/jcrtp/announcements.tpl"}
            {/if}
            {include file="frontend/components/jcrtp/links.tpl"}
        </aside>
    </div>

    {if $additionalHomeContent}
        <section class="jcrtp-additional-content">{$additionalHomeContent}</section>
    {/if}
</div>

{include file="frontend/components/footer.tpl" isFullWidth=true}
