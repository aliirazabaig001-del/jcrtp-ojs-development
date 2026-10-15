<?php

/**
 * @file plugins/themes/editorialjournal/EditorialJournalThemePlugin.php
 *
 * Copyright (c) 2026 Editorial Journal Theme contributors
 * Distributed under the GNU GPL v3 or later.
 */

namespace APP\plugins\themes\editorialjournal;

use PKP\plugins\ThemePlugin;

/**
 * A child of OJS's default theme. OJS remains responsible for navigation,
 * accounts, submissions, metadata, galleys, and editorial workflows.
 */
class EditorialJournalThemePlugin extends ThemePlugin
{
    public function init()
    {
        $this->setParent('defaultthemeplugin');

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

        // Plain CSS avoids a build step on the OJS server. Child styles load
        // after the parent stylesheet and only affect the reader-facing site.
        $this->addStyle('editorial-base', 'styles/base.css');
        $this->addStyle('editorial-chrome', 'styles/chrome.css');
        $this->addStyle('editorial-home', 'styles/home.css');
        $this->addStyle('editorial-content', 'styles/content.css');
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