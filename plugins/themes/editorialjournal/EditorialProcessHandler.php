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
        $content = file_get_contents(__DIR__ . '/data/editorial-process.html');
        if ($content === false) {
            throw new \RuntimeException('Unable to read the Editorial Process page content.');
        }

        $dispatcher = $request->getDispatcher();
        $submissionsUrl = $dispatcher->url(
            $request,
            Application::ROUTE_PAGE,
            null,
            'about',
            'submissions'
        );
        $contactUrl = $dispatcher->url(
            $request,
            Application::ROUTE_PAGE,
            null,
            'about',
            'contact'
        );
        $content = str_replace(
            ['href="../../about/submissions"', 'href="../../about/contact"'],
            [
                'href="' . htmlspecialchars($submissionsUrl, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8') . '"',
                'href="' . htmlspecialchars($contactUrl, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8') . '"',
            ],
            $content
        );

        // The page now uses the theme's shared banner, so the content's own
        // hero is dropped, and its <main> wrapper becomes a <div> because the
        // page already sits inside the OJS main content area.
        $content = preg_replace('#<header class="jcrtp-process-hero">.*?</header>#s', '', $content, 1);
        $content = preg_replace(['#<main(\s)#', '#</main>#'], ['<div$1', '</div>'], $content, 1);

        $pageUrl = $dispatcher->url(
            $request,
            Application::ROUTE_PAGE,
            null,
            'editorial-process'
        );
        $pageTitle = 'Editorial & Peer Review Process';
        $description = 'Explore the JCRTP editorial workflow from manuscript submission and screening through peer review, decision, revision, and publication.';
        $escape = static fn (string $value): string => htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');

        $templateManager = TemplateManager::getManager($request);
        $this->setupTemplate($request);
        $templateManager->assign([
            'pageTitle' => $pageTitle,
            'editorialProcessContent' => $content,
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
}
