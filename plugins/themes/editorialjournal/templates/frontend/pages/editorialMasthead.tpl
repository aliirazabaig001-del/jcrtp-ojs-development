{**
 * Theme presentation for the journal's Editorial Board and native OJS masthead,
 * in the shared inner-page layout (banner + Journal Information navigation).
 *}
{include file="frontend/components/header.tpl" pageTitle="plugins.themes.editorialjournal.board.heading" isFullWidth=true}

<div class="page page_masthead jcrtp-editorial-board jcrtp-inner jcrtp-doc">
    {capture assign=jcrtpBannerTitle}{translate key="plugins.themes.editorialjournal.board.heading"}{/capture}
    {capture assign=jcrtpBannerCrumbs}<li><a href="{url page="about"}">{translate key="plugins.themes.editorialjournal.nav.about"}</a></li>{/capture}
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$jcrtpBannerTitle bannerSummary="" bannerCrumbs=$jcrtpBannerCrumbs bannerCurrent="" bannerEyebrow="" bannerSubtitle=""}

    <div class="jcrtp-inner__body jcrtp-doc__layout">
    <aside class="jcrtp-doc__nav">
        {include file="frontend/components/jcrtp/infoLinks.tpl" current="board"}
    </aside>
    <div class="jcrtp-doc__main">
    <section class="jcrtp-board" aria-labelledby="jcrtp-board-heading">
        <h2 id="jcrtp-board-heading">{translate key="plugins.themes.editorialjournal.board.membersHeading"}</h2>
        <div class="jcrtp-board__grid">
            {foreach from=$editorialBoardMembers item=member}
                <article class="jcrtp-board-card{if !$member.image} jcrtp-board-card--no-portrait{/if}">
                    {if $member.image}
                        <div class="jcrtp-board-card__portrait">
                            <img src="{$editorialBoardImageBase|escape}/{$member.image|escape:'url'}" alt="{translate key="plugins.themes.editorialjournal.board.portraitAlt" name=$member.name|escape}" loading="lazy" decoding="async">
                        </div>
                    {/if}
                    <div class="jcrtp-board-card__content">
                        <h3>{$member.name|escape}</h3>
                        {if $member.credentials}
                            <p class="jcrtp-board-card__credentials">{$member.credentials|escape}</p>
                        {/if}
                        <p class="jcrtp-board-card__role">{translate key="plugins.themes.editorialjournal.board.memberRole"}</p>

                        <h4>{translate key="plugins.themes.editorialjournal.board.appointments"}</h4>
                        <ul class="jcrtp-board-card__appointments">
                            {foreach from=$member.appointments item=appointment}
                                <li>{$appointment|escape}</li>
                            {/foreach}
                        </ul>

                        {if $member.biography}
                            <h4>{translate key="plugins.themes.editorialjournal.board.biography"}</h4>
                            <p>{$member.biography|escape}</p>
                        {/if}

                        <h4>{translate key="plugins.themes.editorialjournal.board.expertise"}</h4>
                        <ul class="jcrtp-board-card__expertise">
                            {foreach from=$member.expertise item=area}
                                <li>{$area|escape}</li>
                            {/foreach}
                        </ul>
                    </div>
                </article>
            {/foreach}
        </div>
    </section>

    {foreach from=$mastheadRoles item="mastheadRole"}
        {if array_key_exists($mastheadRole->id, $mastheadUsers)}
            <section class="jcrtp-ojs-masthead">
                <h2>{$mastheadRole->getLocalizedData('name')|escape}</h2>
                <ul class="user_listing" role="list">
                    {foreach from=$mastheadUsers[$mastheadRole->id] item="mastheadUser"}
                        <li>
                            {if !empty($mastheadUser['dateStart'])}
                                <span class="date_start">{translate key="common.fromUntil" from=$mastheadUser['dateStart'] until=""}</span>
                            {/if}
                            <span class="name">
                                {$mastheadUser['user']->getFullName()|escape}
                                {if $mastheadUser['user']->getData('orcid') && $mastheadUser['user']->hasVerifiedOrcid()}
                                    <span class="orcid">
                                        <a href="{$mastheadUser['user']->getData('orcid')|escape}" target="_blank" rel="noopener noreferrer" aria-label="{translate key="common.editorialHistory.page.orcidLink" name=$mastheadUser['user']->getFullName()|escape}">
                                            {$orcidIcon}
                                        </a>
                                    </span>
                                {/if}
                            </span>
                            {if !empty($mastheadUser['user']->getLocalizedData('affiliation'))}
                                <span class="affiliation">{$mastheadUser['user']->getLocalizedData('affiliation')|escape}</span>
                            {/if}
                        </li>
                    {/foreach}
                </ul>
            </section>
        {/if}
    {/foreach}

    {if $reviewers->count()}
        <section class="jcrtp-ojs-reviewers">
            <h2>{translate key="common.editorialMasthead.peerReviewers"}</h2>
            <p>{translate key="common.editorialMasthead.peerReviewers.description" year=$previousYear}</p>
            <ul class="user_listing" role="list">
                {foreach from=$reviewers item="reviewer"}
                    <li>
                        <span class="name">
                            {$reviewer->getFullName()|escape}
                            {if $reviewer->getData('orcid') && $reviewer->getData('orcidAccessToken')}
                                <span class="orcid">
                                    <a href="{$reviewer->getData('orcid')|escape}" target="_blank" rel="noopener noreferrer" aria-label="{translate key="common.editorialHistory.page.orcidLink" name=$reviewer->getFullName()|escape}">
                                        {$orcidIcon}
                                    </a>
                                </span>
                            {/if}
                        </span>
                        {if !empty($reviewer->getLocalizedData('affiliation'))}
                            <span class="affiliation">{$reviewer->getLocalizedData('affiliation')|escape}</span>
                        {/if}
                    </li>
                {/foreach}
            </ul>
        </section>
    {/if}

    <p class="jcrtp-board__history">
        {capture assign=editorialHistoryUrl}{url page="about" op="editorialHistory" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}
        {translate key="about.editorialMasthead.linkToEditorialHistory" url=$editorialHistoryUrl}
    </p>
    </div>
    </div>
</div>

{include file="frontend/components/footer.tpl" isFullWidth=true}
