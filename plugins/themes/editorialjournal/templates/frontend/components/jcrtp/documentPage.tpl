{**
 * Shared document layout for policy-style pages (privacy statement, static
 * pages, OJS information pages): page banner, "On this page" and
 * "Journal Information" navigation, and the OJS-managed content with
 * anchored h2/h3 headings.
 *
 * @uses $docClass string Page class(es), e.g. "page_privacy"
 * @uses $docTitle string Escaped page title
 * @uses $docCrumbs string Optional breadcrumb <li> items
 * @uses $docHtml string OJS-managed HTML content
 * @uses $docCurrent string Key for infoLinks.tpl
 * @uses $docEditLink string Optional rendered edit link
 *}
{assign var=jcrtpDoc value=$docHtml|jcrtp_anchored:'policy'}
<div class="page {$docClass|escape} jcrtp-inner jcrtp-doc">
    {include file="frontend/components/jcrtp/pageBanner.tpl" bannerTitle=$docTitle bannerSummary="" bannerCrumbs=$docCrumbs bannerCurrent="" bannerEyebrow="" bannerSubtitle=""}

    <div class="jcrtp-inner__body jcrtp-doc__layout">
        <aside class="jcrtp-doc__nav">
            {include file="frontend/components/jcrtp/tocCard.tpl" toc=$jcrtpDoc.toc}
            {include file="frontend/components/jcrtp/infoLinks.tpl" current=$docCurrent}
        </aside>
        <div class="jcrtp-doc__main">
            {$docEditLink}
            {if $jcrtpDoc.html|strip_tags|trim}
                <div class="jcrtp-doc__section jcrtp-prose">{$jcrtpDoc.html}</div>
            {else}
                <div class="jcrtp-empty">
                    <span class="jcrtp-empty-icon" aria-hidden="true">{include file="frontend/components/jcrtp/icon.tpl" name="document" size=32}</span>
                    <p>{translate key="plugins.themes.editorialjournal.page.noContent"}</p>
                </div>
            {/if}
        </div>
    </div>
</div>
