{**
 * Homepage Latest Articles column: the three most recently published OJS
 * articles ($jcrtpLatestArticles, newest first). Galley (PDF) links reuse the
 * core frontend/objects/galley_link.tpl with the same access rules as the
 * theme's article_summary.tpl.
 *}
<section class="jcrtp-home-panel jcrtp-latest" aria-labelledby="jcrtp-latest-heading">
    <div class="jcrtp-home-panel__head">
        <h2 id="jcrtp-latest-heading">{translate key="plugins.themes.editorialjournal.latestArticles"}</h2>
        {if $jcrtpLatestArticles}
            <a class="jcrtp-more-link" href="{url page="issue" op="archive"}">{translate key="plugins.themes.editorialjournal.home.viewAllArticles"} <span aria-hidden="true">→</span></a>
        {/if}
    </div>

    {if $jcrtpLatestArticles}
        <ol class="jcrtp-latest__list">
            {foreach from=$jcrtpLatestArticles item=article}
                {assign var=publication value=$article->getCurrentPublication()}
                {assign var=articlePath value=$publication->getData('urlPath')|default:$article->getId()}
                {capture assign=articleUrl}{url page="article" op="view" path=$articlePath}{/capture}
                {assign var=sectionTitle value=$jcrtpSectionTitles[$publication->getData('sectionId')]|default:''}
                {assign var=coverImage value=$publication->getLocalizedData('coverImage')}
                <li class="jcrtp-article-card">
                    <a class="jcrtp-article-card__thumb" href="{$articleUrl}" tabindex="-1" aria-hidden="true">
                        {if $coverImage}
                            <img src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}" alt="" loading="lazy">
                        {else}
                            <span class="jcrtp-article-card__placeholder"></span>
                        {/if}
                    </a>
                    <div class="jcrtp-article-card__body">
                        <div class="jcrtp-article-card__meta">
                            {if $sectionTitle}<span class="jcrtp-badge jcrtp-badge--{$publication->getData('sectionId') % 3}">{$sectionTitle|escape}</span>{/if}
                            {if $publication->getData('datePublished')}
                                <time datetime="{$publication->getData('datePublished')|date_format:'Y-m-d'}">{$publication->getData('datePublished')|date_format:"d M Y"}</time>
                            {/if}
                        </div>
                        <h3 class="jcrtp-article-card__title">
                            <a id="jcrtp-latest-{$article->getId()}" href="{$articleUrl}">{$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}</a>
                        </h3>
                        {if $publication->getData('hideAuthor') != APP\submission\Submission::AUTHOR_TOC_HIDE && $publication->getShortAuthorString()}
                            <p class="jcrtp-article-card__authors">{$publication->getShortAuthorString()|escape}</p>
                        {/if}
                        {assign var=articleGalleys value=$publication->getData('galleys')}
                        {if $articleGalleys && $articleGalleys->count()}
                            {assign var="hasArticleAccess" value=$hasAccess}
                            {if $currentContext->getSetting('publishingMode') == APP\journal\Journal::PUBLISHING_MODE_OPEN || $publication->getData('accessStatus') == APP\submission\Submission::ARTICLE_ACCESS_OPEN}
                                {assign var="hasArticleAccess" value=1}
                            {/if}
                            <ul class="galleys_links jcrtp-article-card__galleys">
                                {foreach from=$articleGalleys item=galley}
                                    {if $primaryGenreIds}
                                        {assign var="file" value=$galley->getFile()}
                                        {if !$galley->getData('urlRemote') && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
                                            {continue}
                                        {/if}
                                    {/if}
                                    {assign var="id" value="jcrtp-latest-{$article->getId()}-galley-{$galley->getId()}"}
                                    <li>{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication id=$id labelledBy="{$id} jcrtp-latest-{$article->getId()}" hasAccess=$hasArticleAccess purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}</li>
                                {/foreach}
                            </ul>
                        {/if}
                    </div>
                </li>
            {/foreach}
        </ol>
    {else}
        <div class="jcrtp-empty">
            <span class="jcrtp-empty-icon" aria-hidden="true"><svg viewBox="0 0 40 40" focusable="false"><path fill="none" stroke="currentColor" stroke-width="2.2" stroke-linejoin="round" d="M20 11c-4-3-9-4-15-3v22c6-1 11 0 15 3 4-3 9-4 15-3V8c-6-1-11 0-15 3zm0 0v22"/></svg></span>
            <p>{translate key="plugins.themes.editorialjournal.home.noArticles"}</p>
            <a class="jcrtp-more-link" href="{url page="about" op="submissions"}">{translate key="plugins.themes.editorialjournal.home.authorGuidelines"} <span aria-hidden="true">→</span></a>
        </div>
    {/if}
</section>
