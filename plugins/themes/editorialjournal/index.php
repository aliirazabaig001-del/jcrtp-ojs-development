<?php

/**
 * OJS theme entry point.
 */

require_once __DIR__ . '/EditorialJournalThemePlugin.php';
require_once __DIR__ . '/EditorialProcessHandler.php';

return new \APP\plugins\themes\editorialjournal\EditorialJournalThemePlugin();