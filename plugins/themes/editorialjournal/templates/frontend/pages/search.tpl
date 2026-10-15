{**
 * plugins/themes/editorialjournal/templates/frontend/pages/search.tpl
 *
 * Search in the inner-page design: a filter card beside the results.
 * Replaces the OJS 3.5 core search.tpl and keeps its form fields and names,
 * {block} names, hooks (Templates::Search::SearchResults::AdditionalFilters,
 * ::PreResults), the results iterator, screen-reader result count, error and
 * no-results notices, and the core page_info/page_links pagination.
 *}
{include file="frontend/components/header.tpl" pageTitle="common.search" isFullWidth=true}

{if !$heading}
    {assign var="heading" value="h2"}
{/if}

<div class="page page_search jcrtp-inner jcrtp-search">
    {capture assign=jcrtpBannerTitle}{translate key="common.search"}{/capture}
    {capture assign=jcrtpBannerSummary}{translate key="plugins.themes.editorialjournal.search.summary"}{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$jcrtpBannerTitle bannerSummary=$jcrtpBannerSummary bannerCrumbs="" bannerCurrent="" bannerEyebrow="" bannerSubtitle=""}

    <div class="jcrtp-inner__body jcrtp-search__layout">
        <aside class="jcrtp-search__filters">
            {capture name="searchFormUrl"}{url escape=false}{/capture}
            {assign var=formUrlParameters value=[]}{* Prevent Smarty warning *}
            {$smarty.capture.searchFormUrl|parse_url:$smarty.const.PHP_URL_QUERY|default:""|parse_str:$formUrlParameters}
            <form class="cmp_form jcrtp-card jcrtp-search-form" method="get" action="{$smarty.capture.searchFormUrl|strtok:"?"|escape}" role="form" aria-labelledby="jcrtp-search-form-heading">
                <h2 class="jcrtp-card__title" id="jcrtp-search-form-heading">{include file="frontend/components/jcrtp/icon.tpl" name="search" size=24}{translate key="plugins.themes.editorialjournal.search.refine"}</h2>
                <div class="jcrtp-card__body">
                    {foreach from=$formUrlParameters key=paramKey item=paramValue}
                        <input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}"/>
                    {/foreach}

                    <div class="search_input">
                        <label class="label" for="query">{translate key="search.searchFor"}</label>
                        {block name=searchQuery}
                            <input type="text" id="query" name="query" value="{$query|escape}" class="query" placeholder="{translate|escape key="common.search"}">
                        {/block}
                    </div>

                    <fieldset class="search_advanced">
                        <legend>{translate key="search.advancedFilters"}</legend>
                        <div class="date_range">
                            <div class="from">
                                {capture assign="dateFromLegend"}{translate key="search.dateFrom"}{/capture}
                                {html_select_date_a11y legend=$dateFromLegend prefix="dateFrom" time=$dateFrom start_year=$yearStart end_year=$yearEnd}
                            </div>
                            <div class="to">
                                {capture assign="dateFromTo"}{translate key="search.dateTo"}{/capture}
                                {html_select_date_a11y legend=$dateFromTo prefix="dateTo" time=$dateTo start_year=$yearStart end_year=$yearEnd}
                            </div>
                        </div>
                        <div class="author">
                            <label class="label" for="authors">{translate key="search.author"}</label>
                            {block name=searchAuthors}
                                <input type="text" id="authors" name="authors" value="{$authors|escape}">
                            {/block}

                            {if $searchableContexts}
                                <label class="label label_contexts" for="searchJournal">{translate key="search.journal"}</label>
                                <select name="searchJournal" id="searchJournal">
                                    <option></option>
                                    {foreach from=$searchableContexts item="searchableContext"}
                                        <option value="{$searchableContext->id}" {if $searchJournal == $searchableContext->id}selected{/if}>
                                            {$searchableContext->name|escape}
                                        </option>
                                    {/foreach}
                                </select>
                            {/if}
                        </div>
                        {call_hook name="Templates::Search::SearchResults::AdditionalFilters"}
                    </fieldset>

                    <div class="submit">
                        <button class="submit jcrtp-search-form__submit" type="submit">{include file="frontend/components/jcrtp/icon.tpl" name="search" size=18}{translate key="common.search"}</button>
                    </div>
                </div>
            </form>
        </aside>

        <section class="jcrtp-search__results" id="results" aria-labelledby="jcrtp-search-results-heading">
            {call_hook name="Templates::Search::SearchResults::PreResults"}

            <h2 class="jcrtp-inner__heading" id="jcrtp-search-results-heading">{translate key="search.searchResults"}</h2>

            {if !$results->wasEmpty()}
                {assign var="count" value=$results->count}
                <p class="jcrtp-search__count" role="status">
                    {if $results->count > 1}
                        {translate key="search.searchResults.foundPlural" count=$results->count}
                    {else}
                        {translate key="search.searchResults.foundSingle"}
                    {/if}
                </p>
            {/if}

            <ul class="search_results jcrtp-search__list">
                {iterate from=results item=result}
                    <li>
                        {include file="frontend/objects/article_summary.tpl" article=$result.publishedSubmission journal=$result.journal showDatePublished=true hideGalleys=true heading="h3"}
                    </li>
                {/iterate}
            </ul>

            {if $results->wasEmpty()}
                <div role="status" class="jcrtp-search__none">
                    {if $error}
                        {include file="frontend/components/notification.tpl" type="error" message=$error|escape}
                    {else}
                        <div class="jcrtp-empty">
                            <span class="jcrtp-empty-icon" aria-hidden="true">{include file="frontend/components/jcrtp/icon.tpl" name="search" size=30}</span>
                            <p>{translate key="search.noResults"}</p>
                        </div>
                    {/if}
                </div>
            {else}
                <div class="cmp_pagination jcrtp-search__pagination">
                    {page_info iterator=$results}
                    {page_links anchor="results" iterator=$results name="search" query=$query searchJournal=$searchJournal authors=$authors dateFromMonth=$dateFromMonth dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateToMonth=$dateToMonth dateToDay=$dateToDay dateToYear=$dateToYear}
                </div>
            {/if}

            {block name=searchSyntaxInstructions}{/block}
        </section>
    </div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl" isFullWidth=true}
