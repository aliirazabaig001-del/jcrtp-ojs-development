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

        // Plain CSS avoids a build step on the OJS server. Child styles load
        // after the parent stylesheet and only affect the reader-facing site.
        $this->addStyle('editorial-base', 'styles/base.css');
        $this->addStyle('editorial-chrome', 'styles/chrome.css');
        $this->addStyle('editorial-home', 'styles/home.css');
        $this->addStyle('editorial-content', 'styles/content.css');
        $this->addStyle('editorial-responsive', 'styles/responsive.css');
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