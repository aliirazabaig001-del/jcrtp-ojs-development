<section class="jcrtp-issue" id="jcrtp-current-issue" aria-labelledby="jcrtp-issue-heading">
    <div class="jcrtp-issue__copy">
        <p class="jcrtp-eyebrow">{translate key="journal.currentIssue"}</p>
        <h2 id="jcrtp-issue-heading">{$issue->getIssueIdentification()|escape}</h2>
        {if $issue->hasDescription()}
            <div class="jcrtp-issue__description">{$issue->getLocalizedDescription()|strip_unsafe_html}</div>
        {/if}
        {if $issue->getDatePublished()}
            <p class="jcrtp-issue__date">{translate key="submissions.published"}:
                <time datetime="{$issue->getDatePublished()|date_format:'%Y-%m-%d'}">{$issue->getDatePublished()|date_format:$dateFormatShort}</time>
            </p>
        {/if}
        <div class="jcrtp-actions">
            <a class="jcrtp-button" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">{translate key="plugins.themes.editorialjournal.viewIssue"} <span aria-hidden="true">→</span></a>
            <a class="jcrtp-button jcrtp-button--secondary" href="#jcrtp-research-heading">{translate key="plugins.themes.editorialjournal.browseArticles"}</a>
        </div>
    </div>
    <div class="jcrtp-issue__cover">
        {assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
        {if $issueCover}
            <img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}" loading="lazy">
        {else}
            <div class="jcrtp-cover-placeholder" aria-hidden="true">
                <span>{$currentJournal->getLocalizedName()|escape}</span>
                <strong>{$issue->getIssueIdentification()|escape}</strong>
            </div>
        {/if}
    </div>
</section>