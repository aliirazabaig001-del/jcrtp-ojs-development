/* Progressive enhancements; native OJS links and content work without JS. */
(() => {
    'use strict';

    function setupFilter() {
        const research = document.querySelector('.jcrtp-research');
        const filter = research?.querySelector('.jcrtp-filter');
        if (!filter) return;
        const input = filter.querySelector('input[type="search"]');
        const status = filter.querySelector('.jcrtp-filter__status');
        const empty = research.querySelector('.jcrtp-filter__empty');
        const items = [...research.querySelectorAll('.cmp_article_list > li')]
            .filter(item => item.querySelector('.obj_article_summary'));
        if (!items.length || !input || !status) return;

        const normalize = text => text.normalize('NFKD').toLocaleLowerCase()
            .replace(/[\u0300-\u036f]/g, '');
        const searchable = items.map(item => ({
            item,
            text: normalize([
                item.querySelector('.title')?.textContent || '',
                item.querySelector('.authors')?.textContent || '',
            ].join(' ')),
        }));
        const sections = [...research.querySelectorAll('.obj_issue_toc .section')];
        const countTemplate = status.dataset.countTemplate;
        function update() {
            const terms = normalize(input.value.trim()).split(/\s+/).filter(Boolean);
            let visible = 0;
            searchable.forEach(({item, text}) => {
                item.hidden = !terms.every(term => text.includes(term));
                if (!item.hidden) visible++;
            });
            sections.forEach(section => {
                const children = [...section.querySelectorAll('.cmp_article_list > li')];
                section.hidden = children.length > 0 && children.every(item => item.hidden);
            });
            if (countTemplate) {
                status.textContent = countTemplate.replace(':visible', visible).replace(':total', items.length);
            }
            if (empty) empty.hidden = visible !== 0;
        }
        filter.hidden = false;
        input.addEventListener('input', update);
        filter.querySelector('.jcrtp-filter__clear')?.addEventListener('click', () => {
            input.value = '';
            update();
            input.focus();
        });
        update();
    }

    function setupReadingNavigation(labels) {
        const article = document.querySelector('.obj_article_details');
        if (!article || !labels.articleNavigation) return;
        const nav = document.createElement('nav');
        nav.className = 'jcrtp-article-nav';
        nav.setAttribute('aria-label', labels.articleNavigation);
        ['abstract', 'galleys', 'references'].forEach(name => {
            const section = article.querySelector('.item.' + name);
            const label = section?.querySelector('.label');
            if (!section || !label?.textContent.trim()) return;
            if (!section.id) section.id = 'jcrtp-article-' + name;
            const link = document.createElement('a');
            link.href = '#' + section.id;
            link.textContent = label.textContent.trim();
            nav.append(link);
        });
        if (nav.children.length > 1) article.prepend(nav);
    }

    function setupBackToTop(labels) {
        if (!labels.backToTop || !document.querySelector('.pkp_structure_page')) return;
        const button = document.createElement('button');
        button.className = 'jcrtp-back-to-top';
        button.type = 'button';
        button.textContent = '↑';
        button.setAttribute('aria-label', labels.backToTop);
        button.title = labels.backToTop;
        button.hidden = true;
        button.addEventListener('click', () => {
            window.scrollTo({
                top: 0,
                behavior: window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth',
            });
            const focusTarget = document.querySelector('.pkp_site_name a');
            focusTarget?.focus({preventScroll: true});
        });
        document.querySelector('.pkp_structure_page').append(button);
        const update = () => { button.hidden = window.scrollY < 500; };
        window.addEventListener('scroll', update, {passive: true});
        update();
    }

    function setupMobileAccessibility() {
        const toggle = document.querySelector('.pkp_site_nav_toggle');
        const menu = document.querySelector('.pkp_site_nav_menu');
        if (!toggle || !menu) return;
        if (!menu.id) menu.id = 'jcrtp-site-navigation';
        toggle.setAttribute('aria-controls', menu.id);
        const sync = () => toggle.setAttribute(
            'aria-expanded', String(menu.classList.contains('pkp_site_nav_menu--isOpen'))
        );
        sync();
        new MutationObserver(sync).observe(menu, {attributes: true, attributeFilter: ['class']});
        document.addEventListener('keydown', event => {
            if (event.key === 'Escape' && menu.classList.contains('pkp_site_nav_menu--isOpen')) {
                toggle.click();
                toggle.focus();
            }
        });
    }

    function init() {
        const labels = window.JCRTPThemeLabels || {};
        setupFilter();
        setupReadingNavigation(labels);
        setupBackToTop(labels);
        setupMobileAccessibility();
    }
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init, {once: true});
    else init();
})();