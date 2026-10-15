{**
 * Homepage Current Issue column. Uses the OJS current issue ($issue). Without
 * an uploaded cover, a theme cover is drawn from the official logo and the
 * issue's own identification; without an issue, an empty state is shown.
 *}
<section class="jcrtp-home-panel jcrtp-current" aria-labelledby="jcrtp-current-heading">
    <div class="jcrtp-home-panel__head">
        <h2 id="jcrtp-current-heading">{translate key="plugins.themes.editorialjournal.nav.currentIssue"}</h2>
        <a class="jcrtp-more-link" href="{url page="issue" op="archive"}">{translate key="journal.viewAllIssues"} <span aria-hidden="true">→</span></a>
    </div>

    {if $issue}
        {capture assign=issueUrl}{url page="issue" op="view" path=$issue->getBestIssueId()}{/capture}
        <div class="jcrtp-current__card">
            <a class="jcrtp-current__cover" href="{$issueUrl}" tabindex="-1" aria-hidden="true">
                {assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
                {if $issueCover}
                    <img src="{$issueCover|escape}" alt="" loading="lazy">
                {else}
                    <span class="jcrtp-cover">
                        <span class="jcrtp-cover__brand"><img src="{$jcrtpLogoUrl|escape}" width="{$jcrtpLogoWidth|escape}" height="{$jcrtpLogoHeight|escape}" alt="" loading="lazy"></span>
                        <span class="jcrtp-cover__art"></span>
                        <span class="jcrtp-cover__foot">
                            <span>{include file="frontend/components/jcrtp/issueLabel.tpl" issue=$issue short=true}</span>
                            {if $currentJournal->getData('publishingMode') == APP\journal\Journal::PUBLISHING_MODE_OPEN}<span class="jcrtp-cover__oa">{translate key="plugins.themes.editorialjournal.header.openAccess"}</span>{/if}
                        </span>
                    </span>
                {/if}
            </a>
            <div class="jcrtp-current__body">
                <h3 class="jcrtp-current__title"><a href="{$issueUrl}">{include file="frontend/components/jcrtp/issueLabel.tpl" issue=$issue}</a></h3>
                {if $issue->getDatePublished()}
                    <p class="jcrtp-current__date"><time datetime="{$issue->getDatePublished()|date_format:'Y-m-d'}">{$issue->getDatePublished()|date_format:"F Y"}</time></p>
                {/if}
                {if $issue->getShowTitle() && $issue->getLocalizedTitle()}
                    <p class="jcrtp-current__issue-title">{$issue->getLocalizedTitle()|escape}</p>
                {/if}
                {if $issue->hasDescription()}
                    <div class="jcrtp-current__description">{$issue->getLocalizedDescription()|strip_unsafe_html}</div>
                {/if}
                <div class="jcrtp-current__actions">
                    <a class="jcrtp-btn jcrtp-btn--primary jcrtp-btn--small" href="{$issueUrl}">{translate key="plugins.themes.editorialjournal.home.viewCurrentIssue"}</a>
                    <a class="jcrtp-btn jcrtp-btn--outline jcrtp-btn--small" href="{url page="issue" op="archive"}">{translate key="plugins.themes.editorialjournal.home.browseArchives"}</a>
                </div>
            </div>
        </div>
    {else}
        <div class="jcrtp-current__card jcrtp-current__card--empty">
            <span class="jcrtp-empty-icon" aria-hidden="true"><svg viewBox="0 0 40 40" focusable="false"><path fill="none" stroke="currentColor" stroke-width="2.2" stroke-linejoin="round" d="M10 5h15l7 7v23H10zM25 5v7h7M15 18h12M15 23h12M15 28h8"/></svg></span>
            <div class="jcrtp-current__body">
                <h3 class="jcrtp-current__title">{translate key="current.noCurrentIssue"}</h3>
                <p>{translate key="current.noCurrentIssueDesc"}</p>
                <div class="jcrtp-current__actions">
                    <a class="jcrtp-btn jcrtp-btn--outline jcrtp-btn--small" href="{url page="issue" op="archive"}">{translate key="plugins.themes.editorialjournal.home.browseArchives"}</a>
                </div>
            </div>
        </div>
    {/if}
</section>
