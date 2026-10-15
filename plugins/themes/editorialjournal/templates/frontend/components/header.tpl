{**
 * plugins/themes/editorialjournal/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Common frontend site header. Copy of the OJS 3.5.0-5 core template;
 *  changes render the theme's JCRTP logo ($jcrtpLogoUrl) inside a journal
 *  context instead of the uploaded page header image, move the user menu into
 *  a top utility bar, add masthead facts (open access/ISSN from OJS settings)
 *  and replace the search link with an inline search form. Both menus render
 *  through frontend/components/jcrtp/navigationMenu.tpl.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}
{strip}
	{* Determine whether a logo or title string is being displayed *}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

	<div class="pkp_structure_page">

		{* Header *}
		<header class="pkp_structure_head" id="headerNavigationContainer" role="banner">
			{* Skip to content nav links *}
			{include file="frontend/components/skipLinks.tpl"}

			{* JCRTP utility bar: tagline and account links (wireframe band 1) *}
			<div class="jcrtp-topbar">
				<div class="jcrtp-topbar__inner">
					<p class="jcrtp-topbar__tagline">
						<svg aria-hidden="true" focusable="false" viewBox="0 0 24 24" width="18" height="18"><path fill="none" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round" d="M12 6.5C10 5 7 4.5 3 4.8v13.5c4-.3 7 .2 9 1.7 2-1.5 5-2 9-1.7V4.8c-4-.3-7 .2-9 1.7Zm0 0V20"/></svg>
						{translate key="plugins.themes.editorialjournal.header.tagline"}
					</p>
					<nav class="pkp_navigation_user_wrapper" id="navigationUserWrapper" aria-label="{translate|escape key="plugins.themes.editorialjournal.nav.account"}">
						{load_menu name="user" path="frontend/components/jcrtp/navigationMenu.tpl" id="jcrtpNavigationUser" ulClass="pkp_navigation_user" liClass="profile"}
						{if $currentContext && !$currentContext->getData('disableSubmissions')}
							<a class="jcrtp-topbar__submit" href="{url page="submission"}">{translate key="plugins.themes.editorialjournal.header.submitManuscript"}</a>
						{/if}
					</nav>
				</div>
			</div>

			<div class="pkp_head_wrapper">

				<div class="pkp_site_name_wrapper">
					<button type="button" class="pkp_site_nav_toggle">
						<span>{translate key="plugins.themes.editorialjournal.nav.openMenu"}</span>
					</button>
					{if !$requestedPage || $requestedPage === 'index'}
						<h1 class="pkp_screen_reader">
							{if $currentContext}
								{$displayPageHeaderTitle|escape}
							{else}
								{$siteTitle|escape}
							{/if}
						</h1>
					{/if}
					<div class="pkp_site_name">
					{capture assign="homeUrl"}
						{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}
					{/capture}
					{if $currentContext && $jcrtpLogoUrl}
						<a href="{$homeUrl}" class="is_img jcrtp-logo-link">
							<img class="jcrtp-logo" src="{$jcrtpLogoUrl|escape}" width="{$jcrtpLogoWidth|escape}" height="{$jcrtpLogoHeight|escape}" alt="{if $displayPageHeaderLogo && $displayPageHeaderLogo.altText != ''}{$displayPageHeaderLogo.altText|escape}{else}{$displayPageHeaderTitle|escape}{/if}" />
						</a>
					{elseif $displayPageHeaderLogo}
						<a href="{$homeUrl}" class="is_img">
							<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{/if} />
						</a>
					{elseif $displayPageHeaderTitle}
						<a href="{$homeUrl}" class="is_text">{$displayPageHeaderTitle|escape}</a>
					{else}
						<a href="{$homeUrl}" class="is_img">
							<img src="{$baseUrl}/templates/images/structure/logo.png" alt="{$applicationName|escape}" title="{$applicationName|escape}" width="180" height="90" />
						</a>
					{/if}
					</div>

					{* Masthead facts (wireframe band 2, right side): only values OJS holds *}
					{if $currentContext}
						{assign var=jcrtpIsOpenAccess value=false}
						{if $currentContext->getSetting('publishingMode') == APP\journal\Journal::PUBLISHING_MODE_OPEN}
							{assign var=jcrtpIsOpenAccess value=true}
						{/if}
						{assign var=jcrtpOnlineIssn value=$currentContext->getData('onlineIssn')}
						{assign var=jcrtpPrintIssn value=$currentContext->getData('printIssn')}
						{if $jcrtpIsOpenAccess || $jcrtpOnlineIssn || $jcrtpPrintIssn}
							<ul class="jcrtp-masthead-facts">
								{if $jcrtpIsOpenAccess}
									<li class="jcrtp-masthead-facts__oa">
										<svg aria-hidden="true" focusable="false" viewBox="0 0 24 36" width="26" height="39"><path fill="none" stroke="#f68212" stroke-width="3.6" stroke-linecap="round" d="M6.5 15V9.5a5.5 5.5 0 0 1 11 0V12"/><circle cx="12" cy="24" r="8.2" fill="none" stroke="#f68212" stroke-width="3.6"/><circle cx="12" cy="24" r="2.8" fill="#f68212"/></svg>
										<span>{translate key="plugins.themes.editorialjournal.header.openAccess"}</span>
									</li>
								{/if}
								{if $jcrtpOnlineIssn}
									<li><span class="jcrtp-masthead-facts__label">{translate key="plugins.themes.editorialjournal.onlineIssn"}</span> {$jcrtpOnlineIssn|escape}</li>
								{/if}
								{if $jcrtpPrintIssn}
									<li><span class="jcrtp-masthead-facts__label">{translate key="plugins.themes.editorialjournal.printIssn"}</span> {$jcrtpPrintIssn|escape}</li>
								{/if}
							</ul>
						{/if}
					{/if}
				</div>

				{capture assign="primaryMenu"}
					{load_menu name="primary" path="frontend/components/jcrtp/navigationMenu.tpl" id="jcrtpNavigationPrimary" ulClass="pkp_navigation_primary"}
				{/capture}

				<nav class="pkp_site_nav_menu" aria-label="{translate|escape key="common.navigation.site"}">
					<a id="siteNav"></a>
					<div class="pkp_navigation_primary_row">
						<div class="pkp_navigation_primary_wrapper">
							{* Primary navigation menu for current application *}
							{$primaryMenu}

							{* Search form *}
							{if $currentContext && $requestedPage !== 'search'}
								<div class="pkp_navigation_search_wrapper">
									<form class="jcrtp-header-search" role="search" action="{url page="search" op="search"}" method="get">
										<label class="pkp_screen_reader" for="jcrtpHeaderSearch">{translate key="common.search"}</label>
										<input id="jcrtpHeaderSearch" type="search" name="query" placeholder="{translate|escape key="plugins.themes.editorialjournal.header.searchPlaceholder"}" />
										<button type="submit">
											<span class="fa fa-search" aria-hidden="true"></span>
											<span class="pkp_screen_reader">{translate key="common.search"}</span>
										</button>
									</form>
								</div>
							{/if}
						</div>
					</div>
				</nav>
			</div><!-- .pkp_head_wrapper -->
		</header><!-- .pkp_structure_head -->

		{* Wrapper for page content and sidebars *}
		{if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
			<div class="pkp_structure_main" role="main">
				<a id="pkp_content_main"></a>
