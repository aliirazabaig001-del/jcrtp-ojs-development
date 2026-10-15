{**
 * JCRTP Responsive homepage. Targets OJS 3.5.0-5.
 * Native OJS components continue to render publication data and plugin hooks.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal jcrtp-home">
    {call_hook name="Templates::Index::journal"}
    {if $highlights && $highlights->count()}
        {include file="frontend/components/highlights.tpl" highlights=$highlights}
    {/if}

    {include file="frontend/components/jcrtp/hero.tpl"}

    {if $issue}
        {include file="frontend/components/jcrtp/currentIssue.tpl"}
        <section class="jcrtp-research" aria-labelledby="jcrtp-research-heading">
            <div class="jcrtp-section-head">
                <div>
                    <p class="jcrtp-eyebrow">{translate key="journal.currentIssue"}</p>
                    <h2 id="jcrtp-research-heading">{translate key="plugins.themes.editorialjournal.research"}</h2>
                </div>
                <a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">{translate key="plugins.themes.editorialjournal.viewIssue"} <span aria-hidden="true">→</span></a>
            </div>
            {if $activeTheme && $activeTheme->getOption('enableIssueFilter')}
                <div class="jcrtp-filter" hidden>
                    <label for="jcrtp-filter-query">{translate key="plugins.themes.editorialjournal.filter.label"}</label>
                    <div class="jcrtp-filter__controls">
                        <input type="search" id="jcrtp-filter-query" placeholder="{translate|escape key="plugins.themes.editorialjournal.filter.placeholder"}" autocomplete="off" aria-controls="jcrtp-current-articles">
                        <button type="button" class="jcrtp-filter__clear">{translate key="plugins.themes.editorialjournal.filter.clear"}</button>
                    </div>
                    <p class="jcrtp-filter__status" aria-live="polite" aria-atomic="true" data-count-template="{translate|escape key="plugins.themes.editorialjournal.filter.count"}"></p>
                </div>
            {/if}
            <div id="jcrtp-current-articles">
                {include file="frontend/objects/issue_toc.tpl" heading="h3"}
            </div>
            <p class="jcrtp-filter__empty" hidden>{translate key="plugins.themes.editorialjournal.filter.empty"}</p>
        </section>
    {else}
        <section class="jcrtp-issue jcrtp-issue--empty">
            <div class="jcrtp-issue__copy">
                <p class="jcrtp-eyebrow">{translate key="journal.currentIssue"}</p>
                <h2>{translate key="current.noCurrentIssue"}</h2>
                <p>{translate key="current.noCurrentIssueDesc"}</p>
                <a class="jcrtp-button" href="{url page="issue" op="archive"}">{translate key="archive.archives"}</a>
            </div>
        </section>
    {/if}

    {include file="frontend/components/jcrtp/links.tpl"}

    {if $numAnnouncementsHomepage && $announcements}
        <section class="jcrtp-announcements" aria-labelledby="jcrtp-announcements-heading">
            <div class="jcrtp-section-head">
                <h2 id="jcrtp-announcements-heading">{translate key="announcement.announcements"}</h2>
                <a href="{url page="announcement"}">{translate key="plugins.themes.editorialjournal.allAnnouncements"} <span aria-hidden="true">→</span></a>
            </div>
            {include file="frontend/objects/announcements_list.tpl" numAnnouncements=$numAnnouncementsHomepage}
        </section>
    {/if}

    {if $additionalHomeContent}
        <section class="jcrtp-additional-content">{$additionalHomeContent}</section>
    {/if}

    <section class="jcrtp-archive-cta" aria-labelledby="jcrtp-archive-heading">
        <div>
            <p class="jcrtp-eyebrow">{translate key="archive.archives"}</p>
            <h2 id="jcrtp-archive-heading">{translate key="plugins.themes.editorialjournal.archive.heading"}</h2>
            <p>{translate key="plugins.themes.editorialjournal.archive.copy"}</p>
        </div>
        <a class="jcrtp-button" href="{url page="issue" op="archive"}">{translate key="journal.viewAllIssues"} <span aria-hidden="true">→</span></a>
    </section>
</div>

{include file="frontend/components/footer.tpl"}