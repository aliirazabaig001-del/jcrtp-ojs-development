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
        Hook::add('TemplateManager::display', $this->assignAboutData(...));
        Hook::add('TemplateManager::display', $this->assignIssueData(...));
        Hook::add('TemplateManager::display', $this->assignArchiveData(...));
        Hook::add('TemplateManager::display', $this->addSeoHeaders(...));
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

        // Optional list for the About page's "Indexing & Abstracting" card.
        // Only services the editor enters are shown; nothing is listed by default.
        $this->addOption('indexingServices', 'FieldTextarea', [
            'label' => __('plugins.themes.editorialjournal.option.indexing'),
            'description' => __('plugins.themes.editorialjournal.option.indexing.description'),
        ]);

        // Plain CSS avoids a build step on the OJS server. Child styles load
        // after the parent stylesheet and only affect the reader-facing site.
        $this->addStyle('editorial-base', 'styles/base.css');
        $this->addStyle('editorial-chrome', 'styles/chrome.css');
        $this->addStyle('editorial-footer', 'styles/footer.css');
        $this->addStyle('editorial-home', 'styles/home.css');
        $this->addStyle('editorial-content', 'styles/content.css');
        $this->addStyle('editorial-inner', 'styles/inner.css');
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
            'issueMatches' => __('plugins.themes.editorialjournal.issue.matches', ['count' => '{count}']),
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

        // Intrinsic portrait sizes let browsers reserve space (no layout shift).
        foreach ($members as &$member) {
            $size = !empty($member['image']) ? @getimagesize(__DIR__ . '/images/editorial-board/' . basename((string) $member['image'])) : false;
            $member['imageWidth'] = $size[0] ?? null;
            $member['imageHeight'] = $size[1] ?? null;
        }
        unset($member);

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

        // Reader-facing templates: core frontend pages, plus the Static Pages
        // plugin's page template (journal policy pages), which is not named
        // "frontend/..." but uses the same header and footer.
        $isStaticPage = is_string($template) && str_contains($template, 'staticPages') && str_ends_with($template, ':content.tpl');
        if (!is_string($template) || (!str_starts_with($template, 'frontend/') && !$isStaticPage)) {
            return Hook::CONTINUE;
        }

        // Official logo (design-references/Logo.png, unmodified) used by the
        // header/footer template overrides.
        $templateManager->assign([
            'jcrtpLogoUrl' => $this->_getBaseUrl('images/jcrtp-logo-official.png'),
            'jcrtpLogoWidth' => 1896,
            'jcrtpLogoHeight' => 830,
            // Proportionally downscaled delivery copies of the same logo (no
            // crop, recolour or redraw) so browsers download ~100-340 KB
            // instead of the 1.3 MB original at the logo's display size.
            'jcrtpLogoSrcset' => $this->_getBaseUrl('images/jcrtp-logo-official-480.png') . ' 480w, '
                . $this->_getBaseUrl('images/jcrtp-logo-official-960.png') . ' 960w, '
                . $this->_getBaseUrl('images/jcrtp-logo-official.png') . ' 1896w',
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

    /**
     * About page (frontend/pages/about.tpl). The journal's own "About" text is
     * split at its h2/h3 headings so each part can be laid out as in
     * design-references/about-journal-desktop.png; the Key Information,
     * Indexing and Contact cards list only values held by OJS or entered in
     * the theme settings.
     */
    public function assignAboutData($hookName, $args): bool
    {
        $templateManager = $args[0];
        if ($args[1] !== 'frontend/pages/about.tpl') {
            return Hook::CONTINUE;
        }
        $context = \APP\core\Application::get()->getRequest()->getContext();
        if (!$context) {
            return Hook::CONTINUE;
        }

        [$intro, $sections] = $this->splitAboutContent((string) $context->getLocalizedData('about'));

        $keyInfo = [];
        foreach (['onlineIssn' => 'onlineIssn', 'printIssn' => 'printIssn'] as $field => $key) {
            if ($value = trim((string) $context->getData($field))) {
                $keyInfo[] = ['label' => __('plugins.themes.editorialjournal.' . $key), 'value' => $value];
            }
        }
        if ($context->getData('publishingMode') == \APP\journal\Journal::PUBLISHING_MODE_OPEN) {
            $keyInfo[] = ['label' => __('plugins.themes.editorialjournal.header.openAccess'), 'value' => __('common.yes')];
        }
        if ($context->getData('paymentsEnabled') && (float) $context->getData('publicationFee') > 0) {
            $keyInfo[] = [
                'label' => (string) $context->getLocalizedData('publicationFeeName') ?: __('plugins.themes.editorialjournal.about.apc'),
                'value' => trim($context->getData('publicationFee') . ' ' . $context->getData('currency')),
            ];
        }
        $localeNames = array_filter(array_map(
            fn ($locale) => \PKP\facades\Locale::getMetadata($locale)?->getDisplayName(null),
            (array) $context->getData('supportedLocales')
        ));
        if ($localeNames) {
            $keyInfo[] = ['label' => __('plugins.themes.editorialjournal.about.language'), 'value' => implode(', ', $localeNames)];
        }
        if ($publisher = trim((string) $context->getData('publisherInstitution'))) {
            $keyInfo[] = ['label' => __('plugins.themes.editorialjournal.about.publisher'), 'value' => $publisher];
        }

        $templateManager->assign([
            'jcrtpAboutIntro' => $intro,
            'jcrtpAboutSections' => $sections,
            'jcrtpAboutSummary' => $this->firstSentence((string) $context->getLocalizedData('description')),
            'jcrtpKeyInfo' => $keyInfo,
            'jcrtpIndexingServices' => $this->parseIndexingServices((string) $this->getOption('indexingServices')),
        ]);

        return Hook::CONTINUE;
    }

    /**
     * Split journal "About" HTML at its h2/h3 headings.
     *
     * @return array{0: string, 1: array<int, array{id: string, title: string, level: int, html: string, icon: string}>}
     */
    protected function splitAboutContent(string $html): array
    {
        if (trim(strip_tags($html)) === '') {
            return ['', []];
        }
        $document = new \DOMDocument();
        $previous = libxml_use_internal_errors(true);
        $document->loadHTML('<?xml encoding="UTF-8"><div id="jcrtp-about-root">' . $html . '</div>', LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
        libxml_clear_errors();
        libxml_use_internal_errors($previous);
        $root = $document->getElementById('jcrtp-about-root');
        if (!$root) {
            return [$html, []];
        }

        $intro = '';
        $sections = [];
        $usedIds = [];
        foreach (iterator_to_array($root->childNodes) as $node) {
            $isHeading = $node instanceof \DOMElement && in_array(strtolower($node->nodeName), ['h2', 'h3'], true);
            if ($isHeading && trim($node->textContent) !== '') {
                $title = trim(preg_replace('/\s+/u', ' ', $node->textContent));
                $id = 'about-' . (trim(preg_replace('/[^a-z0-9]+/', '-', strtolower($title)), '-') ?: 'section');
                for ($base = $id, $n = 2; isset($usedIds[$id]); $n++) {
                    $id = $base . '-' . $n;
                }
                $usedIds[$id] = true;
                $sections[] = ['id' => $id, 'title' => $title, 'level' => (int) substr(strtolower($node->nodeName), 1), 'html' => '', 'icon' => $this->aboutSectionIcon($title)];
                continue;
            }
            $markup = $document->saveHTML($node);
            if ($sections) {
                $sections[count($sections) - 1]['html'] .= $markup;
            } else {
                $intro .= $markup;
            }
        }
        return [trim($intro), $sections];
    }

    /** Icon for an About section, chosen from its heading. */
    protected function aboutSectionIcon(string $title): string
    {
        $title = strtolower($title);
        return match (true) {
            str_contains($title, 'mission') => 'mission',
            str_contains($title, 'vision') => 'vision',
            str_contains($title, 'value') => 'values',
            str_contains($title, 'scope') || str_contains($title, 'aim') => 'scope',
            str_contains($title, 'histor') => 'history',
            default => 'document',
        };
    }

    /**
     * Theme setting "Indexing services": one service per line, optionally
     * "Name | https://link".
     *
     * @return array<int, array{name: string, url: ?string}>
     */
    protected function parseIndexingServices(string $value): array
    {
        $services = [];
        foreach (preg_split('/\R/u', $value) as $line) {
            $parts = array_map('trim', explode('|', $line, 2));
            if ($parts[0] === '') {
                continue;
            }
            $url = $parts[1] ?? '';
            $services[] = [
                'name' => $parts[0],
                'url' => preg_match('#^https?://#i', $url) && filter_var($url, FILTER_VALIDATE_URL) ? $url : null,
            ];
        }
        return $services;
    }

    /**
     * Issue page (frontend/pages/issue.tpl): counts, page range and section
     * list for the layout of design-references/current-issue-desktop.png,
     * derived from the articles OJS assigned to the template.
     */
    public function assignIssueData($hookName, $args): bool
    {
        $templateManager = $args[0];
        if ($args[1] !== 'frontend/pages/issue.tpl') {
            return Hook::CONTINUE;
        }
        $issue = $templateManager->getTemplateVars('issue');
        $context = \APP\core\Application::get()->getRequest()->getContext();
        if (!$issue || !$context) {
            return Hook::CONTINUE;
        }

        $sections = [];
        $articleCount = 0;
        $firstPage = null;
        $lastPage = null;
        $pagesKnown = true;
        foreach ((array) $templateManager->getTemplateVars('publishedSubmissions') as $sectionId => $section) {
            $count = count($section['articles'] ?? []);
            if (!$count) {
                continue;
            }
            $articleCount += $count;
            $sections[] = ['id' => (int) $sectionId, 'title' => (string) ($section['title'] ?? ''), 'count' => $count];
            foreach ($section['articles'] as $article) {
                $pages = trim((string) $article->getCurrentPublication()?->getData('pages'));
                if (preg_match('/^(\d+)\s*[-\x{2013}]\s*(\d+)$/u', $pages, $m) || preg_match('/^(\d+)$/', $pages, $m)) {
                    $start = (int) $m[1];
                    $end = (int) ($m[2] ?? $m[1]);
                    $firstPage = $firstPage === null ? $start : min($firstPage, $start);
                    $lastPage = $lastPage === null ? $end : max($lastPage, $end);
                } else {
                    $pagesKnown = false;
                }
            }
        }

        $currentIssue = \APP\facades\Repo::issue()->getCurrent($context->getId());
        $templateManager->assign([
            'jcrtpIssueSections' => $sections,
            'jcrtpIssueArticleCount' => $articleCount,
            'jcrtpIssuePageRange' => $pagesKnown && $firstPage !== null ? $firstPage . '–' . $lastPage : '',
            'jcrtpIsCurrentIssue' => $currentIssue && $currentIssue->getId() === $issue->getId(),
            'jcrtpIssueFilter' => (bool) $this->getOption('enableIssueFilter'),
        ]);

        return Hook::CONTINUE;
    }

    /**
     * Archive page (frontend/pages/issueArchive.tpl): number of published
     * articles in each listed issue, for the issue cards.
     */
    public function assignArchiveData($hookName, $args): bool
    {
        $templateManager = $args[0];
        if ($args[1] !== 'frontend/pages/issueArchive.tpl') {
            return Hook::CONTINUE;
        }
        $context = \APP\core\Application::get()->getRequest()->getContext();
        $issues = $templateManager->getTemplateVars('issues');
        if (!$context || empty($issues)) {
            return Hook::CONTINUE;
        }

        $counts = [];
        foreach ($issues as $issue) {
            $counts[$issue->getId()] = \APP\facades\Repo::submission()->getCollector()
                ->filterByContextIds([$context->getId()])
                ->filterByIssueIds([$issue->getId()])
                ->filterByStatus([\PKP\submission\PKPSubmission::STATUS_PUBLISHED])
                ->getCount();
        }
        $currentIssue = \APP\facades\Repo::issue()->getCurrent($context->getId());
        $templateManager->assign([
            'jcrtpIssueArticleCounts' => $counts,
            'jcrtpCurrentIssueId' => $currentIssue?->getId(),
        ]);

        return Hook::CONTINUE;
    }

    /**
     * Smarty modifier "jcrtp_anchored": give every h2/h3 in OJS-managed HTML
     * (privacy statement, static pages, author guidelines...) a stable id and
     * return the h2 headings as an in-page table of contents. The HTML itself
     * is otherwise returned unchanged.
     *
     * @return array{html: string, toc: array<int, array{id: string, title: string}>}
     */
    public function anchorHeadings($html, string $prefix = 'section'): array
    {
        $html = (string) $html;
        if (trim(strip_tags($html)) === '' || !preg_match('/<h[23][\s>]/i', $html)) {
            return ['html' => $html, 'toc' => []];
        }
        $document = new \DOMDocument();
        $previous = libxml_use_internal_errors(true);
        $document->loadHTML('<?xml encoding="UTF-8"><div id="jcrtp-anchor-root">' . $html . '</div>', LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
        libxml_clear_errors();
        libxml_use_internal_errors($previous);
        $root = $document->getElementById('jcrtp-anchor-root');
        if (!$root) {
            return ['html' => $html, 'toc' => []];
        }

        $toc = [];
        $usedIds = [];
        $xpath = new \DOMXPath($document);
        foreach ($xpath->query('.//h2|.//h3', $root) as $heading) {
            $title = trim(preg_replace('/\s+/u', ' ', $heading->textContent));
            if ($title === '') {
                continue;
            }
            $id = $heading->getAttribute('id');
            if ($id === '') {
                $id = $prefix . '-' . (trim(preg_replace('/[^a-z0-9]+/', '-', strtolower($title)), '-') ?: 'part');
                for ($base = $id, $n = 2; isset($usedIds[$id]); $n++) {
                    $id = $base . '-' . $n;
                }
                $heading->setAttribute('id', $id);
            }
            $usedIds[$id] = true;
            if (strtolower($heading->nodeName) === 'h2') {
                $toc[] = ['id' => $id, 'title' => $title];
            }
        }

        $output = '';
        foreach (iterator_to_array($root->childNodes) as $node) {
            $output .= $document->saveHTML($node);
        }
        return ['html' => $output, 'toc' => $toc];
    }

    /**
     * Meta description, canonical URL and Open Graph / Twitter tags for the
     * main reader pages, built only from OJS data. Search, login and other
     * transactional pages are left alone, as is everything OJS or plugins
     * already output (citation_*, DC.* metadata). The Editorial Process page
     * adds its own tags in EditorialProcessHandler.
     */
    public function addSeoHeaders($hookName, $args): bool
    {
        $templateManager = $args[0];
        $template = $args[1];
        $simplePages = [
            'frontend/pages/issueArchive.tpl', 'frontend/pages/editorialMasthead.tpl',
            'frontend/pages/submissions.tpl', 'frontend/pages/contact.tpl',
            'frontend/pages/privacy.tpl', 'frontend/pages/announcements.tpl',
        ];
        $richPages = ['frontend/pages/indexJournal.tpl', 'frontend/pages/about.tpl', 'frontend/pages/issue.tpl', 'frontend/pages/article.tpl'];
        if (!is_string($template) || (!in_array($template, $richPages, true) && !in_array($template, $simplePages, true))) {
            return Hook::CONTINUE;
        }
        $request = \APP\core\Application::get()->getRequest();
        $context = $request->getContext();
        if (!$context) {
            return Hook::CONTINUE;
        }

        $dispatcher = $request->getDispatcher();
        $pageUrl = fn (string $page, ?string $op = null, $path = null) => $dispatcher->url($request, \PKP\core\PKPApplication::ROUTE_PAGE, null, $page, $op, $path);
        $journalName = (string) $context->getLocalizedName();
        $journalSummary = $this->firstSentence((string) $context->getLocalizedData('description'));
        $title = $journalName;
        $description = '';
        $canonical = null;
        $type = 'website';
        $image = $this->_getBaseUrl('images/jcrtp-logo-official.png');

        switch ($template) {
            case 'frontend/pages/indexJournal.tpl':
                $description = $journalSummary;
                $canonical = $pageUrl('index');
                break;
            case 'frontend/pages/about.tpl':
                $title = __('about.aboutContext') . ' | ' . $journalName;
                $description = $journalSummary;
                $canonical = $pageUrl('about');
                break;
            case 'frontend/pages/issue.tpl':
                $issue = $templateManager->getTemplateVars('issue');
                if (!$issue) {
                    return Hook::CONTINUE;
                }
                $title = $issue->getIssueIdentification() . ' | ' . $journalName;
                $description = $this->firstSentence((string) $issue->getLocalizedDescription()) ?: $journalSummary;
                $canonical = $pageUrl('issue', 'view', [(string) $issue->getBestIssueId()]);
                $image = $issue->getLocalizedCoverImageUrl() ?: $image;
                break;
            case 'frontend/pages/article.tpl':
                $article = $templateManager->getTemplateVars('article');
                $publication = $templateManager->getTemplateVars('publication');
                if (!$article || !$publication) {
                    return Hook::CONTINUE;
                }
                $title = trim(strip_tags((string) $publication->getLocalizedFullTitle())) . ' | ' . $journalName;
                $abstract = trim(preg_replace('/\s+/u', ' ', html_entity_decode(strip_tags((string) $publication->getLocalizedData('abstract')), ENT_QUOTES | ENT_HTML5, 'UTF-8')));
                $description = mb_strlen($abstract) > 200 ? rtrim(mb_substr($abstract, 0, 197)) . '…' : $abstract;
                $canonical = $pageUrl('article', 'view', [(string) $article->getBestId()]);
                $type = 'article';
                if ($publication->getLocalizedData('coverImage')) {
                    $image = $publication->getLocalizedCoverImageUrl($context->getId());
                }
                break;
            default:
                // Simple pages: canonical URL and sharing title only (first archive page only).
                if ($template === 'frontend/pages/issueArchive.tpl' && $templateManager->getTemplateVars('prevPage')) {
                    return Hook::CONTINUE;
                }
                $canonical = (string) strtok($request->getCompleteUrl(), '?');
                $pageTitle = $templateManager->getTemplateVars('pageTitleTranslated');
                $title = ($pageTitle ? trim(strip_tags((string) $pageTitle)) . ' | ' : '') . $journalName;
        }

        $escape = fn (string $value): string => htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
        $tags = [];
        if ($description !== '') {
            $tags[] = '<meta name="description" content="' . $escape($description) . '" />';
        }
        if ($canonical) {
            $tags[] = '<link rel="canonical" href="' . $escape($canonical) . '" />';
            $tags[] = '<meta property="og:url" content="' . $escape($canonical) . '" />';
        }
        $tags[] = '<meta property="og:site_name" content="' . $escape($journalName) . '" />';
        $tags[] = '<meta property="og:title" content="' . $escape($title) . '" />';
        $tags[] = '<meta property="og:type" content="' . $type . '" />';
        if ($description !== '') {
            $tags[] = '<meta property="og:description" content="' . $escape($description) . '" />';
        }
        $tags[] = '<meta property="og:image" content="' . $escape($image) . '" />';
        $tags[] = '<meta name="twitter:card" content="summary" />';

        $templateManager->addHeader('jcrtpSeo', implode("\n", $tags), ['contexts' => ['frontend']]);

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
        if (!isset($templateManager->registered_plugins['modifier']['jcrtp_anchored'])) {
            $templateManager->registerPlugin('modifier', 'jcrtp_anchored', $this->anchorHeadings(...));
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