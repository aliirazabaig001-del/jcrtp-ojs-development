{**
 * plugins/themes/editorialjournal/templates/frontend/components/footer.tpl
 *
 * Copy of the OJS 3.5.0-5 core footer, laid out after the footer band of
 * design-references/Homepage.png: logo and journal summary, quick links to
 * OJS routes, contact/ISSN/copyright and the open-access mark. The journal's
 * own footer content (Settings > Website > Appearance) and the OJS/PKP credit
 * follow underneath. Profile links appear only when set in the theme options.
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Common site frontend footer.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *
 * @hook Templates::Common::Sidebar []
 * @hook Templates::Common::Footer::PageFooter []
 *}

	</div><!-- pkp_structure_main -->

	{* Sidebars *}
	{if empty($isFullWidth)}
		{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
		{if $sidebarCode}
			<div class="pkp_structure_sidebar left" role="complementary">
				{$sidebarCode}
			</div><!-- pkp_sidebar.left -->
		{/if}
	{/if}
</div><!-- pkp_structure_content -->

<div class="pkp_structure_footer_wrapper" role="contentinfo">
	<a id="pkp_content_footer"></a>

	<div class="pkp_structure_footer">

		{if $currentContext}
			{assign var=jcrtpJournalName value=$currentContext->getLocalizedName()}
			<div class="jcrtp-footer">
				<div class="jcrtp-footer__about">
					{if $jcrtpLogoUrl}
						<a class="jcrtp-footer-brand" href="{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}">
							<img class="jcrtp-logo" src="{$jcrtpLogoUrl|escape}" width="{$jcrtpLogoWidth|escape}" height="{$jcrtpLogoHeight|escape}" alt="{$jcrtpJournalName|escape}" loading="lazy" />
						</a>
					{/if}
					{if $jcrtpFooterSummary}
						<p class="jcrtp-footer__summary">{$jcrtpFooterSummary|escape}</p>
					{/if}
				</div>

				<nav class="jcrtp-footer__links" aria-labelledby="jcrtp-footer-links-heading">
					<h2 class="jcrtp-footer__heading" id="jcrtp-footer-links-heading">{translate key="plugins.themes.editorialjournal.footer.quickLinks"}</h2>
					<ul>
						<li><a href="{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}">{translate key="plugins.themes.editorialjournal.nav.home"}</a></li>
						<li><a href="{url page="about" router=PKP\core\PKPApplication::ROUTE_PAGE}">{translate key="plugins.themes.editorialjournal.nav.about"}</a></li>
						<li><a href="{url page="issue" op="current" router=PKP\core\PKPApplication::ROUTE_PAGE}">{translate key="plugins.themes.editorialjournal.nav.currentIssue"}</a></li>
						<li><a href="{url page="issue" op="archive" router=PKP\core\PKPApplication::ROUTE_PAGE}">{translate key="plugins.themes.editorialjournal.nav.archives"}</a></li>
						<li><a href="{url page="about" op="submissions" router=PKP\core\PKPApplication::ROUTE_PAGE}">{translate key="plugins.themes.editorialjournal.nav.forAuthors"}</a></li>
						<li><a href="{url page="about" op="editorialMasthead" router=PKP\core\PKPApplication::ROUTE_PAGE}">{translate key="plugins.themes.editorialjournal.nav.editorialBoard"}</a></li>
						<li><a href="{url page="about" op="privacy" router=PKP\core\PKPApplication::ROUTE_PAGE}">{translate key="about.privacyStatement"}</a></li>
						<li><a href="{url page="about" op="contact" router=PKP\core\PKPApplication::ROUTE_PAGE}">{translate key="plugins.themes.editorialjournal.nav.contact"}</a></li>
					</ul>
				</nav>

				<div class="jcrtp-footer__connect">
					<h2 class="jcrtp-footer__heading">{translate key="plugins.themes.editorialjournal.footer.connect"}</h2>
					{if $jcrtpSocialLinks}
						<ul class="jcrtp-footer__social">
							{foreach from=$jcrtpSocialLinks key=network item=socialUrl}
								<li>
									<a href="{$socialUrl|escape}" rel="noopener" target="_blank" aria-label="{translate|escape key="plugins.themes.editorialjournal.footer.social.$network" journal=$jcrtpJournalName}">
										{if $network == 'linkedin'}
											<svg aria-hidden="true" focusable="false" viewBox="0 0 24 24"><path fill="currentColor" d="M6.9 8.6H3.6V20h3.3zM5.3 3.5a1.9 1.9 0 1 0 0 3.8 1.9 1.9 0 0 0 0-3.8M20.4 13.4c0-3.1-1.7-4.9-4.3-4.9-1.6 0-2.6.8-3.1 1.6V8.6H9.8V20h3.3v-6c0-1.5.6-2.6 2-2.6 1.3 0 1.9 1 1.9 2.6v6h3.4z"/></svg>
										{elseif $network == 'x'}
											<svg aria-hidden="true" focusable="false" viewBox="0 0 24 24"><path fill="currentColor" d="M17.8 3.5h3.1l-6.8 7.8 8 10.2h-6.3l-4.9-6.4-5.6 6.4H2.2l7.3-8.3L1.8 3.5h6.4l4.4 5.9zm-1.1 16.2h1.7L7.4 5.2H5.6z"/></svg>
										{elseif $network == 'facebook'}
											<svg aria-hidden="true" focusable="false" viewBox="0 0 24 24"><path fill="currentColor" d="M13.6 21v-7.9h2.7l.4-3.1h-3.1V8c0-.9.3-1.5 1.6-1.5h1.6V3.7c-.3 0-1.3-.1-2.4-.1-2.4 0-4 1.4-4 4.1V10H7.7v3.1h2.7V21z"/></svg>
										{else}
											<svg aria-hidden="true" focusable="false" viewBox="0 0 24 24"><path fill="currentColor" d="M22 8.2c-.2-1.6-1-2.7-2.6-2.9C16.9 5 12 5 12 5s-4.9 0-7.4.3C3 5.5 2.2 6.6 2 8.2 1.8 9.4 1.8 12 1.8 12s0 2.6.2 3.8c.2 1.6 1 2.7 2.6 2.9 2.5.3 7.4.3 7.4.3s4.9 0 7.4-.3c1.6-.2 2.4-1.3 2.6-2.9.2-1.2.2-3.8.2-3.8s0-2.6-.2-3.8M10 15.1V8.9l5.2 3.1z"/></svg>
										{/if}
									</a>
								</li>
							{/foreach}
						</ul>
					{/if}
					<ul class="jcrtp-footer__meta">
						{if $currentContext->getData('contactEmail')}
							<li><a href="mailto:{$currentContext->getData('contactEmail')|escape}">{$currentContext->getData('contactEmail')|escape}</a></li>
						{/if}
						{if $currentContext->getData('onlineIssn')}
							<li><strong>{translate key="plugins.themes.editorialjournal.onlineIssn"}:</strong> {$currentContext->getData('onlineIssn')|escape}</li>
						{/if}
						{if $currentContext->getData('printIssn')}
							<li><strong>{translate key="plugins.themes.editorialjournal.printIssn"}:</strong> {$currentContext->getData('printIssn')|escape}</li>
						{/if}
						<li>{translate key="plugins.themes.editorialjournal.footer.rights" year=$smarty.now|date_format:"Y" journal=$jcrtpJournalName|escape}</li>
					</ul>
				</div>

				{if $currentContext->getData('publishingMode') == APP\journal\Journal::PUBLISHING_MODE_OPEN}
					<p class="jcrtp-footer__oa">
						<svg aria-hidden="true" focusable="false" viewBox="0 0 40 40"><path fill="none" stroke="currentColor" stroke-width="3.4" stroke-linecap="round" d="M13 17v-5a7 7 0 0 1 14 0v1"/><circle cx="20" cy="26" r="9" fill="none" stroke="currentColor" stroke-width="3.4"/><circle cx="20" cy="26" r="3" fill="currentColor"/></svg>
						<span>{translate key="plugins.themes.editorialjournal.header.openAccess"}</span>
					</p>
				{/if}
			</div>
		{/if}

		{if $pageFooter}
			<div class="pkp_footer_content">
				{$pageFooter}
			</div>
		{/if}

		<div class="pkp_brand_footer">
			<a href="{url page="about" op="aboutThisPublishingSystem"}">
				<img alt="{translate key="about.aboutThisPublishingSystem"}" src="{$baseUrl}/{$brandImage}">
			</a>
		</div>
	</div>
</div><!-- pkp_structure_footer_wrapper -->

</div><!-- pkp_structure_page -->

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
