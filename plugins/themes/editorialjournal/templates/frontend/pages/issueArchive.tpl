{**
 * plugins/themes/editorialjournal/templates/frontend/pages/issueArchive.tpl
 *
 * Archives: published OJS issues as cards (cover, label, title, publication
 * date, article count, description) in the inner-page design. Replaces the
 * OJS 3.5 core issueArchive.tpl and keeps its data ($issues, page numbers)
 * and the core pagination component. Article counts come from
 * EditorialJournalThemePlugin::assignArchiveData.
 *}
{capture assign="pageTitle"}{strip}
    {if $prevPage}
        {translate key="archive.archivesPageNumber" pageNumber=$prevPage+1}
    {else}
        {translate key="archive.archives"}
    {/if}
{/strip}{/capture}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle isFullWidth=true}

<div class="page page_issue_archive jcrtp-inner jcrtp-archive">
    {capture assign=jcrtpBannerSummary}{translate key="plugins.themes.editorialjournal.archive.summary"}{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$pageTitle|escape bannerSummary=$jcrtpBannerSummary bannerCrumbs=""}

    <div class="jcrtp-inner__body jcrtp-archive__body">
        {if empty($issues)}
            <div class="jcrtp-empty">
                <span class="jcrtp-empty-icon" aria-hidden="true">{include file="frontend/components/jcrtp/icon.tpl" name="book" size=32}</span>
                <p>{translate key="current.noCurrentIssueDesc"}</p>
            </div>
        {else}
            <ul class="jcrtp-issue-grid">
                {foreach from=$issues item="issue"}
                    {capture assign=jcrtpIssueUrl}{url op="view" path=$issue->getBestIssueId()}{/capture}
                    {assign var=jcrtpArticleCount value=$jcrtpIssueArticleCounts[$issue->getId()]|default:0}
                    <li class="jcrtp-issue-tile">
                        <a class="jcrtp-issue-tile__cover" href="{$jcrtpIssueUrl}" tabindex="-1" aria-hidden="true">
                            {include file="frontend/components/jcrtp/issueCover.tpl" issue=$issue}
                        </a>
                        <div class="jcrtp-issue-tile__body">
                            {if $jcrtpCurrentIssueId && $jcrtpCurrentIssueId == $issue->getId()}
                                <span class="jcrtp-badge jcrtp-badge--1">{translate key="plugins.themes.editorialjournal.nav.currentIssue"}</span>
                            {/if}
                            <h2 class="jcrtp-issue-tile__title">
                                <a href="{$jcrtpIssueUrl}">{include file="frontend/components/jcrtp/issueLabel.tpl" issue=$issue}</a>
                            </h2>
                            {if $issue->getShowTitle() && $issue->getLocalizedTitle()}
                                <p class="jcrtp-issue-tile__subtitle">{$issue->getLocalizedTitle()|escape}</p>
                            {/if}
                            <p class="jcrtp-issue-tile__meta">
                                {if $issue->getDatePublished()}
                                    <time datetime="{$issue->getDatePublished()|date_format:'Y-m-d'}">{$issue->getDatePublished()|date_format:"j F Y"}</time>
                                {/if}
                                {if $jcrtpArticleCount}
                                    <span>{translate key="plugins.themes.editorialjournal.archive.articleCount" number=$jcrtpArticleCount}</span>
                                {/if}
                            </p>
                            {assign var=jcrtpIssueDescription value=$issue->getLocalizedDescription()|strip_tags|trim}
                            {if $jcrtpIssueDescription}
                                <p class="jcrtp-issue-tile__description">{$jcrtpIssueDescription|truncate:170:"…"|escape}</p>
                            {/if}
                            <a class="jcrtp-more-link jcrtp-issue-tile__link" href="{$jcrtpIssueUrl}" aria-hidden="true" tabindex="-1">{translate key="plugins.themes.editorialjournal.archive.viewIssue"} <span aria-hidden="true">→</span></a>
                        </div>
                    </li>
                {/foreach}
            </ul>

            {if $prevPage > 1}
                {capture assign=prevUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" path=$prevPage}{/capture}
            {elseif $prevPage === 1}
                {capture assign=prevUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}{/capture}
            {/if}
            {if $nextPage}
                {capture assign=nextUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" path=$nextPage}{/capture}
            {/if}
            {include
                file="frontend/components/pagination.tpl"
                prevUrl=$prevUrl
                nextUrl=$nextUrl
                showingStart=$showingStart
                showingEnd=$showingEnd
                total=$total
            }
        {/if}
    </div>
</div>

{include file="frontend/components/footer.tpl" isFullWidth=true}
