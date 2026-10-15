{**
 * plugins/themes/editorialjournal/templates/frontend/pages/issue.tpl
 *
 * Issue page (Current Issue and every archived issue), laid out after
 * design-references/current-issue-desktop.png. Replaces the OJS 3.5 core
 * issue.tpl + objects/issue_toc.tpl while keeping their data and rules:
 * OJS supplies $issue, $issueGalleys, $publishedSubmissions, $primaryGenreIds,
 * $authorUserGroups, $pubIdPlugins and $hasAccess; galley links reuse the core
 * frontend/objects/galley_link.tpl (access, purchase and restriction marks);
 * the Templates::Issue::Issue::Article hook still runs for every article.
 * Counts and the page range come from EditorialJournalThemePlugin::assignIssueData.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$issueIdentification isFullWidth=true}

<div class="page page_issue jcrtp-inner jcrtp-issue">

{if !$issue}
    {capture assign=jcrtpBannerTitle}{translate key="current.noCurrentIssue"}{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$jcrtpBannerTitle bannerSummary="" bannerCrumbs=""}
    <div class="jcrtp-inner__body jcrtp-issue__none">
        <div class="jcrtp-empty">
            <span class="jcrtp-empty-icon" aria-hidden="true">{include file="frontend/components/jcrtp/icon.tpl" name="document" size=32}</span>
            <p>{translate key="current.noCurrentIssueDesc"}</p>
            <a class="jcrtp-btn jcrtp-btn--outline jcrtp-btn--small" href="{url page="issue" op="archive"}">{translate key="plugins.themes.editorialjournal.home.browseArchives"}</a>
        </div>
    </div>
{else}
    {capture assign=jcrtpIssueLabel}{strip}{include file="frontend/components/jcrtp/issueLabel.tpl" issue=$issue}{/strip}{/capture}
    {capture assign=jcrtpIssueUrl}{url page="issue" op="view" path=$issue->getBestIssueId()}{/capture}
    {if $jcrtpIsCurrentIssue}
        {capture assign=jcrtpBannerTitle}{translate key="plugins.themes.editorialjournal.nav.currentIssue"}{/capture}
        {assign var=jcrtpBannerCrumbs value=""}
    {else}
        {assign var=jcrtpBannerTitle value=$jcrtpIssueLabel}
        {capture assign=jcrtpBannerCrumbs}<li><a href="{url page="issue" op="archive"}">{translate key="plugins.themes.editorialjournal.nav.archives"}</a></li>{/capture}
    {/if}
    {capture assign=jcrtpBannerSummary}{translate key="plugins.themes.editorialjournal.issue.bannerSummary"}{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$jcrtpBannerTitle bannerSummary=$jcrtpBannerSummary bannerCrumbs=$jcrtpBannerCrumbs}

    {* The first PDF full-issue galley (if any) drives the issue card buttons. *}
    {assign var=jcrtpIssuePdf value=null}
    {foreach from=$issueGalleys item=issueGalley}
        {if !$jcrtpIssuePdf && $issueGalley->isPdfGalley()}{assign var=jcrtpIssuePdf value=$issueGalley}{/if}
    {/foreach}

    <div class="jcrtp-inner__body jcrtp-issue__layout">

        {* Left: issue card *}
        <aside class="jcrtp-issue__intro" aria-labelledby="jcrtp-issue-heading">
            <div class="jcrtp-issue-card">
                <a class="jcrtp-issue-card__cover" href="{$jcrtpIssueUrl}" tabindex="-1" aria-hidden="true">
                    {include file="frontend/components/jcrtp/issueCover.tpl" issue=$issue}
                </a>
                <h2 class="jcrtp-issue-card__title" id="jcrtp-issue-heading">{$jcrtpIssueLabel}</h2>
                {if $issue->getDatePublished()}
                    <p class="jcrtp-issue-card__date"><time datetime="{$issue->getDatePublished()|date_format:'Y-m-d'}">{$issue->getDatePublished()|date_format:"F Y"}</time></p>
                {/if}
                {if $issue->getShowTitle() && $issue->getLocalizedTitle()}
                    <p class="jcrtp-issue-card__issue-title">{$issue->getLocalizedTitle()|escape}</p>
                {/if}
                {if !$issue->getPublished()}
                    {include file="frontend/components/notification.tpl" type="warning" messageKey="editor.issues.preview"}
                {/if}
                {if $issue->hasDescription()}
                    <div class="jcrtp-issue-card__description">{$issue->getLocalizedDescription()|strip_unsafe_html}</div>
                {/if}
                {if $jcrtpIssuePdf}
                    <div class="jcrtp-issue-card__actions">
                        {if $hasAccess}
                            <a class="jcrtp-btn jcrtp-btn--primary jcrtp-btn--small" href="{url page="issue" op="view" path=$issue->getBestIssueId()|to_array:$jcrtpIssuePdf->getBestGalleyId()}">{include file="frontend/components/jcrtp/icon.tpl" name="book" size=18}{translate key="plugins.themes.editorialjournal.issue.viewFullIssue"}</a>
                            <a class="jcrtp-btn jcrtp-btn--outline jcrtp-btn--small" href="{url page="issue" op="download" path=$issue->getBestIssueId()|to_array:$jcrtpIssuePdf->getBestGalleyId()}">{include file="frontend/components/jcrtp/icon.tpl" name="download" size=18}{translate key="plugins.themes.editorialjournal.issue.downloadIssue"}</a>
                        {else}
                            {include file="frontend/objects/galley_link.tpl" parent=$issue galley=$jcrtpIssuePdf id="" labelledBy="" purchaseFee=$currentJournal->getData('purchaseIssueFee') purchaseCurrency=$currentJournal->getData('currency')}
                        {/if}
                    </div>
                {/if}
            </div>
        </aside>

        {* Centre: articles *}
        <section class="jcrtp-issue__main" aria-labelledby="jcrtp-issue-articles-heading">
            <h2 class="visually-hidden pkp_screen_reader" id="jcrtp-issue-articles-heading">{translate key="plugins.themes.editorialjournal.issue.articles"}</h2>

            {if $jcrtpIssueArticleCount}
                <div class="jcrtp-issue-tools">
                    {if $jcrtpIssueSections|@count > 1}
                        <div class="jcrtp-issue-tabs" role="group" aria-label="{translate|escape key="plugins.themes.editorialjournal.issue.filterBySection"}" hidden>
                            <button type="button" class="jcrtp-issue-tabs__tab is-active" data-section="" aria-pressed="true">{translate key="plugins.themes.editorialjournal.issue.allArticles"} ({$jcrtpIssueArticleCount})</button>
                            {foreach from=$jcrtpIssueSections item=issueSection}
                                {if $issueSection.title}
                                    <button type="button" class="jcrtp-issue-tabs__tab" data-section="{$issueSection.id|escape}" aria-pressed="false">{$issueSection.title|escape} ({$issueSection.count})</button>
                                {/if}
                            {/foreach}
                        </div>
                    {/if}
                    {if $jcrtpIssueFilter}
                        <div class="jcrtp-issue-search" hidden>
                            <label class="pkp_screen_reader" for="jcrtp-issue-search-input">{translate key="plugins.themes.editorialjournal.issue.searchLabel"}</label>
                            <input type="search" id="jcrtp-issue-search-input" placeholder="{translate|escape key="plugins.themes.editorialjournal.issue.searchLabel"}" autocomplete="off">
                            {include file="frontend/components/jcrtp/icon.tpl" name="search" size=18}
                        </div>
                    {/if}
                </div>
                <p class="jcrtp-issue-status pkp_screen_reader" aria-live="polite"></p>

                <ol class="jcrtp-issue-list">
                    {foreach from=$publishedSubmissions key=jcrtpSectionId item=section}
                        {foreach from=$section.articles item=article}
                            {assign var=publication value=$article->getCurrentPublication()}
                            {assign var=articlePath value=$publication->getData('urlPath')|default:$article->getId()}
                            {capture assign=articleUrl}{url page="article" op="view" path=$articlePath}{/capture}
                            {assign var=coverImage value=$publication->getLocalizedData('coverImage')}
                            {assign var=showAuthor value=false}
                            {if (!$section.hideAuthor && $publication->getData('hideAuthor') == APP\submission\Submission::AUTHOR_TOC_DEFAULT) || $publication->getData('hideAuthor') == APP\submission\Submission::AUTHOR_TOC_SHOW}
                                {assign var=showAuthor value=true}
                            {/if}
                            <li class="jcrtp-issue-row" data-section="{$jcrtpSectionId|escape}">
                                <a class="jcrtp-issue-row__thumb" href="{$articleUrl}" tabindex="-1" aria-hidden="true">
                                    {if $coverImage}
                                        <img src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}" alt="" loading="lazy">
                                    {else}
                                        <span class="jcrtp-article-card__placeholder"></span>
                                    {/if}
                                </a>
                                <div class="jcrtp-issue-row__body">
                                    {if $section.title}<span class="jcrtp-badge jcrtp-badge--{$jcrtpSectionId % 3}">{$section.title|escape}</span>{/if}
                                    <h3 class="jcrtp-issue-row__title">
                                        <a id="article-{$article->getId()}" href="{$articleUrl}">{$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}</a>
                                    </h3>
                                    {assign var=localizedSubtitle value=$publication->getLocalizedSubtitle(null, 'html')|strip_unsafe_html}
                                    {if $localizedSubtitle}<p class="jcrtp-issue-row__subtitle">{$localizedSubtitle}</p>{/if}
                                    {if $showAuthor && $publication->getShortAuthorString()}
                                        <p class="jcrtp-issue-row__authors" title="{$publication->getAuthorString($authorUserGroups)|escape}">{$publication->getShortAuthorString()|escape}</p>
                                    {/if}
                                </div>
                                <div class="jcrtp-issue-row__meta">
                                    {if $publication->getData('pages')}
                                        <span>{translate key="plugins.themes.editorialjournal.issue.pages" pages=$publication->getData('pages')|escape}</span>
                                    {/if}
                                    {if $publication->getData('datePublished')}
                                        <time datetime="{$publication->getData('datePublished')|date_format:'Y-m-d'}">{$publication->getData('datePublished')|date_format:"d M Y"}</time>
                                    {/if}
                                    <ul class="jcrtp-issue-row__actions">
                                        {assign var="hasArticleAccess" value=$hasAccess}
                                        {if $currentContext->getSetting('publishingMode') == APP\journal\Journal::PUBLISHING_MODE_OPEN || $publication->getData('accessStatus') == APP\submission\Submission::ARTICLE_ACCESS_OPEN}
                                            {assign var="hasArticleAccess" value=1}
                                        {/if}
                                        {foreach from=$publication->getData('galleys') item=galley}
                                            {if $primaryGenreIds}
                                                {assign var="file" value=$galley->getFile()}
                                                {if !$galley->getData('urlRemote') && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
                                                    {continue}
                                                {/if}
                                            {/if}
                                            {assign var="id" value="article-{$article->getId()}-galley-{$galley->getId()}"}
                                            <li>{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication id=$id labelledBy="{$id} article-{$article->getId()}" hasAccess=$hasArticleAccess purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}</li>
                                        {/foreach}
                                        <li><a class="jcrtp-issue-row__abstract" href="{$articleUrl}" aria-describedby="article-{$article->getId()}">{translate key="plugins.themes.editorialjournal.issue.viewAbstract"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=12}</a></li>
                                    </ul>
                                </div>
                                {call_hook name="Templates::Issue::Issue::Article"}
                            </li>
                        {/foreach}
                    {/foreach}
                </ol>
                <p class="jcrtp-empty jcrtp-issue-nomatch" hidden>{translate key="plugins.themes.editorialjournal.issue.noMatch"}</p>
            {else}
                <div class="jcrtp-empty">
                    <span class="jcrtp-empty-icon" aria-hidden="true">{include file="frontend/components/jcrtp/icon.tpl" name="book" size=32}</span>
                    <p>{translate key="plugins.themes.editorialjournal.issue.noArticles"}</p>
                </div>
            {/if}
        </section>

        {* Right: issue facts, downloads, sharing, links *}
        <aside class="jcrtp-issue__aside" aria-label="{translate|escape key="plugins.themes.editorialjournal.page.relatedInfo"}">
            <section class="jcrtp-card jcrtp-issue-info" aria-labelledby="jcrtp-issue-info">
                <h2 class="jcrtp-card__title" id="jcrtp-issue-info">{include file="frontend/components/jcrtp/icon.tpl" name="info" size=26}{translate key="plugins.themes.editorialjournal.issue.information"}</h2>
                <dl class="jcrtp-facts-list">
                    {if $issue->getShowVolume() && $issue->getVolume()}<div><dt>{translate key="issue.volume"}</dt><dd>{$issue->getVolume()|escape}</dd></div>{/if}
                    {if $issue->getShowNumber() && $issue->getNumber()}<div><dt>{translate key="issue.issue"}</dt><dd>{$issue->getNumber()|escape}</dd></div>{/if}
                    {if $issue->getDatePublished()}<div><dt>{translate key="plugins.themes.editorialjournal.issue.publicationDate"}</dt><dd>{$issue->getDatePublished()|date_format:"F Y"}</dd></div>{/if}
                    <div><dt>{translate key="plugins.themes.editorialjournal.issue.totalArticles"}</dt><dd>{$jcrtpIssueArticleCount|escape}</dd></div>
                    {if $jcrtpIssuePageRange}<div><dt>{translate key="plugins.themes.editorialjournal.issue.pagesLabel"}</dt><dd>{$jcrtpIssuePageRange|escape}</dd></div>{/if}
                    {assign var=doiObject value=$issue->getData('doiObject')}
                    {if $doiObject}<div><dt>DOI</dt><dd><a href="{$doiObject->getData('resolvingUrl')|escape}">{$doiObject->getData('doi')|escape}</a></dd></div>{/if}
                    {foreach from=$pubIdPlugins item=pubIdPlugin}
                        {assign var=pubId value=$issue->getStoredPubId($pubIdPlugin->getPubIdType())}
                        {if $pubId}
                            {assign var="resolvingUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)}
                            <div><dt>{$pubIdPlugin->getPubIdDisplayType()|escape}</dt><dd>{if $resolvingUrl}<a href="{$resolvingUrl|escape}">{$pubId|escape}</a>{else}{$pubId|escape}{/if}</dd></div>
                        {/if}
                    {/foreach}
                    {if $issue->getDatePublished()}<div><dt>{translate key="submissions.published"}</dt><dd>{$issue->getDatePublished()|date_format:"j F Y"}</dd></div>{/if}
                </dl>
            </section>

            {assign var=jcrtpUploadedCover value=$issue->getLocalizedCoverImageUrl()}
            {if $issueGalleys || $jcrtpUploadedCover}
                <section class="jcrtp-card" aria-labelledby="jcrtp-issue-download">
                    <h2 class="jcrtp-card__title" id="jcrtp-issue-download">{include file="frontend/components/jcrtp/icon.tpl" name="download" size=26}{translate key="plugins.themes.editorialjournal.issue.download"}</h2>
                    <ul class="jcrtp-link-list">
                        {foreach from=$issueGalleys item=issueGalley}
                            <li>
                                {if $hasAccess}
                                    <a href="{url page="issue" op="download" path=$issue->getBestIssueId()|to_array:$issueGalley->getBestGalleyId()}">{include file="frontend/components/jcrtp/icon.tpl" name="pdf" size=20}<span>{$issueGalley->getGalleyLabel()|escape}</span>{include file="frontend/components/jcrtp/icon.tpl" name="download" size=16}</a>
                                {else}
                                    {include file="frontend/objects/galley_link.tpl" parent=$issue galley=$issueGalley id="" labelledBy="" purchaseFee=$currentJournal->getData('purchaseIssueFee') purchaseCurrency=$currentJournal->getData('currency')}
                                {/if}
                            </li>
                        {/foreach}
                        {if $jcrtpUploadedCover}
                            <li><a href="{$jcrtpUploadedCover|escape}" download>{include file="frontend/components/jcrtp/icon.tpl" name="document" size=20}<span>{translate key="plugins.themes.editorialjournal.issue.frontCover"}</span>{include file="frontend/components/jcrtp/icon.tpl" name="download" size=16}</a></li>
                        {/if}
                    </ul>
                </section>
            {/if}

            {capture assign=jcrtpShareUrl}{$jcrtpIssueUrl|escape:'url'}{/capture}
            {capture assign=jcrtpShareText}{$currentJournal->getLocalizedName()|cat:' — '|cat:$jcrtpIssueLabel|escape:'url'}{/capture}
            <section class="jcrtp-card" aria-labelledby="jcrtp-issue-share">
                <h2 class="jcrtp-card__title" id="jcrtp-issue-share">{include file="frontend/components/jcrtp/icon.tpl" name="share" size=26}{translate key="plugins.themes.editorialjournal.issue.share"}</h2>
                <ul class="jcrtp-share">
                    <li><a class="jcrtp-share--linkedin" href="https://www.linkedin.com/sharing/share-offsite/?url={$jcrtpShareUrl}" rel="noopener" target="_blank" aria-label="{translate|escape key="plugins.themes.editorialjournal.issue.shareOn" network="LinkedIn"}"><svg aria-hidden="true" focusable="false" viewBox="0 0 24 24"><path fill="currentColor" d="M6.9 8.6H3.6V20h3.3zM5.3 3.5a1.9 1.9 0 1 0 0 3.8 1.9 1.9 0 0 0 0-3.8M20.4 13.4c0-3.1-1.7-4.9-4.3-4.9-1.6 0-2.6.8-3.1 1.6V8.6H9.8V20h3.3v-6c0-1.5.6-2.6 2-2.6 1.3 0 1.9 1 1.9 2.6v6h3.4z"/></svg></a></li>
                    <li><a class="jcrtp-share--x" href="https://x.com/intent/post?url={$jcrtpShareUrl}&amp;text={$jcrtpShareText}" rel="noopener" target="_blank" aria-label="{translate|escape key="plugins.themes.editorialjournal.issue.shareOn" network="X"}"><svg aria-hidden="true" focusable="false" viewBox="0 0 24 24"><path fill="currentColor" d="M17.8 3.5h3.1l-6.8 7.8 8 10.2h-6.3l-4.9-6.4-5.6 6.4H2.2l7.3-8.3L1.8 3.5h6.4l4.4 5.9zm-1.1 16.2h1.7L7.4 5.2H5.6z"/></svg></a></li>
                    <li><a class="jcrtp-share--facebook" href="https://www.facebook.com/sharer/sharer.php?u={$jcrtpShareUrl}" rel="noopener" target="_blank" aria-label="{translate|escape key="plugins.themes.editorialjournal.issue.shareOn" network="Facebook"}"><svg aria-hidden="true" focusable="false" viewBox="0 0 24 24"><path fill="currentColor" d="M13.6 21v-7.9h2.7l.4-3.1h-3.1V8c0-.9.3-1.5 1.6-1.5h1.6V3.7c-.3 0-1.3-.1-2.4-.1-2.4 0-4 1.4-4 4.1V10H7.7v3.1h2.7V21z"/></svg></a></li>
                    <li><a class="jcrtp-share--whatsapp" href="https://wa.me/?text={$jcrtpShareText}%20{$jcrtpShareUrl}" rel="noopener" target="_blank" aria-label="{translate|escape key="plugins.themes.editorialjournal.issue.shareOn" network="WhatsApp"}"><svg aria-hidden="true" focusable="false" viewBox="0 0 24 24"><path fill="currentColor" d="M12 2.2a9.7 9.7 0 0 0-8.4 14.6L2.3 21.8l5.1-1.3A9.7 9.7 0 1 0 12 2.2m0 17.7c-1.5 0-2.9-.4-4.1-1.1l-.3-.2-3 .8.8-2.9-.2-.3A8 8 0 1 1 12 19.9m4.4-6c-.2-.1-1.4-.7-1.7-.8-.2-.1-.4-.1-.5.1l-.8 1c-.1.2-.3.2-.5.1a6.6 6.6 0 0 1-3.3-2.9c-.2-.4.2-.4.7-1.3.1-.2 0-.3 0-.4l-.8-1.8c-.2-.5-.4-.4-.5-.4h-.5a.9.9 0 0 0-.6.3 2.7 2.7 0 0 0-.8 2c0 1.2.9 2.3 1 2.5.1.2 1.7 2.6 4.2 3.7 1.6.7 2.2.7 3 .6.5-.1 1.4-.6 1.6-1.1.2-.6.2-1 .1-1.1z"/></svg></a></li>
                    <li><a class="jcrtp-share--email" href="mailto:?subject={$jcrtpShareText}&amp;body={$jcrtpShareUrl}" aria-label="{translate|escape key="plugins.themes.editorialjournal.issue.shareOn" network="email"}">{include file="frontend/components/jcrtp/icon.tpl" name="mail" size=20}</a></li>
                </ul>
            </section>

            <section class="jcrtp-card" aria-labelledby="jcrtp-issue-links">
                <h2 class="jcrtp-card__title" id="jcrtp-issue-links">{include file="frontend/components/jcrtp/icon.tpl" name="link" size=26}{translate key="plugins.themes.editorialjournal.issue.relatedLinks"}</h2>
                <ul class="jcrtp-link-list jcrtp-link-list--chevron">
                    <li><a href="{url page="issue" op="archive"}"><span>{translate key="plugins.themes.editorialjournal.issue.allIssues"}</span>{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                    {if $currentJournal->getData('enableAnnouncements')}
                        <li><a href="{url page="announcement"}"><span>{translate key="announcement.announcements"}</span>{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                    {/if}
                    <li><a href="{url page="about" op="submissions"}"><span>{translate key="plugins.themes.editorialjournal.home.authorGuidelines"}</span>{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                    {if !$currentJournal->getData('disableSubmissions')}
                        <li><a href="{url page="submission"}"><span>{translate key="plugins.themes.editorialjournal.header.submitManuscript"}</span>{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                    {/if}
                </ul>
            </section>
        </aside>
    </div>
{/if}
</div>

{include file="frontend/components/footer.tpl" isFullWidth=true}
