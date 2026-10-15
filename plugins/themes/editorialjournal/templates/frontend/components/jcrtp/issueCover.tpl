{**
 * Issue cover: the uploaded OJS cover image, or a theme cover drawn from the
 * official logo (unaltered) and the issue's own label.
 *
 * @uses $issue Issue
 *}
{assign var=jcrtpIssueCover value=$issue->getLocalizedCoverImageUrl()}
{if $jcrtpIssueCover}
    <img src="{$jcrtpIssueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape}" loading="lazy">
{else}
    <span class="jcrtp-cover">
        <span class="jcrtp-cover__brand"><img src="{$jcrtpLogoUrl|escape}" width="{$jcrtpLogoWidth|escape}" height="{$jcrtpLogoHeight|escape}" alt="" loading="lazy"></span>
        <span class="jcrtp-cover__art"></span>
        <span class="jcrtp-cover__foot">
            <span>{include file="frontend/components/jcrtp/issueLabel.tpl" issue=$issue short=true}</span>
            {if $currentJournal->getData('publishingMode') == APP\journal\Journal::PUBLISHING_MODE_OPEN}<span class="jcrtp-cover__oa">{translate key="plugins.themes.editorialjournal.header.openAccess"}</span>{/if}
        </span>
    </span>
{/if}
