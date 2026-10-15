{**
 * plugins/themes/editorialjournal/templates/frontend/pages/submissions.tpl
 *
 * Submissions / For Authors in the inner-page design. Replaces the OJS 3.5
 * core submissions.tpl and keeps all of its content and rules: the
 * submission status message (not accepting / logged in / login-register),
 * author guidelines, preparation checklist, $submissionChecklistAfterContent
 * (plugin content), copyright notice and privacy statement, each with its OJS
 * edit link. It also renders the journal sections' policies, which OJS's own
 * app-level submissions.tpl adds before including the pkp core template.
 * Every text comes from the journal's OJS settings.
 *}
{include file="frontend/components/header.tpl" pageTitle="about.submissions" isFullWidth=true}

{assign var=jcrtpAccepting value=!($sections|@count == 0 || $currentContext->getData('disableSubmissions'))}
{assign var=jcrtpGuidelines value=$currentContext->getLocalizedData('authorGuidelines')|jcrtp_anchored:'guidelines'}
{assign var=jcrtpHasSectionPolicies value=false}
{foreach from=$sections item="section"}
    {if $section->getLocalizedPolicy()}{assign var=jcrtpHasSectionPolicies value=true}{/if}
{/foreach}

<div class="page page_submissions jcrtp-inner jcrtp-doc">
    {capture assign=jcrtpBannerTitle}{translate key="about.submissions"}{/capture}
    {capture assign=jcrtpBannerCrumbs}<li><a href="{url page="about"}">{translate key="plugins.themes.editorialjournal.nav.forAuthors"}</a></li>{/capture}
    {capture assign=jcrtpBannerSummary}{translate key="plugins.themes.editorialjournal.submissions.summary"}{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$jcrtpBannerTitle bannerSummary=$jcrtpBannerSummary bannerCrumbs=$jcrtpBannerCrumbs bannerCurrent="" bannerEyebrow="" bannerSubtitle=""}

    <div class="jcrtp-inner__body jcrtp-doc__layout jcrtp-doc__layout--aside">
        <aside class="jcrtp-doc__nav">
            <nav class="jcrtp-card jcrtp-section-nav" aria-labelledby="jcrtp-submissions-toc">
                <h2 class="jcrtp-card__title" id="jcrtp-submissions-toc">{include file="frontend/components/jcrtp/icon.tpl" name="document" size=24}{translate key="plugins.themes.editorialjournal.page.onThisPage"}</h2>
                <ul>
                    {if $currentContext->getLocalizedData('authorGuidelines')}
                        <li><a href="#authorGuidelines">{translate key="about.authorGuidelines"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                        {foreach from=$jcrtpGuidelines.toc item=tocItem}
                            <li class="jcrtp-section-nav__sub"><a href="#{$tocItem.id|escape}">{$tocItem.title|escape}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
                        {/foreach}
                    {/if}
                    {if $submissionChecklist}<li><a href="#submissionChecklist">{translate key="about.submissionPreparationChecklist"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>{/if}
                    {if $jcrtpHasSectionPolicies}<li><a href="#sectionPolicies">{translate key="plugins.themes.editorialjournal.submissions.sectionPolicies"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>{/if}
                    {if $currentContext->getLocalizedData('copyrightNotice')}<li><a href="#copyrightNotice">{translate key="about.copyrightNotice"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>{/if}
                    {if $currentContext->getLocalizedData('privacyStatement')}<li><a href="#privacyStatement">{translate key="about.privacyStatement"}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>{/if}
                </ul>
            </nav>
            {include file="frontend/components/jcrtp/infoLinks.tpl" current="submissions"}
        </aside>

        <div class="jcrtp-doc__main">
            {* Submission status, as in core *}
            <div class="cmp_notification jcrtp-callout{if !$jcrtpAccepting} jcrtp-callout--muted{/if}">
                {include file="frontend/components/jcrtp/icon.tpl" name="info" size=26}
                <p>
                    {if !$jcrtpAccepting}
                        {translate key="author.submit.notAccepting"}
                    {elseif $isUserLoggedIn}
                        {capture assign="newSubmission"}<a href="{url page="submission"}">{translate key="about.onlineSubmissions.newSubmission"}</a>{/capture}
                        {capture assign="viewSubmissions"}<a href="{url page="submissions"}">{translate key="about.onlineSubmissions.viewSubmissions"}</a>{/capture}
                        {translate key="about.onlineSubmissions.submissionActions" newSubmission=$newSubmission viewSubmissions=$viewSubmissions}
                    {else}
                        {capture assign="login"}<a href="{url page="login"}">{translate key="about.onlineSubmissions.login"}</a>{/capture}
                        {capture assign="register"}<a href="{url page="user" op="register"}">{translate key="about.onlineSubmissions.register"}</a>{/capture}
                        {translate key="about.onlineSubmissions.registrationRequired" login=$login register=$register}
                    {/if}
                </p>
            </div>

            {if $currentContext->getLocalizedData('authorGuidelines')}
                <section class="jcrtp-doc__section author_guidelines" id="authorGuidelines">
                    <h2 class="jcrtp-doc__heading">
                        {translate key="about.authorGuidelines"}
                        {include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/instructions" sectionTitleKey="about.authorGuidelines"}
                    </h2>
                    <div class="jcrtp-prose">{$jcrtpGuidelines.html}</div>
                </section>
            {/if}

            {if $submissionChecklist}
                <section class="jcrtp-doc__section submission_checklist" id="submissionChecklist">
                    <h2 class="jcrtp-doc__heading">
                        {translate key="about.submissionPreparationChecklist"}
                        {include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/instructions" sectionTitleKey="about.submissionPreparationChecklist"}
                    </h2>
                    <div class="jcrtp-prose jcrtp-checklist">{$submissionChecklist}</div>
                </section>
            {/if}

            {if $jcrtpHasSectionPolicies}
                <section class="jcrtp-doc__section" id="sectionPolicies" aria-labelledby="jcrtp-section-policies">
                    <h2 class="jcrtp-doc__heading" id="jcrtp-section-policies">{translate key="plugins.themes.editorialjournal.submissions.sectionPolicies"}</h2>
                    <div class="jcrtp-policy-grid">
                        {foreach from=$sections item="section"}
                            {if $section->getLocalizedPolicy()}
                                <div class="section_policy jcrtp-card">
                                    <h3 class="jcrtp-card__title">{include file="frontend/components/jcrtp/icon.tpl" name="document" size=22}{$section->getLocalizedTitle()|escape}</h3>
                                    <div class="jcrtp-card__body jcrtp-prose">
                                        {$section->getLocalizedPolicy()}
                                        {if $isUserLoggedIn && $jcrtpAccepting}
                                            {capture assign="sectionSubmissionUrl"}{url page="submission" sectionId=$section->getId()}{/capture}
                                            <p>{translate key="about.onlineSubmissions.submitToSection" name=$section->getLocalizedTitle()|escape url=$sectionSubmissionUrl}</p>
                                        {/if}
                                    </div>
                                </div>
                            {/if}
                        {/foreach}
                    </div>
                </section>
            {/if}

            {if isset($submissionChecklistAfterContent)}
                <div class="jcrtp-doc__section jcrtp-prose">{$submissionChecklistAfterContent}</div>
            {/if}

            {if $currentContext->getLocalizedData('copyrightNotice')}
                <section class="jcrtp-doc__section copyright_notice" id="copyrightNotice">
                    <h2 class="jcrtp-doc__heading">
                        {translate key="about.copyrightNotice"}
                        {include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/instructions" sectionTitleKey="about.copyrightNotice"}
                    </h2>
                    <div class="jcrtp-prose">{$currentContext->getLocalizedData('copyrightNotice')}</div>
                </section>
            {/if}

            {if $currentContext->getLocalizedData('privacyStatement')}
                <section class="jcrtp-doc__section privacy_statement" id="privacyStatement">
                    <h2 class="jcrtp-doc__heading">
                        {translate key="about.privacyStatement"}
                        {include file="frontend/components/editLink.tpl" page="management" op="settings" path="website" anchor="setup/privacy" sectionTitleKey="about.privacyStatement"}
                    </h2>
                    <div class="jcrtp-prose">{$currentContext->getLocalizedData('privacyStatement')}</div>
                </section>
            {/if}
        </div>

        <aside class="jcrtp-doc__aside">
            <section class="jcrtp-card jcrtp-cta-card" aria-labelledby="jcrtp-submit-cta">
                <h2 class="jcrtp-card__title" id="jcrtp-submit-cta">{include file="frontend/components/jcrtp/icon.tpl" name="arrow" size=24}{translate key="plugins.themes.editorialjournal.header.submitManuscript"}</h2>
                <div class="jcrtp-card__body">
                    {if !$jcrtpAccepting}
                        <p>{translate key="author.submit.notAccepting"}</p>
                    {elseif $isUserLoggedIn}
                        <a class="jcrtp-btn jcrtp-btn--primary jcrtp-btn--small" href="{url page="submission"}">{translate key="plugins.themes.editorialjournal.submissions.newSubmission"}</a>
                        <a class="jcrtp-btn jcrtp-btn--outline jcrtp-btn--small" href="{url page="submissions"}">{translate key="plugins.themes.editorialjournal.submissions.mySubmissions"}</a>
                    {else}
                        <p>{translate key="plugins.themes.editorialjournal.submissions.accountNeeded"}</p>
                        <a class="jcrtp-btn jcrtp-btn--primary jcrtp-btn--small" href="{url page="login"}">{translate key="about.onlineSubmissions.login"}</a>
                        <a class="jcrtp-btn jcrtp-btn--outline jcrtp-btn--small" href="{url page="user" op="register"}">{translate key="about.onlineSubmissions.register"}</a>
                    {/if}
                </div>
            </section>
            <section class="jcrtp-card" aria-labelledby="jcrtp-submit-process">
                <h2 class="jcrtp-card__title" id="jcrtp-submit-process">{include file="frontend/components/jcrtp/icon.tpl" name="people" size=24}{translate key="plugins.themes.editorialjournal.nav.editorialProcess"}</h2>
                <div class="jcrtp-card__body">
                    <p>{translate key="plugins.themes.editorialjournal.submissions.processCopy"}</p>
                    <a class="jcrtp-more-link" href="{url page="editorial-process"}">{translate key="plugins.themes.editorialjournal.submissions.processLink"} <span aria-hidden="true">→</span></a>
                </div>
            </section>
            {include file="frontend/components/jcrtp/contactCard.tpl"}
        </aside>
    </div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl" isFullWidth=true}
