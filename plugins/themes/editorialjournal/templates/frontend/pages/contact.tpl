{**
 * plugins/themes/editorialjournal/templates/frontend/pages/contact.tpl
 *
 * Contact page in the inner-page design. Replaces the OJS 3.5 core
 * contact.tpl with the same data (mailing address, principal and technical
 * support contacts from the journal's OJS settings) and the same spam-safe
 * {mailto encode='javascript'} e-mail output. Nothing is shown that OJS does
 * not hold.
 *}
{include file="frontend/components/header.tpl" pageTitle="about.contact" isFullWidth=true}

<div class="page page_contact jcrtp-inner jcrtp-doc">
    {capture assign=jcrtpBannerTitle}{translate key="about.contact"}{/capture}
    {capture assign=jcrtpBannerSummary}{translate key="plugins.themes.editorialjournal.contact.summary"}{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$jcrtpBannerTitle bannerSummary=$jcrtpBannerSummary bannerCrumbs="" bannerCurrent="" bannerEyebrow="" bannerSubtitle=""}

    <div class="jcrtp-inner__body jcrtp-doc__layout">
        <aside class="jcrtp-doc__nav">
            {include file="frontend/components/jcrtp/infoLinks.tpl" current="contact"}
        </aside>

        <div class="jcrtp-doc__main">
            {include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="contact" sectionTitleKey="about.contact"}

            {if $mailingAddress || $contactTitle || $contactName || $contactAffiliation || $contactPhone || $contactEmail || $supportName || $supportPhone || $supportEmail}
                <div class="contact_section jcrtp-contact-grid">
                    {if $contactTitle || $contactName || $contactAffiliation || $contactPhone || $contactEmail}
                        <section class="jcrtp-card contact primary" aria-labelledby="jcrtp-contact-primary">
                            <h2 class="jcrtp-card__title" id="jcrtp-contact-primary">{include file="frontend/components/jcrtp/icon.tpl" name="mail" size=24}{translate key="about.contact.principalContact"}</h2>
                            <div class="jcrtp-card__body jcrtp-contact-card">
                                {if $contactName}<p class="name jcrtp-contact-card__name">{$contactName|escape}</p>{/if}
                                {if $contactTitle}<p class="title">{$contactTitle|escape}</p>{/if}
                                {if $contactAffiliation}<div class="affiliation">{$contactAffiliation|strip_unsafe_html}</div>{/if}
                                {if $contactPhone}
                                    <p class="phone"><span class="label">{translate key="about.contact.phone"}</span> <span class="value">{$contactPhone|escape}</span></p>
                                {/if}
                                {if $contactEmail}<p class="email">{mailto address=$contactEmail encode='javascript'}</p>{/if}
                            </div>
                        </section>
                    {/if}

                    {if $supportName || $supportPhone || $supportEmail}
                        <section class="jcrtp-card contact support" aria-labelledby="jcrtp-contact-support">
                            <h2 class="jcrtp-card__title" id="jcrtp-contact-support">{include file="frontend/components/jcrtp/icon.tpl" name="people" size=24}{translate key="about.contact.supportContact"}</h2>
                            <div class="jcrtp-card__body jcrtp-contact-card">
                                {if $supportName}<p class="name jcrtp-contact-card__name">{$supportName|escape}</p>{/if}
                                {if $supportPhone}
                                    <p class="phone"><span class="label">{translate key="about.contact.phone"}</span> <span class="value">{$supportPhone|escape}</span></p>
                                {/if}
                                {if $supportEmail}<p class="email">{mailto address=$supportEmail encode='javascript'}</p>{/if}
                            </div>
                        </section>
                    {/if}

                    {if $mailingAddress}
                        <section class="jcrtp-card address" aria-labelledby="jcrtp-contact-address">
                            <h2 class="jcrtp-card__title" id="jcrtp-contact-address">{include file="frontend/components/jcrtp/icon.tpl" name="document" size=24}{translate key="plugins.themes.editorialjournal.contact.address"}</h2>
                            <div class="jcrtp-card__body jcrtp-contact-card">
                                <p>{$mailingAddress|nl2br|strip_unsafe_html}</p>
                            </div>
                        </section>
                    {/if}
                </div>
            {else}
                <div class="jcrtp-empty">
                    <span class="jcrtp-empty-icon" aria-hidden="true">{include file="frontend/components/jcrtp/icon.tpl" name="mail" size=32}</span>
                    <p>{translate key="plugins.themes.editorialjournal.page.noContent"}</p>
                </div>
            {/if}
        </div>
    </div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl" isFullWidth=true}
