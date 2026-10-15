<?php

/**
 * OJS page handler for the JCRTP editorial process.
 */

namespace APP\plugins\themes\editorialjournal;

use APP\core\Application;
use APP\template\TemplateManager;

class EditorialProcessHandler extends \APP\handler\Handler
{
    public function view($args, $request): void
    {
        if ($args !== ['editorial-process']) {
            throw new \Symfony\Component\HttpKernel\Exception\NotFoundHttpException();
        }

        $this->index([], $request);
    }

    public function index($args, $request): void
    {
        $dispatcher = $request->getDispatcher();
        $links = [
            'href="../../about/submissions"' => 'href="' . htmlspecialchars($dispatcher->url($request, Application::ROUTE_PAGE, null, 'about', 'submissions'), ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8') . '"',
            'href="../../about/contact"' => 'href="' . htmlspecialchars($dispatcher->url($request, Application::ROUTE_PAGE, null, 'about', 'contact'), ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8') . '"',
        ];

        // Public page: only the confirmed workflow (data/editorial-process.html).
        $content = strtr($this->readContent('editorial-process.html'), $links);

        // The earlier long-form draft (data/editorial-process-draft.html) still
        // awaits editorial confirmation, so it is shown only to journal
        // managers and editors, clearly labelled, and never to readers.
        $draftContent = '';
        $user = $request->getUser();
        $context = $request->getContext();
        if ($user && $context && (
            $user->hasRole([\PKP\security\Role::ROLE_ID_MANAGER, \PKP\security\Role::ROLE_ID_SUB_EDITOR], $context->getId())
            || $user->hasRole([\PKP\security\Role::ROLE_ID_SITE_ADMIN], \PKP\core\PKPApplication::SITE_CONTEXT_ID)
        )) {
            $draftContent = strtr($this->readContent('editorial-process-draft.html'), $links);
            $draftContent = preg_replace('#<header class="jcrtp-process-hero">.*?</header>#s', '', $draftContent, 1);
            $draftContent = preg_replace(['#<main(\s)#', '#</main>#'], ['<div$1', '</div>'], $draftContent, 1);
        }

        $pageUrl = $dispatcher->url(
            $request,
            Application::ROUTE_PAGE,
            null,
            'editorial-process'
        );
        $pageTitle = __('plugins.themes.editorialjournal.nav.editorialProcess');
        $description = 'The JCRTP editorial workflow, from online submission and editorial screening through peer review and decision to production and online publication.';
        $escape = static fn (string $value): string => htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');

        $templateManager = TemplateManager::getManager($request);
        $this->setupTemplate($request);
        $templateManager->assign([
            'pageTitle' => $pageTitle,
            'editorialProcessContent' => $content,
            'editorialProcessDraft' => $draftContent,
        ]);
        $templateManager->addHeader(
            'jcrtpEditorialProcessDescription',
            '<meta name="description" content="' . $escape($description) . '" />'
        );
        $templateManager->addHeader(
            'jcrtpEditorialProcessCanonical',
            '<link rel="canonical" href="' . $escape($pageUrl) . '" />'
        );
        $templateManager->addHeader(
            'jcrtpEditorialProcessOpenGraph',
            '<meta property="og:title" content="' . $escape($pageTitle . ' | JCRTP') . '" />'
                . '<meta property="og:description" content="' . $escape($description) . '" />'
                . '<meta property="og:type" content="website" />'
                . '<meta property="og:url" content="' . $escape($pageUrl) . '" />'
        );
        $templateManager->display('frontend/pages/editorialProcess.tpl');
    }

    /** Read a page fragment from the theme's data directory. */
    protected function readContent(string $file): string
    {
        $content = file_get_contents(__DIR__ . '/data/' . $file);
        if ($content === false) {
            throw new \RuntimeException('Unable to read the Editorial Process page content.');
        }
        return $content;
    }
}
