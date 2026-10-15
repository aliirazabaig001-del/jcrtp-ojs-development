#!/usr/bin/env bash
# Read-only live checks after deployment (anonymous reader view).
# Usage: ./04-smoke-test.sh [base-url]   e.g. https://jcrtp.com/index.php/jcrtp
set -uo pipefail
BASE="${1:-${SITE_URL:?set SITE_URL or pass base url}}"
FAIL=0
check() { # path expected-text
    local url="$BASE/$1" body code
    body="$(curl -sS -L --max-time 30 -w '\n%{http_code}' "$url")"; code="${body##*$'\n'}"; body="${body%$'\n'*}"
    if [ "$code" != 200 ]; then echo "FAIL $code $url"; FAIL=1; return; fi
    if [ -n "${2:-}" ] && ! grep -q "$2" <<<"$body"; then echo "FAIL missing '$2' at $url"; FAIL=1; return; fi
    if grep -qiE 'Fatal error|SmartyException|Stack trace|Warning: ' <<<"$body"; then echo "FAIL PHP/template error text at $url"; FAIL=1; return; fi
    echo "ok   $code $url"
}
check ""                          'jcrtp-hero'
check "about"                     'jcrtp-about'
check "issue/current"             'jcrtp-issue'
check "issue/archive"             'jcrtp-archive'
check "about/editorialMasthead"   'jcrtp-board'
check "editorial-process"         'jcrtp-ep__steps'
check "about/submissions"         'page_submissions'
check "about/contact"             'page_contact'
check "about/privacy"             'page_privacy'
check "search/search?query=cancer" 'jcrtp-search'
check "login"                     'page_login'
check "sitemap"                   '<urlset'
curl -sS -o /dev/null -w "logo image: %{http_code}\n" "${BASE%/index.php/*}/plugins/themes/editorialjournal/images/jcrtp-logo-official-480.png"
code="$(curl -sS -o /dev/null -w '%{http_code}' "${BASE%/index.php/*}/plugins/themes/editorialjournal/data/editorial-process-draft.html")"
[ "$code" = 403 ] || [ "$code" = 404 ] && echo "ok   theme data/ not publicly readable ($code)" || { echo "WARN theme data/ is publicly readable ($code): add the web server rule from DEPLOYMENT.md"; }
echo | openssl s_client -servername jcrtp.com -connect jcrtp.com:443 2>/dev/null | openssl x509 -noout -enddate
echo "Also open one article page and download its PDF in a browser (cannot be scripted without knowing article IDs)."
exit $FAIL
