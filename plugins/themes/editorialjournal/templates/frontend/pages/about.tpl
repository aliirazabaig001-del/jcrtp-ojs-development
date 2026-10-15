{**
 * plugins/themes/editorialjournal/templates/frontend/pages/about.tpl
 *
 * About the Journal, laid out after design-references/about-journal-desktop.png.
 * Replaces the OJS 3.5 core about.tpl (which prints the journal's "About"
 * setting). All text comes from OJS: the journal's About content (split at its
 * own h2/h3 headings by EditorialJournalThemePlugin::assignAboutData), the
 * journal description, ISSN, publishing mode, languages, publisher, fees and
 * contact settings. The Indexing card lists only the services entered in the
 * theme settings.
 *}
{include file="frontend/components/header.tpl" pageTitle="about.aboutContext" isFullWidth=true}

{assign var=jcrtpIsOpenAccess value=false}
{if $currentContext->getData('publishingMode') == APP\journal\Journal::PUBLISHING_MODE_OPEN}
    {assign var=jcrtpIsOpenAccess value=true}
{/if}

<div class="page page_about jcrtp-inner jcrtp-about">
    {capture assign=jcrtpBannerTitle}{translate key="about.aboutContext"}{/capture}
    {capture assign=jcrtpBannerCrumbs}<li><a href="{url page="about"}">{translate key="plugins.themes.editorialjournal.nav.about"}</a></li>{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$jcrtpBannerTitle bannerSummary=$jcrtpAboutSummary bannerCrumbs=$jcrtpBannerCrumbs}

    <div class="jcrtp-inner__body jcrtp-about__layout">

        {* Left: section navigation and open-access card *}
        <aside class="jcrtp-about__nav">
            <nav class="jcrtp-card jcrtp-section-nav" aria-labelledby="jcrtp-about-nav-heading">
                <h2 class="jcrtp-card__title" id="jcrtp-about-nav-heading">
                    {include file="frontend/components/jcrtp/icon.tpl" name="book" size=26}
                    {translate key="plugins.themes.editorialjournal.nav.about"}
                </h2>
                <ul>
                    <li><a class="is-current" href="{url page="about"}" aria-current="page">{translate key="about.aboutContext"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                    {foreach from=$jcrtpAboutSections item=aboutSection}
                        {if $aboutSection.level != 2}{continue}{/if}
                        <li><a href="#{$aboutSection.id|escape}">{$aboutSection.title|escape}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                    {/foreach}
                    <li><a href="{url page="about" op="editorialMasthead"}">{translate key="plugins.themes.editorialjournal.nav.editorialBoard"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                    <li><a href="{url page="editorial-process"}">{translate key="plugins.themes.editorialjournal.nav.editorialProcess"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                    {if $jcrtpIndexingServices}
                        <li><a href="#about-indexing">{translate key="plugins.themes.editorialjournal.about.indexing"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                    {/if}
                    <li><a href="{url page="about" op="contact"}">{translate key="plugins.themes.editorialjournal.home.contactUs"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                </ul>
            </nav>

            {if $jcrtpIsOpenAccess}
                <div class="jcrtp-oa-card">
                    <span class="jcrtp-oa-card__art" aria-hidden="true"></span>
                    <p class="jcrtp-oa-card__text">
                        {include file="frontend/components/jcrtp/icon.tpl" name="openaccess" size=34}
                        <span>
                            <strong>{translate key="plugins.themes.editorialjournal.header.openAccess"}</strong>
                            {translate key="plugins.themes.editorialjournal.about.oaCard"}
                        </span>
                    </p>
                </div>
            {/if}
        </aside>

        {* Centre: the journal's own About content *}
        <div class="jcrtp-about__main">
            {include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.aboutContext"}

            {if $jcrtpAboutIntro}
                <section class="jcrtp-about__overview" aria-labelledby="jcrtp-about-overview">
                    <h2 class="jcrtp-inner__heading" id="jcrtp-about-overview">{translate key="plugins.themes.editorialjournal.about.overview"}</h2>
                    <div class="jcrtp-prose">{$jcrtpAboutIntro}</div>
                </section>
            {/if}

            <ul class="jcrtp-value-tiles" aria-label="{translate|escape key="plugins.themes.editorialjournal.features.label"}">
                <li>{include file="frontend/components/jcrtp/icon.tpl" name="document" size=38}<span>{translate key="plugins.themes.editorialjournal.about.tile.peerReview"}</span></li>
                <li>{include file="frontend/components/jcrtp/icon.tpl" name="globe" size=38}<span>{translate key="plugins.themes.editorialjournal.features.global.title"}</span></li>
                {if $jcrtpIsOpenAccess}
                    <li>{include file="frontend/components/jcrtp/icon.tpl" name="openaccess" size=38}<span>{translate key="plugins.themes.editorialjournal.about.tile.openAccess"}</span></li>
                {/if}
                <li>{include file="frontend/components/jcrtp/icon.tpl" name="people" size=38}<span>{translate key="plugins.themes.editorialjournal.about.tile.multidisciplinary"}</span></li>
            </ul>

            {foreach from=$jcrtpAboutSections item=aboutSection}
                <section class="jcrtp-about-block" id="{$aboutSection.id|escape}" aria-labelledby="{$aboutSection.id|escape}-title">
                    <span class="jcrtp-about-block__icon">{include file="frontend/components/jcrtp/icon.tpl" name=$aboutSection.icon size=44}</span>
                    <div class="jcrtp-about-block__body">
                        <h{$aboutSection.level} class="jcrtp-about-block__title" id="{$aboutSection.id|escape}-title">{$aboutSection.title|escape}</h{$aboutSection.level}>
                        <div class="jcrtp-prose">{$aboutSection.html}</div>
                    </div>
                </section>
            {/foreach}

            {if !$jcrtpAboutIntro && !$jcrtpAboutSections}
                <div class="jcrtp-empty">
                    <span class="jcrtp-empty-icon" aria-hidden="true">{include file="frontend/components/jcrtp/icon.tpl" name="book" size=32}</span>
                    <p>{translate key="plugins.themes.editorialjournal.about.noContent"}</p>
                </div>
            {/if}
        </div>

        {* Right: facts held by OJS *}
        <aside class="jcrtp-about__aside">
            {if $jcrtpKeyInfo}
                <section class="jcrtp-card" aria-labelledby="jcrtp-about-key">
                    <h2 class="jcrtp-card__title" id="jcrtp-about-key">{include file="frontend/components/jcrtp/icon.tpl" name="info" size=26}{translate key="plugins.themes.editorialjournal.about.keyInfo"}</h2>
                    <dl class="jcrtp-facts-list">
                        {foreach from=$jcrtpKeyInfo item=fact}
                            <div><dt>{$fact.label|escape}</dt><dd>{$fact.value|escape}</dd></div>
                        {/foreach}
                    </dl>
                </section>
            {/if}

            {if $jcrtpIndexingServices}
                <section class="jcrtp-card" id="about-indexing" aria-labelledby="jcrtp-about-indexing">
                    <h2 class="jcrtp-card__title" id="jcrtp-about-indexing">{include file="frontend/components/jcrtp/icon.tpl" name="database" size=26}{translate key="plugins.themes.editorialjournal.about.indexing"}</h2>
                    <ul class="jcrtp-indexing">
                        {foreach from=$jcrtpIndexingServices item=service}
                            <li>{if $service.url}<a href="{$service.url|escape}" rel="noopener" target="_blank">{$service.name|escape}</a>{else}{$service.name|escape}{/if}</li>
                        {/foreach}
                    </ul>
                </section>
            {/if}

            {assign var=jcrtpContactName value=$currentContext->getData('contactName')}
            {assign var=jcrtpContactAffiliation value=$currentContext->getLocalizedData('contactAffiliation')}
            {assign var=jcrtpMailingAddress value=$currentContext->getData('mailingAddress')}
            {assign var=jcrtpContactEmail value=$currentContext->getData('contactEmail')}
            {assign var=jcrtpContactPhone value=$currentContext->getData('contactPhone')}
            {if $jcrtpContactName || $jcrtpContactAffiliation || $jcrtpMailingAddress || $jcrtpContactEmail || $jcrtpContactPhone}
                <section class="jcrtp-card" aria-labelledby="jcrtp-about-contact">
                    <h2 class="jcrtp-card__title" id="jcrtp-about-contact">{include file="frontend/components/jcrtp/icon.tpl" name="mail" size=26}{translate key="plugins.themes.editorialjournal.about.contactOffice"}</h2>
                    <div class="jcrtp-card__body jcrtp-contact-card">
                        {if $jcrtpContactName}<p class="jcrtp-contact-card__name">{$jcrtpContactName|escape}</p>{/if}
                        {if $jcrtpContactAffiliation}<p>{$jcrtpContactAffiliation|escape}</p>{/if}
                        {if $jcrtpMailingAddress}<p>{$jcrtpMailingAddress|escape|nl2br}</p>{/if}
                        {if $jcrtpContactEmail}<p>{translate key="user.email"}: <a href="mailto:{$jcrtpContactEmail|escape}">{$jcrtpContactEmail|escape}</a></p>{/if}
                        {if $jcrtpContactPhone}<p>{translate key="user.phone"}: <a href="tel:{$jcrtpContactPhone|regex_replace:'/[^0-9+]/':''|escape}">{$jcrtpContactPhone|escape}</a></p>{/if}
                    </div>
                </section>
            {/if}
        </aside>
    </div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl" isFullWidth=true}
