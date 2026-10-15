#!/usr/bin/env bash
# Shared helpers for the JCRTP ops scripts. Source, do not run.
set -euo pipefail

ENV_FILE="${JCRTP_ENV:-/root/jcrtp-ops/jcrtp.env}"
[ -f "$ENV_FILE" ] || { echo "Missing $ENV_FILE (copy ops/jcrtp.env.example and fill it in)" >&2; exit 1; }
# shellcheck disable=SC1090
. "$ENV_FILE"
for v in COMPOSE_DIR APP_SERVICE DB_SERVICE DB_ENGINE OJS_ROOT OJS_FILES_DIR WEB_USER BACKUP_ROOT SITE_URL THEME_VIA_DOCKER_CP; do
    [ -n "${!v:-}" ] || { echo "Variable $v is not set in $ENV_FILE" >&2; exit 1; }
done

dc() { (cd "$COMPOSE_DIR" && docker compose "$@"); }
app() { dc exec -T "$APP_SERVICE" "$@"; }
dbx() { dc exec -T "$DB_SERVICE" "$@"; }

# Read one [database] value from the live config.inc.php without printing it.
ojs_db() {
    app php -r '
        $c = parse_ini_file($argv[1], true, INI_SCANNER_RAW);
        echo trim((string) ($c["database"][$argv[2]] ?? ""), "\"");
    ' "$OJS_ROOT/config.inc.php" "$1"
}

log() { printf '[%s] %s\n' "$(date '+%F %T')" "$*"; }
