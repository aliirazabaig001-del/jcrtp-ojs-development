<?php

/**
 * @file BackupPlugin.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2000-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @class BackupPlugin
 * @brief Plugin to allow generation of a backup extract
 */

namespace APP\plugins\generic\backup;

use APP\template\TemplateManager;
use PKP\config\Config;
use PKP\core\JSONMessage;
use PKP\linkAction\LinkAction;
use PKP\linkAction\request\AjaxModal;
use PKP\plugins\GenericPlugin;

class BackupPlugin extends GenericPlugin
{
    /**
     * @copydoc Plugin::register()
     */
    public function register($category, $path, $mainContextId = null): bool
    {
        if (parent::register($category, $path, $mainContextId)) {
            $this->addLocaleData();
            return true;
        }
        return false;
    }

    /**
     * Get the display name of this plugin
     */
    public function getDisplayName(): string
    {
        return __('plugins.generic.backup.name');
    }

    /**
     * Get the description of this plugin
     */
    public function getDescription(): string
    {
        return __('plugins.generic.backup.description');
    }

    /**
     * Designate this plugin as a site plugin
     */
    public function isSitePlugin(): bool
    {
        return true;
    }

    /**
     * @copydoc Plugin::getActions()
     */
    public function getActions($request, $verb): array
    {
        $router = $request->getRouter();
        return array_merge(
            $this->getEnabled() ? [
                new LinkAction(
                    'backup',
                    new AjaxModal(
                        $router->url($request, null, null, 'manage', null, ['verb' => 'backup', 'plugin' => $this->getName(), 'category' => 'generic']),
                        __('plugins.generic.backup.link')
                    ),
                    __('plugins.generic.backup.link'),
                    null
                ),
            ] : [],
            parent::getActions($request, $verb)
        );
    }

    /**
     * @copydoc Plugin::manage()
     */
    public function manage($args, $request): JSONMessage
    {
        switch ($request->getUserVar('verb')) {
            case 'backup':
                $templateMgr = TemplateManager::getManager($request);
                $templateMgr->assign([
                    'pluginName'           => $this->getName(),
                    'isDumpConfigured'     => Config::getVar('cli', 'dump') != '',
                    'isTarConfigured'      => Config::getVar('cli', 'tar') != '',
                    'errorMessage'         => __('plugins.generic.backup.failure')
                ]);
                $output = $templateMgr->fetch($this->getTemplateResource('index.tpl'));
                return new JSONMessage(true, $output);
            case 'db':
                $dumpTool = Config::getVar('cli', 'dump');
                header('Content-Description: File Transfer');
                header('Content-Disposition: attachment; filename=db-' . date('Y-m-d') . '.sql');
                header('Content-Type: application/sql');
                header('Content-Transfer-Encoding: binary');

                passthru(strtr($dumpTool, [
                    '{$hostname}'     => escapeshellarg(Config::getVar('database', 'host')),
                    '{$username}'     => escapeshellarg(Config::getVar('database', 'username')),
                    '{$password}'     => escapeshellarg(Config::getVar('database', 'password')),
                    '{$databasename}' => escapeshellarg(Config::getVar('database', 'name')),
                ]), $returnValue);
                if ($returnValue !== 0) {
                    header($_SERVER['SERVER_PROTOCOL'] . ' 500 Internal Server Error', true, 500);
                }
                exit();
            case 'files':
                $tarTool = Config::getVar('cli', 'tar');
                header('Content-Description: File Transfer');
                header('Content-Disposition: attachment; filename=files-' . date('Y-m-d') . '.tar.gz');
                header('Content-Type: application/gzip');
                header('Content-Transfer-Encoding: binary');
                passthru($tarTool . ' -c -f - -z ' . escapeshellarg(Config::getVar('files', 'files_dir')), $returnValue);
                if ($returnValue !== 0) {
                    header($_SERVER['SERVER_PROTOCOL'] . ' 500 Internal Server Error', true, 500);
                }
                exit();
            case 'code':
                $tarTool = Config::getVar('cli', 'tar');
                header('Content-Description: File Transfer');
                header('Content-Disposition: attachment; filename=code-' . date('Y-m-d') . '.tar.gz');
                header('Content-Type: application/gzip');
                header('Content-Transfer-Encoding: binary');
                passthru($tarTool . ' -c -f - -z ' . escapeshellarg(dirname(dirname(dirname(dirname(__FILE__))))), $returnValue);
                if ($returnValue !== 0) {
                    header($_SERVER['SERVER_PROTOCOL'] . ' 500 Internal Server Error', true, 500);
                }
                exit();
        }
        return parent::manage($args, $request);
    }
}
