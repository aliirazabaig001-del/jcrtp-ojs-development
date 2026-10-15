{**
 * Editorial Journal homepage for OJS 3.5.0-5.
 * All issue, article, journal, and navigation data comes from OJS.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal editorial-home">
    {call_hook name="Templates::Index::journal"}

    {if $highlights && $highlights->count()}
        {include file="frontend/components/highlights.tpl" highlights=$highlights}
    {/if}

    <section class="editorial-intro" aria-labelledby="editorial-welcome-title">
        <div>
            <p class="editorial-eyebrow">{translate key="plugins.themes.editorialjournal.eyebrow"}</p>
            <h2 id="editorial-welcome-title">{translate key="plugins.themes.editorialjournal.heroTitle"}</h2>
        </div>
        <div class="editorial-intro__copy">
            {if $currentContext->getLocalizedData('description')}
                {$currentContext->getLocalizedData('description')|strip_unsafe_html}
            {else}
                <p>{$currentJournal->getLocalizedName()|escape}. {translate key="plugins.themes.editorialjournal.heroCopy"}</p>
            {/if}
        </div>
    </section>

    {if $activeTheme && !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
        <div class="editorial-homepage-image">
            <img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"{if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{else} alt=""{/if}>
        </div>
    {/if}

    {if $issue}
        <section class="editorial-feature" aria-labelledby="editorial-feature-title">
            <div class="editorial-feature__copy">
                <p class="editorial-kicker">{translate key="journal.currentIssue"}</p>
                <h2 id="editorial-feature-title">{$issue->getIssueIdentification()|escape}</h2>
                {if $issue->hasDescription()}
                    <div class="editorial-feature__description">{$issue->getLocalizedDescription()|strip_unsafe_html}</div>
                {/if}
                <div class="editorial-feature__footer">
                    <span>{$issue->getIssueIdentification()|escape}</span>
                    <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="view" path=$issue->getBestIssueId()}">
                        {translate key="plugins.themes.editorialjournal.exploreIssue"} <span aria-hidden="true">→</span>
                    </a>
                </div>
            </div>
            <div class="editorial-feature__art">
                {assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
                {if $issueCover}
                    <img class="editorial-feature__real-cover" src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}">
                {else}
                    <div class="editorial-feature__cover" aria-hidden="true">
                        <span>{$currentJournal->getLocalizedName()|escape}</span>
                        <span class="editorial-feature__cover-rule"></span>
                        <span class="editorial-feature__cover-volume">{$issue->getIssueIdentification()|escape}</span>
                        <span class="editorial-feature__cover-mark"></span>
                        <strong>{translate key="journal.currentIssue"}</strong>
                    </div>
                {/if}
            </div>
        </section>

        <section class="editorial-research" aria-labelledby="editorial-research-title">
            <div class="editorial-section-heading">
                <h2 id="editorial-research-title">{translate key="plugins.themes.editorialjournal.latestResearch"}</h2>
                <p>{$issue->getIssueIdentification()|escape}</p>
            </div>
            {include file="frontend/objects/issue_toc.tpl" heading="h3"}
        </section>
    {else}
        <section class="editorial-empty-issue">
            <h2>{translate key="plugins.themes.editorialjournal.noIssue"}</h2>
            <a href="{url page="about"}">{translate key="plugins.themes.editorialjournal.learnAbout"} <span aria-hidden="true">→</span></a>
        </section>
    {/if}

    <section class="editorial-about" aria-labelledby="editorial-about-title">
        <div>
            <p class="editorial-eyebrow">{translate key="about.aboutContext"}</p>
            <h2 id="editorial-about-title">{translate key="plugins.themes.editorialjournal.aboutTitle"}</h2>
            <p>{translate key="plugins.themes.editorialjournal.aboutCopy"}</p>
            <a href="{url page="about"}">{translate key="plugins.themes.editorialjournal.learnAbout"} <span aria-hidden="true">→</span></a>
        </div>
        <dl>
            <div><dt>{translate key="about.aboutContext"}</dt><dd><a href="{url page="about"}">{translate key="plugins.themes.editorialjournal.learnAbout"}</a></dd></div>
            <div><dt>{translate key="about.editorialTeam"}</dt><dd><a href="{url page="about" op="editorialTeam"}">{translate key="about.editorialTeam"}</a></dd></div>
            <div><dt>{translate key="about.submissions"}</dt><dd><a href="{url page="about" op="submissions"}">{translate key="about.submissions"}</a></dd></div>
        </dl>
    </section>

    {if $announcements}
        <section class="editorial-announcements" aria-labelledby="editorial-announcements-title">
            <div class="editorial-section-heading"><h2 id="editorial-announcements-title">{translate key="announcement.announcements"}</h2></div>
            {include file="frontend/objects/announcements_list.tpl" numAnnouncements=$numAnnouncementsHomepage}
        </section>
    {/if}

    {if $additionalHomeContent}
        <section class="editorial-additional-content">{$additionalHomeContent}</section>
    {/if}

    <section class="editorial-archive-band" aria-labelledby="editorial-archive-title">
        <div>
            <p class="editorial-eyebrow">{translate key="archive.archives"}</p>
            <h2 id="editorial-archive-title">{translate key="plugins.themes.editorialjournal.archiveTitle"}</h2>
            <p>{translate key="plugins.themes.editorialjournal.archiveCopy"}</p>
        </div>
        <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}">{translate key="plugins.themes.editorialjournal.browseIssues"} <span aria-hidden="true">↓</span></a>
    </section>
</div>

{include file="frontend/components/footer.tpl"}