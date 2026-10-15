{**
 * plugins/themes/editorialjournal/templates/frontend/components/jcrtp/navigationMenu.tpl
 *
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief JCRTP navigation menu, loaded with {load_menu path=...} from header.tpl.
 *  Items come from the OJS navigation menu via the jcrtp_nav_items modifier
 *  (EditorialJournalThemePlugin::buildNavigationItems). Dropdowns follow the
 *  disclosure pattern; js/theme.js adds hover, keyboard and mobile behaviour.
 *  The menu id differs from core's #navigationPrimary/#navigationUser so the
 *  default theme's Bootstrap dropdown script leaves these links intact.
 *
 * @uses navigationMenu NavigationMenu
 * @uses id string Element ID to assign the outer <ul>
 * @uses ulClass string Class name(s) to assign the outer <ul>
 * @uses liClass string Class name(s) to assign all <li> elements
 *}
{assign var=jcrtpIsPrimaryMenu value=false}
{if $id == 'jcrtpNavigationPrimary'}{assign var=jcrtpIsPrimaryMenu value=true}{/if}
{assign var=jcrtpNavItems value=$navigationMenu|jcrtp_nav_items:$jcrtpIsPrimaryMenu}
{if $jcrtpNavItems}
	<ul id="{$id|escape}" class="{$ulClass|escape} pkp_nav_list jcrtp-nav">
		{foreach from=$jcrtpNavItems item=navItem name=jcrtpNav}
			{assign var=submenuId value="`$id`-sub-`$smarty.foreach.jcrtpNav.index`"}
			<li class="{$liClass|escape} jcrtp-nav__item{if $navItem.children} has-submenu{/if}{if $navItem.current} is-current{/if}{if $navItem.isHome} is-home{/if}">
				{if $navItem.children}
					{if $navItem.url}
						<a class="jcrtp-nav__link" href="{$navItem.url|escape}"{if $navItem.current} aria-current="page"{/if}>{$navItem.label|escape}</a>
						<button type="button" class="jcrtp-nav__toggle jcrtp-nav__toggle--icon" aria-expanded="false" aria-controls="{$submenuId|escape}">
							<span class="pkp_screen_reader">{translate key="plugins.themes.editorialjournal.nav.submenu" name=$navItem.label|escape}</span>
						</button>
					{else}
						<button type="button" class="jcrtp-nav__link jcrtp-nav__toggle" aria-expanded="false" aria-controls="{$submenuId|escape}">{$navItem.label|escape}</button>
					{/if}
					<ul class="jcrtp-nav__submenu" id="{$submenuId|escape}">
						{foreach from=$navItem.children item=childItem}
							<li class="{$liClass|escape}">
								<a href="{$childItem.url|escape}"{if $childItem.current} aria-current="page"{/if}>{$childItem.label|escape}</a>
							</li>
						{/foreach}
					</ul>
				{else}
					<a class="jcrtp-nav__link" href="{$navItem.url|escape}"{if $navItem.current} aria-current="page"{/if}>
						{if $navItem.isHome}<svg class="jcrtp-nav__home-icon" aria-hidden="true" focusable="false" viewBox="0 0 24 24" width="22" height="22"><path fill="currentColor" d="M12 3.2 2.5 11.4l1.3 1.5L5 11.9V20.5h5.2v-5.6h3.6v5.6H19v-8.6l1.2 1 1.3-1.5L18 8.4V4.5h-2.6v1.7Z"/></svg>{/if}
						{$navItem.label|escape}
					</a>
				{/if}
			</li>
		{/foreach}
	</ul>
{/if}
