{**
 * Decorative line icons for the inner pages (always aria-hidden).
 *
 * @uses $name string Icon name
 * @uses $size int Optional pixel size (default 24)
 *}
{assign var=jcrtpIconSize value=$size|default:24}
<svg class="jcrtp-icon jcrtp-icon--{$name|escape}" aria-hidden="true" focusable="false" viewBox="0 0 40 40" width="{$jcrtpIconSize|escape}" height="{$jcrtpIconSize|escape}" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
{if $name == 'book'}
    <path d="M20 11c-4-3-9-4-15-3v22c6-1 11 0 15 3 4-3 9-4 15-3V8c-6-1-11 0-15 3zm0 0v22"/>
{elseif $name == 'document'}
    <path d="M10 5h15l7 7v23H10zM25 5v7h7M15 18h12M15 23h12M15 28h8"/>
{elseif $name == 'globe'}
    <circle cx="20" cy="20" r="14"/><path d="M6 20h28M20 6c-5 6-5 22 0 28M20 6c5 6 5 22 0 28M9 13h22M9 27h22"/>
{elseif $name == 'openaccess'}
    <path d="M13 17v-5a7 7 0 0 1 14 0v1"/><circle cx="20" cy="26" r="9"/><circle cx="20" cy="26" r="3" fill="currentColor"/>
{elseif $name == 'people'}
    <circle cx="15" cy="14" r="5"/><circle cx="27" cy="14" r="4"/><path d="M5 32c0-6 4-10 10-10s10 4 10 10M24 22c6 0 11 3 11 9"/>
{elseif $name == 'mission'}
    <circle cx="19" cy="21" r="13"/><circle cx="19" cy="21" r="7.5"/><circle cx="19" cy="21" r="2.5" fill="currentColor"/><path d="M21 19 33 7m-5 0h5v5"/>
{elseif $name == 'vision'}
    <path d="M3 20s6-11 17-11 17 11 17 11-6 11-17 11S3 20 3 20z"/><circle cx="20" cy="20" r="5.5"/>
{elseif $name == 'values'}
    <path d="M11 7h18l7 9-16 18L4 16zM4 16h32M15 7l-3 9 8 18 8-18-3-9"/>
{elseif $name == 'scope'}
    <circle cx="17" cy="17" r="11"/><path d="m25 25 10 10M12 17h10M17 12v10"/>
{elseif $name == 'history'}
    <circle cx="20" cy="20" r="14"/><path d="M20 11v9l6 4"/>
{elseif $name == 'info'}
    <path d="M10 5h15l7 7v23H10zM25 5v7h7"/><path d="M16 19h10M16 24h10M16 29h6"/>
{elseif $name == 'database'}
    <ellipse cx="20" cy="9" rx="12" ry="4"/><path d="M8 9v22c0 2.2 5.4 4 12 4s12-1.8 12-4V9M8 16c0 2.2 5.4 4 12 4s12-1.8 12-4M8 23.5c0 2.2 5.4 4 12 4s12-1.8 12-4"/>
{elseif $name == 'mail'}
    <rect x="5" y="9" width="30" height="22" rx="2"/><path d="m6 11 14 11 14-11"/>
{elseif $name == 'download'}
    <path d="M20 6v19m-8-8 8 8 8-8M7 30v4h26v-4"/>
{elseif $name == 'share'}
    <circle cx="29" cy="9" r="4.5"/><circle cx="11" cy="20" r="4.5"/><circle cx="29" cy="31" r="4.5"/><path d="m15 18 10-6M15 22l10 6"/>
{elseif $name == 'link'}
    <path d="M17 23a7 7 0 0 0 10 0l6-6a7 7 0 0 0-10-10l-2 2M23 17a7 7 0 0 0-10 0l-6 6a7 7 0 0 0 10 10l2-2"/>
{elseif $name == 'search'}
    <circle cx="17" cy="17" r="10"/><path d="m25 25 9 9"/>
{elseif $name == 'pdf'}
    <path d="M10 5h15l7 7v23H10zM25 5v7h7"/><path d="M15 22h3a2 2 0 0 1 0 4h-3v-6M15 26v3M22 20v9h2a3 3 0 0 0 3-3v-3a3 3 0 0 0-3-3z"/>
{elseif $name == 'chevron'}
    <path d="m15 10 10 10-10 10"/>
{elseif $name == 'arrow'}
    <path d="M7 20h26m-9-9 9 9-9 9"/>
{/if}
</svg>
