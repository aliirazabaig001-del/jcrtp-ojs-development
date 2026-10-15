{**
 * Issue label in the wireframe's wording: "Volume 1, Issue 1" (or
 * "Vol. 1, No. 1" with short=true) when OJS shows both volume and number,
 * otherwise the issue's own OJS identification.
 *
 * @uses $issue Issue
 * @uses $short bool
 *}
{if $issue->getShowVolume() && $issue->getVolume() && $issue->getShowNumber() && $issue->getNumber()}
    {if $short}
        {translate key="plugins.themes.editorialjournal.issue.labelShort" volume=$issue->getVolume()|escape number=$issue->getNumber()|escape}
    {else}
        {translate key="plugins.themes.editorialjournal.issue.label" volume=$issue->getVolume()|escape number=$issue->getNumber()|escape}
    {/if}
{else}
    {$issue->getIssueIdentification()|escape}
{/if}
