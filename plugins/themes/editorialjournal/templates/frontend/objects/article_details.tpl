{**
 * plugins/themes/editorialjournal/templates/frontend/objects/article_details.tpl
 *
 * Article metadata in the inner-page design: main column (authors with
 * affiliations/ROR/ORCID, DOI, abstract, keywords, plugin output, usage
 * chart, biographies, references, data availability) and a sidebar (PDF and
 * other galleys, article information, on-this-page links, licence, and the
 * Templates::Article::Details output such as "How to Cite").
 *
 * Mirrors the OJS 3.5 core article_details.tpl: same data, same access rules
 * (core frontend/objects/galley_link.tpl), the same hooks
 * (Templates::Article::Main, Templates::Article::Details,
 * Templates::Article::Details::Reference) and the same .item class names
 * used by citation and statistics plugins. The title is the page banner's h1
 * (frontend/pages/article.tpl).
 *}
{assign var=doiObject value=$article->getCurrentPublication()->getData('doiObject')}
{assign var=jcrtpHasAbstract value=$publication->getLocalizedData('abstract')}
{assign var=jcrtpHasKeywords value=!empty($publication->getLocalizedData('keywords'))}
{assign var=jcrtpHasReferences value=count($parsedCitations) || (string) $publication->getData('citationsRaw')}
{assign var="hasBiographies" value=0}
{foreach from=$publication->getData('authors') item=author}
    {if $author->getLocalizedData('biography')}
        {assign var="hasBiographies" value=$hasBiographies+1}
    {/if}
{/foreach}

<article class="obj_article_details jcrtp-article">

    {* Preview / outdated-version notices (as in core) *}
    {if $publication->getData('status') !== PKP\submission\PKPSubmission::STATUS_PUBLISHED}
        <div class="jcrtp-article__notice cmp_notification notice">
            {capture assign="submissionUrl"}{url page="dashboard" op="editorial" workflowSubmissionId=$article->getId()}{/capture}
            {translate key="submission.viewingPreview" url=$submissionUrl}
        </div>
    {elseif $currentPublication->getId() !== $publication->getId()}
        <div class="jcrtp-article__notice cmp_notification notice">
            {capture assign="latestVersionUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
            {translate key="submission.outdatedVersion"
                datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort
                urlRecentVersion=$latestVersionUrl|escape
            }
        </div>
    {/if}

    <div class="jcrtp-inner__body jcrtp-article__layout">
        <div class="jcrtp-article__main">

            {if $publication->getData('authors')}
                <section class="item authors jcrtp-article__authors" aria-labelledby="jcrtp-article-authors">
                    <h2 class="pkp_screen_reader" id="jcrtp-article-authors">{translate key="article.authors"}</h2>
                    <ul class="jcrtp-author-list">
                        {foreach from=$publication->getData('authors') item=author}
                            <li class="jcrtp-author">
                                <span class="name">{$author->getFullName()|escape}</span>
                                {assign var=authorUserGroup value=$userGroupsById[$author->getData('userGroupId')]}
                                {if $authorUserGroup && $authorUserGroup->showTitle}
                                    <span class="userGroup">{$authorUserGroup->getLocalizedData('name')|escape}</span>
                                {/if}
                                {if count($author->getAffiliations()) > 0}
                                    <span class="affiliation">
                                        {assign var="renderedAffiliation" value=false}
                                        {foreach from=$author->getAffiliations() item="affiliation"}
                                            {if $affiliation->getLocalizedName() || $affiliation->getRor()}
                                                {if $renderedAffiliation}{translate key="common.commaListSeparator"}{/if}
                                                {if $affiliation->getLocalizedName()}<span>{$affiliation->getLocalizedName()|escape}</span>{/if}
                                                {if $affiliation->getRor()}<a href="{$affiliation->getRor()|escape}">{$rorIdIcon}</a>{/if}
                                                {assign var="renderedAffiliation" value=true}
                                            {/if}
                                        {/foreach}
                                    </span>
                                {/if}
                                {if $author->getData('orcid')}
                                    <span class="orcid">
                                        {if $author->hasVerifiedOrcid()}{$orcidIcon}{else}{$orcidUnauthenticatedIcon}{/if}
                                        <a href="{$author->getData('orcid')|escape}" target="_blank">{$author->getOrcidDisplayValue()|escape}</a>
                                    </span>
                                {/if}
                            </li>
                        {/foreach}
                    </ul>
                </section>
            {/if}

            {if $doiObject}
                {assign var="doiUrl" value=$doiObject->getData('resolvingUrl')|escape}
                <section class="item doi jcrtp-article__doi">
                    <h2 class="label">
                        {capture assign=translatedDOI}{translate key="doi.readerDisplayName"}{/capture}
                        {translate key="semicolon" label=$translatedDOI}
                    </h2>
                    <span class="value"><a href="{$doiUrl}">{$doiUrl}</a></span>
                </section>
            {/if}

            {* Small screens: the sidebar follows the article, so the primary
               galleys are repeated here (hidden on wider screens). *}
            {if $primaryGalleys}
                <ul class="jcrtp-article__quick galleys_links jcrtp-galley-buttons">
                    {foreach from=$primaryGalleys item=galley}
                        <li>{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley id="" labelledBy="" isSupplementary="" purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}</li>
                    {/foreach}
                </ul>
            {/if}

            {if $jcrtpHasAbstract}
                <section class="item abstract jcrtp-article__section" id="article-abstract">
                    <h2 class="label">{translate key="article.abstract"}</h2>
                    <div class="jcrtp-prose">{$publication->getLocalizedData('abstract')|strip_unsafe_html}</div>
                </section>
            {/if}

            {if $jcrtpHasKeywords}
                <section class="item keywords jcrtp-article__section" id="article-keywords">
                    <h2 class="label">
                        {capture assign=translatedKeywords}{translate key="article.subject"}{/capture}
                        {translate key="semicolon" label=$translatedKeywords}
                    </h2>
                    <ul class="value jcrtp-keywords">
                        {foreach from=$publication->getLocalizedData('keywords') item="keyword"}
                            <li>{$keyword.name|escape}</li>
                        {/foreach}
                    </ul>
                </section>
            {/if}

            {call_hook name="Templates::Article::Main"}

            {* Usage statistics chart (parent theme option, as in core) *}
            {if $activeTheme && $activeTheme->getOption('displayStats') != 'none'}
                {$activeTheme->displayUsageStatsGraph($article->getId())}
                <section class="item downloads_chart jcrtp-article__section">
                    <h2 class="label">{translate key="plugins.themes.default.displayStats.downloads"}</h2>
                    <div class="value">
                        <canvas class="usageStatsGraph" data-object-type="Submission" data-object-id="{$article->getId()|escape}"></canvas>
                        <div class="usageStatsUnavailable" data-object-type="Submission" data-object-id="{$article->getId()|escape}">
                            {translate key="plugins.themes.default.displayStats.noStats"}
                        </div>
                    </div>
                </section>
            {/if}

            {if $hasBiographies}
                <section class="item author_bios jcrtp-article__section" id="article-biographies">
                    <h2 class="label">
                        {if $hasBiographies > 1}{translate key="submission.authorBiographies"}{else}{translate key="submission.authorBiography"}{/if}
                    </h2>
                    <ul class="authors jcrtp-bios">
                        {foreach from=$publication->getData('authors') item=author}
                            {if $author->getLocalizedData('biography')}
                                <li class="sub_item">
                                    <div class="label">
                                        {if $author->getLocalizedAffiliationNamesAsString()}
                                            {capture assign="authorName"}{$author->getFullName()|escape}{/capture}
                                            {capture assign="authorAffiliations"} {$author->getLocalizedAffiliationNamesAsString(null, ', ')|escape} {/capture}
                                            {translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliations}
                                        {else}
                                            {$author->getFullName()|escape}
                                        {/if}
                                    </div>
                                    <div class="value jcrtp-prose">{$author->getLocalizedData('biography')|strip_unsafe_html}</div>
                                </li>
                            {/if}
                        {/foreach}
                    </ul>
                </section>
            {/if}

            {if $jcrtpHasReferences}
                <section class="item references jcrtp-article__section" id="article-references">
                    <h2 class="label">{translate key="submission.citations"}</h2>
                    <div class="value jcrtp-references">
                        {if count($parsedCitations)}
                            {foreach from=$parsedCitations item="parsedCitation"}
                                <p>{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</p>
                            {/foreach}
                        {else}
                            {$publication->getData('citationsRaw')|escape|nl2br}
                        {/if}
                    </div>
                </section>
            {/if}

            {if $publication->getLocalizedData('dataAvailability')}
                <section class="item dataAvailability jcrtp-article__section" id="data-availability-statement">
                    <h2 class="label">{translate key="submission.dataAvailability"}</h2>
                    <div class="jcrtp-prose">{$publication->getLocalizedData('dataAvailability')|strip_unsafe_html}</div>
                </section>
            {/if}
        </div><!-- .jcrtp-article__main -->

        <aside class="jcrtp-article__aside" aria-label="{translate|escape key="plugins.themes.editorialjournal.page.relatedInfo"}">

            {if $primaryGalleys || $supplementaryGalleys}
                <section class="jcrtp-card item galleys" id="article-downloads" aria-labelledby="jcrtp-article-downloads">
                    <h2 class="jcrtp-card__title" id="jcrtp-article-downloads">{include file="frontend/components/jcrtp/icon.tpl" name="download" size=24}{translate key="submission.downloads"}</h2>
                    <div class="jcrtp-card__body">
                        {if $primaryGalleys}
                            <ul class="value galleys_links jcrtp-galley-buttons">
                                {foreach from=$primaryGalleys item=galley}
                                    <li>{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley id="" labelledBy="" isSupplementary="" purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}</li>
                                {/foreach}
                            </ul>
                        {/if}
                        {if $supplementaryGalleys}
                            <h3 class="jcrtp-card__subheading">{translate key="submission.additionalFiles"}</h3>
                            <ul class="value supplementary_galleys_links jcrtp-galley-buttons jcrtp-galley-buttons--secondary">
                                {foreach from=$supplementaryGalleys item=galley}
                                    <li>{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley id="" labelledBy="" isSupplementary="1"}</li>
                                {/foreach}
                            </ul>
                        {/if}
                    </div>
                </section>
            {/if}

            <section class="jcrtp-card jcrtp-article__info" aria-labelledby="jcrtp-article-info">
                <h2 class="jcrtp-card__title" id="jcrtp-article-info">{include file="frontend/components/jcrtp/icon.tpl" name="info" size=24}{translate key="plugins.themes.editorialjournal.article.information"}</h2>
                <dl class="jcrtp-facts-list">
                    {if $publication->getData('datePublished')}
                        <div class="item published">
                            <dt>{translate key="submissions.published"}</dt>
                            <dd>{$firstPublication->getData('datePublished')|date_format:"j F Y"}</dd>
                        </div>
                        {if $firstPublication->getId() !== $publication->getId()}
                            <div><dt>{translate key="plugins.themes.editorialjournal.article.updated"}</dt><dd>{$publication->getData('datePublished')|date_format:"j F Y"}</dd></div>
                        {/if}
                    {/if}
                    {if $issue}
                        <div><dt>{translate key="issue.issue"}</dt><dd><a class="title" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">{include file="frontend/components/jcrtp/issueLabel.tpl" issue=$issue}</a></dd></div>
                    {/if}
                    {if $section}
                        <div><dt>{translate key="section.section"}</dt><dd>{$section->getLocalizedTitle()|escape}</dd></div>
                    {/if}
                    {if $publication->getData('pages')}
                        <div><dt>{translate key="plugins.themes.editorialjournal.issue.pagesLabel"}</dt><dd>{$publication->getData('pages')|escape}</dd></div>
                    {/if}
                    {if $doiObject}
                        <div><dt>DOI</dt><dd><a href="{$doiObject->getData('resolvingUrl')|escape}">{$doiObject->getData('doi')|escape}</a></dd></div>
                    {/if}
                    {foreach from=$pubIdPlugins item=pubIdPlugin}
                        {if $pubIdPlugin->getPubIdType() == 'doi'}{continue}{/if}
                        {assign var=pubId value=$publication->getStoredPubId($pubIdPlugin->getPubIdType())}
                        {if $pubId}
                            <div class="item pubid">
                                <dt>{$pubIdPlugin->getPubIdDisplayType()|escape}</dt>
                                <dd>
                                    {if $pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
                                        <a id="pub-id::{$pubIdPlugin->getPubIdType()|escape}" href="{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}">{$pubId|escape}</a>
                                    {else}
                                        {$pubId|escape}
                                    {/if}
                                </dd>
                            </div>
                        {/if}
                    {/foreach}
                    {if $categories}
                        <div>
                            <dt>{translate key="category.category"}</dt>
                            <dd>
                                <ul class="categories">
                                    {foreach from=$categories item=category}
                                        <li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="catalog" op="category" path=$category->getPath()|escape}">{$category->getLocalizedTitle()|escape}</a></li>
                                    {/foreach}
                                </ul>
                            </dd>
                        </div>
                    {/if}
                </dl>
                {if count($article->getPublishedPublications()) > 1}
                    <div class="jcrtp-card__body versions">
                        <h3 class="jcrtp-card__subheading">{translate key="submission.versions"}</h3>
                        <ul class="jcrtp-versions">
                            {foreach from=array_reverse($article->getPublishedPublications()) item=iPublication}
                                {capture assign="name"}{translate key="submission.versionIdentity" datePublished=$iPublication->getData('datePublished')|date_format:$dateFormatShort version=$iPublication->getData('version')}{/capture}
                                <li>
                                    {if $iPublication->getId() === $publication->getId()}
                                        {$name}
                                    {elseif $iPublication->getId() === $currentPublication->getId()}
                                        <a href="{url page="article" op="view" path=$article->getBestId()}">{$name}</a>
                                    {else}
                                        <a href="{url page="article" op="view" path=$article->getBestId()|to_array:"version":$iPublication->getId()}">{$name}</a>
                                    {/if}
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}
            </section>

            {if $jcrtpHasAbstract || $jcrtpHasKeywords || $jcrtpHasReferences || $hasBiographies}
                <nav class="jcrtp-card jcrtp-section-nav" aria-labelledby="jcrtp-article-toc">
                    <h2 class="jcrtp-card__title" id="jcrtp-article-toc">{include file="frontend/components/jcrtp/icon.tpl" name="document" size=24}{translate key="plugins.themes.editorialjournal.page.onThisPage"}</h2>
                    <ul>
                        {if $jcrtpHasAbstract}<li><a href="#article-abstract">{translate key="article.abstract"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>{/if}
                        {if $jcrtpHasKeywords}<li><a href="#article-keywords">{translate key="article.subject"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>{/if}
                        {if $hasBiographies}<li><a href="#article-biographies">{if $hasBiographies > 1}{translate key="submission.authorBiographies"}{else}{translate key="submission.authorBiography"}{/if}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>{/if}
                        {if $jcrtpHasReferences}<li><a href="#article-references">{translate key="submission.citations"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>{/if}
                    </ul>
                </nav>
            {/if}

            {* Article or issue cover (as in core) *}
            {if $publication->getLocalizedData('coverImage') || ($issue && $issue->getLocalizedCoverImage())}
                <div class="jcrtp-card item cover_image jcrtp-article__cover">
                    {if $publication->getLocalizedData('coverImage')}
                        {assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
                        <img src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}" alt="{$coverImage.altText|escape|default:''}">
                    {else}
                        <a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
                            <img src="{$issue->getLocalizedCoverImageUrl()|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}">
                        </a>
                    {/if}
                </div>
            {/if}

            {if $currentContext->getLocalizedData('licenseTerms') || $publication->getData('licenseUrl')}
                <section class="jcrtp-card item copyright" aria-labelledby="jcrtp-article-license">
                    <h2 class="jcrtp-card__title label" id="jcrtp-article-license">{include file="frontend/components/jcrtp/icon.tpl" name="openaccess" size=24}{translate key="submission.license"}</h2>
                    <div class="jcrtp-card__body jcrtp-prose">
                        {if $publication->getData('licenseUrl')}
                            {if $ccLicenseBadge}
                                {if $publication->getLocalizedData('copyrightHolder')}
                                    <p>{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}</p>
                                {/if}
                                {$ccLicenseBadge}
                            {else}
                                <a href="{$publication->getData('licenseUrl')|escape}" class="copyright">
                                    {if $publication->getLocalizedData('copyrightHolder')}
                                        {translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}
                                    {else}
                                        {translate key="submission.license"}
                                    {/if}
                                </a>
                            {/if}
                        {/if}
                        {$currentContext->getLocalizedData('licenseTerms')}
                    </div>
                </section>
            {/if}

            <div class="jcrtp-article__plugins">
                {call_hook name="Templates::Article::Details"}
            </div>
        </aside>
    </div>
</article>
