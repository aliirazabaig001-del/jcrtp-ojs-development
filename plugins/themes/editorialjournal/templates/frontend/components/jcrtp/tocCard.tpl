{**
 * "On this page" card listing in-page anchors.
 *
 * @uses $toc array<int, array{id: string, title: string}>
 *}
{if $toc}
    <nav class="jcrtp-card jcrtp-section-nav jcrtp-toc" aria-labelledby="jcrtp-toc-heading">
        <h2 class="jcrtp-card__title" id="jcrtp-toc-heading">{include file="frontend/components/jcrtp/icon.tpl" name="document" size=24}{translate key="plugins.themes.editorialjournal.page.onThisPage"}</h2>
        <ul>
            {foreach from=$toc item=tocItem}
                <li><a href="#{$tocItem.id|escape}">{$tocItem.title|escape}{include file="frontend/components/jcrtp/icon.tpl" name="chevron" size=14}</a></li>
            {/foreach}
        </ul>
    </nav>
{/if}
