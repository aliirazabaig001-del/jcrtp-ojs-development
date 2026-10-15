{**
 * Feature strip below the hero (design-references/Homepage.png). The copy
 * paraphrases the OJS journal description; it makes no metric or indexing
 * claims. The open-access item only appears when OJS publishes openly.
 *}
<section class="jcrtp-features" aria-label="{translate|escape key="plugins.themes.editorialjournal.features.label"}">
    <ul class="jcrtp-features__list">
        <li class="jcrtp-feature">
            <span class="jcrtp-feature__icon" aria-hidden="true"><svg viewBox="0 0 40 40" focusable="false"><path fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" d="M17 6l6 3-6 12-6-3zM20 15l4 2M14 21a8 8 0 1 0 12 7M9 34h22M20 34v-4"/></svg></span>
            <div>
                <h2 class="jcrtp-feature__title">{translate key="plugins.themes.editorialjournal.features.quality.title"}</h2>
                <p>{translate key="plugins.themes.editorialjournal.features.quality.copy"}</p>
            </div>
        </li>
        <li class="jcrtp-feature">
            <span class="jcrtp-feature__icon" aria-hidden="true"><svg viewBox="0 0 40 40" focusable="false"><circle cx="20" cy="20" r="13" fill="none" stroke="currentColor" stroke-width="2.3"/><path fill="none" stroke="currentColor" stroke-width="2.3" d="M7 20h26M20 7c-5 6-5 20 0 26M20 7c5 6 5 20 0 26M10 13h20M10 27h20"/></svg></span>
            <div>
                <h2 class="jcrtp-feature__title">{translate key="plugins.themes.editorialjournal.features.global.title"}</h2>
                <p>{translate key="plugins.themes.editorialjournal.features.global.copy"}</p>
            </div>
        </li>
        {if $currentJournal->getData('publishingMode') == APP\journal\Journal::PUBLISHING_MODE_OPEN}
            <li class="jcrtp-feature">
                <span class="jcrtp-feature__icon" aria-hidden="true"><svg viewBox="0 0 40 40" focusable="false"><path fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" d="M13 16v-5a7 7 0 0 1 14 0v1"/><circle cx="20" cy="25" r="9" fill="none" stroke="currentColor" stroke-width="2.6"/><circle cx="20" cy="25" r="3" fill="currentColor"/></svg></span>
                <div>
                    <h2 class="jcrtp-feature__title">{translate key="plugins.themes.editorialjournal.header.openAccess"}</h2>
                    <p>{translate key="plugins.themes.editorialjournal.features.openAccess.copy"}</p>
                </div>
            </li>
        {/if}
        <li class="jcrtp-feature">
            <span class="jcrtp-feature__icon" aria-hidden="true"><svg viewBox="0 0 40 40" focusable="false"><circle cx="20" cy="20" r="13" fill="none" stroke="currentColor" stroke-width="2.3"/><circle cx="20" cy="20" r="7.5" fill="none" stroke="currentColor" stroke-width="2.3"/><circle cx="20" cy="20" r="2.5" fill="currentColor"/><path fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" d="M21 19 33 7m-4 0h4v4"/></svg></span>
            <div>
                <h2 class="jcrtp-feature__title">{translate key="plugins.themes.editorialjournal.features.impact.title"}</h2>
                <p>{translate key="plugins.themes.editorialjournal.features.impact.copy"}</p>
            </div>
        </li>
    </ul>
</section>
