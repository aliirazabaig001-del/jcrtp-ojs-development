{**
 * Homepage hero (design-references/Homepage.png). The summary is the first
 * sentence of the OJS journal description; the facts card lists only values
 * OJS holds (current issue, published-article count, ISSN, open access).
 * The background illustration is decorative CSS.
 *}
{assign var=jcrtpOnlineIssn value=$currentJournal->getData('onlineIssn')}
{assign var=jcrtpPrintIssn value=$currentJournal->getData('printIssn')}
{assign var=jcrtpIsOpenAccess value=false}
{if $currentJournal->getData('publishingMode') == APP\journal\Journal::PUBLISHING_MODE_OPEN}
    {assign var=jcrtpIsOpenAccess value=true}
{/if}
{assign var=jcrtpAcceptsSubmissions value=false}
{if !$currentJournal->getData('disableSubmissions')}
    {assign var=jcrtpAcceptsSubmissions value=true}
{/if}

<section class="jcrtp-hero" aria-labelledby="jcrtp-hero-title">
    <div class="jcrtp-hero__inner">
        <div class="jcrtp-hero__content">
            <p class="jcrtp-hero__eyebrow">{translate key="plugins.themes.editorialjournal.hero.eyebrow"}</p>
            <h2 class="jcrtp-hero__title" id="jcrtp-hero-title">
                {translate key="plugins.themes.editorialjournal.hero.titleLead"}
                <span>{translate key="plugins.themes.editorialjournal.hero.titleAccent"}</span>
            </h2>
            {if $jcrtpHeroSummary}
                <p class="jcrtp-hero__lead">{$jcrtpHeroSummary|escape}</p>
            {/if}
            <div class="jcrtp-hero__actions">
                {if $jcrtpAcceptsSubmissions}
                    <a class="jcrtp-btn jcrtp-btn--primary" href="{url page="submission"}">
                        {translate key="plugins.themes.editorialjournal.header.submitManuscript"}
                        <svg aria-hidden="true" focusable="false" viewBox="0 0 24 24" width="20" height="20"><path fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" d="M5 12h14m-6-6 6 6-6 6"/></svg>
                    </a>
                {/if}
                <a class="jcrtp-btn jcrtp-btn--ghost" href="{url page="about"}">{translate key="about.aboutContext"}</a>
            </div>
        </div>

        {if $issue || $jcrtpPublishedArticleCount || $jcrtpIsOpenAccess || $jcrtpOnlineIssn || $jcrtpPrintIssn}
            <dl class="jcrtp-facts" aria-label="{translate|escape key="plugins.themes.editorialjournal.hero.factsLabel"}">
                {if $issue}
                    <div class="jcrtp-facts__row">
                        <svg class="jcrtp-facts__icon" aria-hidden="true" focusable="false" viewBox="0 0 40 40"><path fill="none" stroke="currentColor" stroke-width="2.4" stroke-linejoin="round" d="M10 5h15l7 7v23H10zM25 5v7h7M15 18h12M15 23h12M15 28h8"/></svg>
                        <dt>{translate key="plugins.themes.editorialjournal.hero.latestIssue"}</dt>
                        <dd>
                            <a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">{include file="frontend/components/jcrtp/issueLabel.tpl" issue=$issue short=true}</a>
                            {if $issue->getDatePublished()}<span>{$issue->getDatePublished()|date_format:"F Y"}</span>{/if}
                        </dd>
                    </div>
                {/if}
                {if $jcrtpPublishedArticleCount}
                    <div class="jcrtp-facts__row">
                        <svg class="jcrtp-facts__icon" aria-hidden="true" focusable="false" viewBox="0 0 40 40"><path fill="none" stroke="currentColor" stroke-width="2.4" stroke-linejoin="round" d="M20 11c-4-3-9-4-15-3v22c6-1 11 0 15 3 4-3 9-4 15-3V8c-6-1-11 0-15 3zm0 0v22"/></svg>
                        <dt>{translate key="plugins.themes.editorialjournal.hero.publishedArticles"}</dt>
                        <dd>{$jcrtpPublishedArticleCount|escape}</dd>
                    </div>
                {/if}
                {if $jcrtpOnlineIssn || $jcrtpPrintIssn}
                    <div class="jcrtp-facts__row">
                        <svg class="jcrtp-facts__icon" aria-hidden="true" focusable="false" viewBox="0 0 40 40"><path fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" d="M8 10v20M13 10v20M18 10v20M24 10v20M28 10v20M33 10v20"/></svg>
                        {if $jcrtpOnlineIssn}
                            <dt>{translate key="plugins.themes.editorialjournal.onlineIssn"}</dt>
                            <dd>{$jcrtpOnlineIssn|escape}</dd>
                        {else}
                            <dt>{translate key="plugins.themes.editorialjournal.printIssn"}</dt>
                            <dd>{$jcrtpPrintIssn|escape}</dd>
                        {/if}
                    </div>
                {/if}
                {if $jcrtpIsOpenAccess}
                    <div class="jcrtp-facts__row">
                        <svg class="jcrtp-facts__icon" aria-hidden="true" focusable="false" viewBox="0 0 40 40"><path fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" d="M13 17v-5a7 7 0 0 1 14 0v1"/><circle cx="20" cy="26" r="9" fill="none" stroke="currentColor" stroke-width="2.6"/><circle cx="20" cy="26" r="3" fill="currentColor"/></svg>
                        <dt>{translate key="plugins.themes.editorialjournal.header.openAccess"}</dt>
                        <dd>{translate key="plugins.themes.editorialjournal.hero.openAccessValue"}</dd>
                    </div>
                {/if}
            </dl>
        {/if}
    </div>
</section>
