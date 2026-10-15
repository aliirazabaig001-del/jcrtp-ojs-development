{**
 * "Contact the Editorial Office" card from the journal's OJS contact settings.
 * Shown only when at least one contact field is filled in.
 *}
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
