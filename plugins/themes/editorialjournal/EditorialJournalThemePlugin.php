<?php

/**
 * @file plugins/themes/editorialjournal/EditorialJournalThemePlugin.php
 *
 * Copyright (c) 2026 Editorial Journal Theme contributors
 * Distributed under the GNU GPL v3 or later.
 */

namespace APP\plugins\themes\editorialjournal;

use PKP\plugins\Hook;
use PKP\plugins\ThemePlugin;

/**
 * A child of OJS's default theme. OJS remains responsible for navigation,
 * accounts, submissions, metadata, galleys, and editorial workflows.
 */
class EditorialJournalThemePlugin extends ThemePlugin
{
    /** Networks offered as footer profile links, in display order. */
    protected const SOCIAL_NETWORKS = ['linkedin', 'x', 'facebook', 'youtube'];

    public function init()
    {
        $this->setParent('defaultthemeplugin');
        Hook::add('TemplateManager::display', $this->assignEditorialBoardData(...));
        Hook::add('TemplateManager::display', $this->addJcrtpBranding(...));
        Hook::add('TemplateManager::display', $this->registerNavigationModifier(...));
        Hook::add('TemplateManager::display', $this->assignHomepageData(...));
        Hook::add('LoadHandler', $this->registerEditorialProcessHandler(...));

        $this->addOption('jcrtpPrimaryColour', 'FieldColor', [
            'label' => __('plugins.themes.editorialjournal.option.primary'),
            'default' => '#0b2f5b',
        ]);
        $this->addOption('jcrtpAccentColour', 'FieldColor', [
            'label' => __('plugins.themes.editorialjournal.option.accent'),
            'default' => '#c2187a',
        ]);
        $this->addOption('enableIssueFilter', 'FieldOptions', [
            'label' => __('plugins.themes.editorialjournal.option.filter'),
            'options' => [[
                'value' => true,
                'label' => __('plugins.themes.editorialjournal.option.filter.enabled'),
            ]],
            'default' => true,
        ]);

        // Optional profile links for the footer's "Connect With Us" column.
        // Nothing is shown for a network until its URL is entered.
        foreach (self::SOCIAL_NETWORKS as $network) {
            $this->addOption('social' . ucfirst($network), 'FieldText', [
                'label' => __('plugins.themes.editorialjournal.option.social.' . $network),
                'description' => __('plugins.themes.editorialjournal.option.social.description'),
            ]);
        }

        // Plain CSS avoids a build step on the OJS server. Child styles load
        // after the parent stylesheet and only affect the reader-facing site.
        $this->addStyle('editorial-base', 'styles/base.css');
        $this->addStyle('editorial-chrome', 'styles/chrome.css');
        $this->addStyle('editorial-footer', 'styles/footer.css');
        $this->addStyle('editorial-home', 'styles/home.css');
        $this->addStyle('editorial-content', 'styles/content.css');
        $this->addStyle('editorial-board', 'styles/editorial-board.css');
        $this->addStyle('editorial-process', 'styles/editorial-process.css');
        $this->addStyle('editorial-responsive', 'styles/responsive.css');
        $primary = $this->validatedColour($this->getOption('jcrtpPrimaryColour'), '#0b2f5b');
        $accent = $this->validatedColour($this->getOption('jcrtpAccentColour'), '#c2187a');
        $this->addStyle('jcrtp-colours', ':root{--jcrtp-theme-primary:' . $primary
            . ';--jcrtp-theme-accent:' . $accent . ';}', ['inline' => true]);

        $labels = json_encode([
            'backToTop' => __('plugins.themes.editorialjournal.backToTop'),
            'articleNavigation' => __('plugins.themes.editorialjournal.articleNavigation'),
        ], JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT);
        $this->addScript('jcrtp-labels', 'window.JCRTPThemeLabels=' . $labels . ';', ['inline' => true]);
        $this->addScript('jcrtp-enhancements', 'js/theme.js');
    }

    public function registerEditorialProcessHandler($hookName, $args): bool
    {
        $page = &$args[0];
        $op = &$args[1];
        $handler = &$args[3];

        $isEditorialProcessRoute = $page === 'editorial-process';
        $isPagesIndexAlias = $page === 'pages' && $op === 'editorial-process';
        $isPagesViewAlias = $page === 'pages'
            && $op === 'view'
            && \APP\core\Application::get()->getRequest()->getRequestedArgs() === ['editorial-process'];

        if (!$isEditorialProcessRoute && !$isPagesIndexAlias && !$isPagesViewAlias) {
            return Hook::CONTINUE;
        }

        require_once __DIR__ . '/EditorialProcessHandler.php';
        $handler = new EditorialProcessHandler();

        if ($isPagesIndexAlias) {
            $op = 'index';
        }

        return true;
    }

    public function assignEditorialBoardData($hookName, $args): bool
    {
        $templateManager = $args[0];
        $template = $args[1];

        if ($template !== 'frontend/pages/editorialMasthead.tpl') {
            return Hook::CONTINUE;
        }

        $boardData = file_get_contents(__DIR__ . '/data/editorial-board.json');
        if ($boardData === false) {
            throw new \RuntimeException('Unable to read the Editorial Board data file.');
        }

        $members = json_decode($boardData, true, 512, JSON_THROW_ON_ERROR);
        if (!is_array($members)) {
            throw new \UnexpectedValueException('Editorial Board data must be a JSON array.');
        }

        $templateManager->assign([
            'editorialBoardMembers' => $members,
            'editorialBoardImageBase' => $this->_getBaseUrl('images/editorial-board'),
        ]);

        return Hook::CONTINUE;
    }

    public function addJcrtpBranding($hookName, $args): bool
    {
        $templateManager = $args[0];
        $template = $args[1];

        if (!is_string($template) || !str_starts_with($template, 'frontend/')) {
            return Hook::CONTINUE;
        }

        // Official logo (design-references/Logo.png, unmodified) used by the
        // header/footer template overrides.
        $templateManager->assign([
            'jcrtpLogoUrl' => $this->_getBaseUrl('images/jcrtp-logo-official.png'),
            'jcrtpLogoWidth' => 1896,
            'jcrtpLogoHeight' => 830,
        ]);

        // Footer data (footer.tpl): the journal description's first sentence
        // and the profile links entered in the theme settings.
        $context = \APP\core\Application::get()->getRequest()->getContext();
        if ($context) {
            $socialLinks = [];
            foreach (self::SOCIAL_NETWORKS as $network) {
                $url = trim((string) $this->getOption('social' . ucfirst($network)));
                if ($url !== '' && preg_match('#^https?://#i', $url) && filter_var($url, FILTER_VALIDATE_URL)) {
                    $socialLinks[$network] = $url;
                }
            }
            $templateManager->assign([
                'jcrtpFooterSummary' => $this->firstSentence((string) $context->getLocalizedData('description')),
                'jcrtpSocialLinks' => $socialLinks,
            ]);
        }

        $faviconUrl = htmlspecialchars(
            $this->_getBaseUrl('images/jcrtp-favicon.png'),
            ENT_QUOTES | ENT_SUBSTITUTE,
            'UTF-8'
        );
        $favicon32Url = htmlspecialchars(
            $this->_getBaseUrl('images/jcrtp-favicon-32.png'),
            ENT_QUOTES | ENT_SUBSTITUTE,
            'UTF-8'
        );
        $templateManager->addHeader(
            'jcrtpFavicon32',
            '<link rel="icon" type="image/png" sizes="32x32" href="' . $favicon32Url . '" />',
            ['contexts' => ['frontend']]
        );
        $templateManager->addHeader(
            'jcrtpFavicon',
            '<link rel="icon" type="image/png" sizes="192x192" href="' . $faviconUrl . '" />',
            ['contexts' => ['frontend']]
        );
        $templateManager->addHeader(
            'jcrtpAppleTouchIcon',
            '<link rel="apple-touch-icon" sizes="192x192" href="' . $faviconUrl . '" />',
            ['contexts' => ['frontend']]
        );

        return Hook::CONTINUE;
    }

    /**
     * Published-content data for the homepage (indexJournal.tpl). Everything
     * comes from OJS records: the latest published articles across all
     * issues, their section titles, the published-article count and the first
     * sentence of the journal description for the hero.
     */
    public function assignHomepageData($hookName, $args): bool
    {
        $templateManager = $args[0];
        $template = $args[1];

        if ($template !== 'frontend/pages/indexJournal.tpl') {
            return Hook::CONTINUE;
        }

        $context = \APP\core\Application::get()->getRequest()->getContext();
        if (!$context) {
            return Hook::CONTINUE;
        }

        $publishedCollector = fn () => \APP\facades\Repo::submission()->getCollector()
            ->filterByContextIds([$context->getId()])
            ->filterByStatus([\PKP\submission\PKPSubmission::STATUS_PUBLISHED]);

        $latestArticles = $publishedCollector()
            ->orderBy(\APP\submission\Collector::ORDERBY_DATE_PUBLISHED, \APP\submission\Collector::ORDER_DIR_DESC)
            ->limit(3)
            ->getMany()
            ->values()
            ->all();

        $sectionTitles = [];
        foreach ($latestArticles as $article) {
            $sectionId = $article->getCurrentPublication()?->getData('sectionId');
            if ($sectionId && !array_key_exists($sectionId, $sectionTitles)) {
                $sectionTitles[$sectionId] = \APP\facades\Repo::section()->get($sectionId, $context->getId())?->getLocalizedTitle() ?? '';
            }
        }

        $templateManager->assign([
            'jcrtpLatestArticles' => $latestArticles,
            'jcrtpSectionTitles' => $sectionTitles,
            'jcrtpPublishedArticleCount' => $latestArticles ? $publishedCollector()->getCount() : 0,
            'jcrtpHeroSummary' => $this->firstSentence((string) $context->getLocalizedData('description')),
        ]);

        return Hook::CONTINUE;
    }

    /** First sentence of an HTML description, as plain text ('' if none). */
    protected function firstSentence(string $html): string
    {
        $text = trim(preg_replace('/\s+/u', ' ', html_entity_decode(strip_tags($html), ENT_QUOTES | ENT_HTML5, 'UTF-8')));
        if ($text === '') {
            return '';
        }
        return preg_match('/^(.{40,}?[.!?])(\s|$)/u', $text, $matches) ? $matches[1] : $text;
    }

    public function registerNavigationModifier($hookName, $args): bool
    {
        $templateManager = $args[0];
        if (!isset($templateManager->registered_plugins['modifier']['jcrtp_nav_items'])) {
            $templateManager->registerPlugin('modifier', 'jcrtp_nav_items', $this->buildNavigationItems(...));
        }

        return Hook::CONTINUE;
    }

    /**
     * Turn an OJS navigation menu into the list rendered by
     * templates/frontend/components/jcrtp/navigationMenu.tpl.
     *
     * Every link comes from the journal's own OJS menu items. For the primary
     * menu, items are regrouped by their OJS type into the order of
     * design-references/header-navigation.png; items the theme does not
     * recognise keep their own title and children and follow afterwards.
     * A URL is only ever output once.
     *
     * @return array<int, array{label: string, url: ?string, current: bool, children: array}>
     */
    public function buildNavigationItems($navigationMenu, bool $isPrimary = false): array
    {
        if (!$navigationMenu || empty($navigationMenu->menuTree)) {
            return [];
        }

        $request = \APP\core\Application::get()->getRequest();
        $currentPath = $this->normaliseNavigationPath($request->getRequestUrl());
        $makeLink = fn ($item) => [
            'label' => $item->getLocalizedTitle(),
            'url' => $item->getUrl(),
            'current' => $currentPath !== '' && $this->normaliseNavigationPath($item->getUrl()) === $currentPath,
            'children' => [],
        ];
        $visibleChildren = function ($assignment) {
            if (!$assignment->navigationMenuItem->getIsChildVisible()) {
                return [];
            }
            return array_values(array_filter(
                $assignment->children ?? [],
                fn ($child) => $child->navigationMenuItem->getIsDisplayed()
            ));
        };

        $topLevel = array_values(array_filter(
            $navigationMenu->menuTree,
            fn ($assignment) => $assignment->navigationMenuItem->getIsDisplayed()
        ));

        if (!$isPrimary) {
            $items = [];
            foreach ($topLevel as $assignment) {
                $link = $makeLink($assignment->navigationMenuItem);
                $link['children'] = array_map(fn ($child) => $makeLink($child->navigationMenuItem), $visibleChildren($assignment));
                $items[] = $link;
            }
            return $this->dedupeNavigationItems($items);
        }

        // Single destinations shown as top-level links, and groups shown as
        // dropdowns, keyed by role in wireframe order.
        $singles = ['current' => null, 'archives' => null, 'board' => null, 'process' => null, 'contact' => null];
        $groups = ['about' => [], 'authors' => [], 'policies' => []];
        $aboutUrl = null;
        $others = [];

        $roleOf = function ($item): ?string {
            return match ($item->getType()) {
                \APP\services\NavigationMenuService::NMI_TYPE_CURRENT => 'current',
                \APP\services\NavigationMenuService::NMI_TYPE_ARCHIVES => 'archives',
                \PKP\navigationMenu\NavigationMenuItem::NMI_TYPE_MASTHEAD => 'board',
                \PKP\navigationMenu\NavigationMenuItem::NMI_TYPE_CONTACT => 'contact',
                \PKP\navigationMenu\NavigationMenuItem::NMI_TYPE_ABOUT => 'about',
                \PKP\navigationMenu\NavigationMenuItem::NMI_TYPE_SUBMISSIONS => 'authors',
                \PKP\navigationMenu\NavigationMenuItem::NMI_TYPE_PRIVACY => 'policies',
                \PKP\navigationMenu\NavigationMenuItem::NMI_TYPE_CUSTOM => $item->getPath() === 'editorial-process' ? 'process' : null,
                default => null,
            };
        };
        $place = function ($item, ?string $fallbackGroup) use (&$singles, &$groups, &$others, $roleOf, $makeLink): void {
            $role = $roleOf($item);
            if ($role !== null && array_key_exists($role, $singles)) {
                $singles[$role] ??= $makeLink($item);
            } elseif ($role !== null && array_key_exists($role, $groups)) {
                $groups[$role][] = $makeLink($item);
            } elseif ($fallbackGroup !== null) {
                $groups[$fallbackGroup][] = $makeLink($item);
            } else {
                $others[] = $makeLink($item);
            }
        };

        foreach ($topLevel as $assignment) {
            $item = $assignment->navigationMenuItem;
            $children = $visibleChildren($assignment);
            $role = $roleOf($item);

            if ($role === 'about' && $children) {
                // The About container's own page is reachable through its
                // "About the Journal" child, so it is not repeated as a link.
                $aboutUrl = $item->getUrl();
                foreach ($children as $child) {
                    $place($child->navigationMenuItem, 'about');
                }
            } elseif ($children) {
                // A container the theme does not recognise keeps its structure.
                $link = $makeLink($item);
                $link['children'] = array_map(fn ($child) => $makeLink($child->navigationMenuItem), $children);
                $others[] = $link;
            } else {
                $place($item, null);
            }
        }

        if (!$groups['about'] && $aboutUrl !== null) {
            $groups['about'][] = ['label' => '', 'url' => $aboutUrl, 'current' => false, 'children' => []];
        }

        $label = fn (string $key) => __('plugins.themes.editorialjournal.nav.' . $key);
        $groupItem = function (string $key, array $children) use ($label): ?array {
            if (!$children) {
                return null;
            }
            // An About container whose children were all promoted collapses to a plain link.
            if (count($children) === 1 && $children[0]['label'] === '') {
                return ['label' => $label($key), 'url' => $children[0]['url'], 'current' => $children[0]['current'], 'children' => []];
            }
            return [
                'label' => $label($key),
                'url' => null,
                'current' => in_array(true, array_column($children, 'current'), true),
                'children' => $children,
            ];
        };
        $singleItem = fn (string $key, ?array $link) => $link ? ['label' => $label($key)] + $link : null;

        // Home is the journal's OJS index route, not a stored menu item.
        $homeUrl = $request->getDispatcher()->url($request, \PKP\core\PKPApplication::ROUTE_PAGE, null, 'index');
        $items = array_filter([
            [
                'label' => $label('home'),
                'url' => $homeUrl,
                'current' => $this->normaliseNavigationPath($homeUrl) === $currentPath,
                'children' => [],
                'isHome' => true,
            ],
            $groupItem('about', $groups['about']),
            $singleItem('currentIssue', $singles['current']),
            $singleItem('archives', $singles['archives']),
            $singleItem('editorialBoard', $singles['board']),
            $groupItem('forAuthors', $groups['authors']),
            $singleItem('editorialProcess', $singles['process']),
            $groupItem('policies', $groups['policies']),
            $singleItem('contact', $singles['contact']),
        ]);

        return $this->dedupeNavigationItems(array_merge(array_values($items), $others));
    }

    /** Drop any link whose URL was already output earlier in the menu. */
    protected function dedupeNavigationItems(array $items): array
    {
        $seen = [];
        $result = [];
        foreach ($items as $item) {
            $children = [];
            foreach ($item['children'] as $child) {
                $key = $this->normaliseNavigationPath($child['url']);
                if ($key !== '' && isset($seen[$key])) {
                    continue;
                }
                $seen[$key] = true;
                $children[] = $child;
            }
            if ($item['url'] !== null) {
                $key = $this->normaliseNavigationPath($item['url']);
                if ($key !== '' && isset($seen[$key])) {
                    continue;
                }
                $seen[$key] = true;
            } elseif (!$children) {
                continue;
            }
            $item['children'] = $children;
            $result[] = $item;
        }
        return $result;
    }

    /** Compare URLs by path only, treating ".../index" as its parent. */
    protected function normaliseNavigationPath(?string $url): string
    {
        $path = (string) parse_url((string) $url, PHP_URL_PATH);
        $path = preg_replace('#/index$#', '', rtrim($path, '/'));
        return strtolower($path);
    }

    protected function validatedColour($colour, string $fallback): string
    {
        return is_string($colour) && preg_match('/^#[0-9a-fA-F]{6}$/', $colour)
            ? $colour : $fallback;
    }

    public function getDisplayName()
    {
        return __('plugins.themes.editorialjournal.name');
    }

    public function getDescription()
    {
        return __('plugins.themes.editorialjournal.description');
    }
}