<section class="jcrtp-hero" aria-labelledby="jcrtp-journal-name">
    <div class="jcrtp-hero__content">
        <p class="jcrtp-eyebrow">{translate key="plugins.themes.editorialjournal.hero.eyebrow"}</p>
        <h2 id="jcrtp-journal-name">{$currentJournal->getLocalizedName()|escape}</h2>
        <div class="jcrtp-lead">
            {if $activeTheme && $activeTheme->getOption('showDescriptionInJournalIndex') && $currentJournal->getLocalizedData('description')}
                {$currentJournal->getLocalizedData('description')|strip_unsafe_html}
            {else}
                <p>{translate key="plugins.themes.editorialjournal.hero.copy"}</p>
            {/if}
        </div>
        <div class="jcrtp-actions">
            <a class="jcrtp-button" href="{url page="about" op="submissions"}">{translate key="about.submissions"} <span aria-hidden="true">→</span></a>
            {if $issue}
                <a class="jcrtp-button jcrtp-button--secondary" href="#jcrtp-current-issue">{translate key="journal.currentIssue"}</a>
            {else}
                <a class="jcrtp-button jcrtp-button--secondary" href="{url page="about"}">{translate key="about.aboutContext"}</a>
            {/if}
        </div>
        {assign var=printIssn value=$currentJournal->getData('printIssn')}
        {assign var=onlineIssn value=$currentJournal->getData('onlineIssn')}
        {if $printIssn || $onlineIssn}
            <dl class="jcrtp-identifiers">
                {if $printIssn}<div><dt>{translate key="plugins.themes.editorialjournal.printIssn"}</dt><dd>{$printIssn|escape}</dd></div>{/if}
                {if $onlineIssn}<div><dt>{translate key="plugins.themes.editorialjournal.onlineIssn"}</dt><dd>{$onlineIssn|escape}</dd></div>{/if}
            </dl>
        {/if}
        {* Mirror OJS's search form URL handling, including query-string routing. *}
        {capture name="jcrtpSearchUrl"}{url page="search" escape=false}{/capture}
        {assign var=jcrtpSearchParameters value=[]}
        {$smarty.capture.jcrtpSearchUrl|parse_url:$smarty.const.PHP_URL_QUERY|default:""|parse_str:$jcrtpSearchParameters}
        <form class="jcrtp-site-search" method="get" action="{$smarty.capture.jcrtpSearchUrl|strtok:"?"|escape}" role="search">
            {foreach from=$jcrtpSearchParameters key=paramKey item=paramValue}
                <input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}">
            {/foreach}
            <label for="jcrtp-journal-search">{translate key="plugins.themes.editorialjournal.search.label"}</label>
            <div class="jcrtp-site-search__controls">
                <input type="search" id="jcrtp-journal-search" name="query" placeholder="{translate|escape key="plugins.themes.editorialjournal.search.placeholder"}">
                <button type="submit">{translate key="common.search"}</button>
            </div>
        </form>
    </div>
    <div class="jcrtp-hero__media">
        {if $activeTheme && !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
            <img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}" alt="{$homepageImage.altText|escape|default:''}" fetchpriority="high">
        {else}
            <div class="jcrtp-hero__visual" aria-hidden="true"><span></span><span></span><span></span></div>
        {/if}
    </div>
</section>