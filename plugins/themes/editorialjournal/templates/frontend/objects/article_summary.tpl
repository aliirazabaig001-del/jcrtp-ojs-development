{**
 * Theme article summary with dynamically available publication metadata.
 * OJS continues to supply the article, authors, section and galley data.
 *}
{assign var=publication value=$article->getCurrentPublication()}
{assign var=articlePath value=$publication->getData('urlPath')|default:$article->getId()}
{if !$heading}
    {assign var="heading" value="h2"}
{/if}

{if (!$section.hideAuthor && $publication->getData('hideAuthor') == APP\submission\Submission::AUTHOR_TOC_DEFAULT) || $publication->getData('hideAuthor') == APP\submission\Submission::AUTHOR_TOC_SHOW}
    {assign var="showAuthor" value=true}
{/if}

<div class="obj_article_summary">
    {if $publication->getLocalizedData('coverImage')}
        <div class="cover">
            <a {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if} class="file">
                {assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
                <img src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}" alt="{$coverImage.altText|escape|default:''}" loading="lazy">
            </a>
        </div>
    {/if}

    <{$heading} class="title">
        <a id="article-{$article->getId()}" {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if}>
            {if $currentContext}
                {$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}
                {assign var=localizedSubtitle value=$publication->getLocalizedSubtitle(null, 'html')|strip_unsafe_html}
                {if $localizedSubtitle}<span class="subtitle">{$localizedSubtitle}</span>{/if}
            {else}
                {$publication->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}
                <span class="subtitle">{$journal->getLocalizedName()|escape}</span>
            {/if}
        </a>
    </{$heading}>

    {assign var=submissionPages value=$publication->getData('pages')}
    {assign var=submissionDatePublished value=$publication->getData('datePublished')}
    {if $showAuthor || $submissionPages || ($submissionDatePublished && $showDatePublished)}
        <div class="meta">
            {if $showAuthor}
                <div class="authors">{$publication->getAuthorString($authorUserGroups)|escape}</div>
            {/if}
            {if $submissionPages}<div class="pages">{$submissionPages|escape}</div>{/if}
            {if $showDatePublished && $submissionDatePublished}
                <div class="published">{$submissionDatePublished|date_format:$dateFormatShort}</div>
            {/if}
        </div>
    {/if}

    {assign var=doiObject value=$publication->getData('doiObject')}
    {if $doiObject}
        <p class="jcrtp-article-doi">
            {capture assign=translatedDOI}{translate key="doi.readerDisplayName"}{/capture}
            <span>{$translatedDOI|escape}:</span>
            <a href="{$doiObject->getData('resolvingUrl')|escape}">{$doiObject->getData('resolvingUrl')|escape}</a>
        </p>
    {/if}

    <p class="jcrtp-article-summary-link">
        <a {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if}>{translate key="plugins.themes.editorialjournal.articleReadAbstract"} <span aria-hidden="true">→</span></a>
    </p>

    {if !$hideGalleys}
        <ul class="galleys_links">
            {foreach from=$publication->getData('galleys') item=galley}
                {if $primaryGenreIds}
                    {assign var="file" value=$galley->getFile()}
                    {if !$galley->getData('urlRemote') && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
                        {continue}
                    {/if}
                {/if}
                <li>
                    {assign var="hasArticleAccess" value=$hasAccess}
                    {if $currentContext->getSetting('publishingMode') == APP\journal\Journal::PUBLISHING_MODE_OPEN || $publication->getData('accessStatus') == APP\submission\Submission::ARTICLE_ACCESS_OPEN}
                        {assign var="hasArticleAccess" value=1}
                    {/if}
                    {assign var="id" value="article-{$article->getId()}-galley-{$galley->getId()}"}
                    {include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication id=$id labelledBy="{$id} article-{$article->getId()}" hasAccess=$hasArticleAccess purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
                </li>
            {/foreach}
        </ul>
    {/if}

    {call_hook name="Templates::Issue::Issue::Article"}
</div>
