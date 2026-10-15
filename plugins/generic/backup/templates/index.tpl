{**
 * templates/index.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2000-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * List of operations this plugin can perform
 *}

<div>{translate key="plugins.generic.backup.longdescription" class="notice"}</div>

{assign var=footNoteNum value=1}
<ul id="downloadLinks" data-message="{$errorMessage}">
	<li>
		{if $isDumpConfigured}
			<a download href="{url router=\PKP\core\PKPApplication::ROUTE_COMPONENT op="manage" category="generic" plugin=$pluginName verb="db"}">
		{/if}
			{translate key="plugins.generic.backup.db"}
		{if $isDumpConfigured}
			</a>
		{else}
			<sup>{$footNoteNum}{assign var=dumpFootNote value=$footNoteNum}{assign var=footNoteNum value=$footNoteNum+1}</sup>
		{/if}
	</li>
	<li>
		{if $isTarConfigured}
			<a download href="{url router=\PKP\core\PKPApplication::ROUTE_COMPONENT op="manage" category="generic" plugin=$pluginName verb="files"}">
		{/if}
			{translate key="plugins.generic.backup.files"}
		{if $isTarConfigured}
			</a>
		{else}
			<sup>{$footNoteNum}{assign var=tarFootNote value=$footNoteNum}{assign var=footNoteNum value=$footNoteNum+1}</sup>
		{/if}
	</li>
	<li>
		{if $isTarConfigured}
			<a download href="{url router=\PKP\core\PKPApplication::ROUTE_COMPONENT op="manage" category="generic" plugin=$pluginName verb="code"}">
		{/if}
			{translate key="plugins.generic.backup.code"}
		{if $isTarConfigured}
			</a>
		{else}
			<sup>{$tarFootNote}</sup>
		{/if}
	</li>
</ul>

{if $dumpFootNote}{translate key="plugins.generic.backup.db.config" footNoteNum=$dumpFootNote}{/if}
{if $tarFootNote}{translate key="plugins.generic.backup.tar.config" footNoteNum=$tarFootNote}{/if}
