#!/usr/bin/env bash
# Deploy ONLY plugins/themes/editorialjournal from an approved release commit.
# Database, uploaded files, users, submissions and config.inc.php are never
# touched. Usage: ./03-deploy-theme.sh <release-dir-or-tarball> <commit-sha>
. "$(dirname "$0")/lib.sh"
SRC="${1:?release theme directory or .tar.gz}"; SHA="${2:?approved commit sha}"
LATEST="$(cat "$BACKUP_ROOT/LATEST" 2>/dev/null || true)"
[ -n "$LATEST" ] && [ -f "$LATEST/SHA256SUMS" ] || { echo "No verified backup found. Run 02-backup.sh first." >&2; exit 1; }
find "$LATEST" -name SHA256SUMS -mmin -720 | grep -q . || { echo "Latest backup is older than 12 h. Run 02-backup.sh again." >&2; exit 1; }

STAGE="$(mktemp -d /root/jcrtp-stage.XXXXXX)"
if [ -d "$SRC" ]; then cp -a "$SRC"/. "$STAGE"/; else tar -xzf "$SRC" -C "$STAGE"; fi
[ -f "$STAGE/EditorialJournalThemePlugin.php" ] && [ -f "$STAGE/version.xml" ] || { echo "Not an editorialjournal theme directory" >&2; exit 1; }
for x in "reference-files" "styles/home - backup.css"; do [ ! -e "$STAGE/$x" ] || { echo "Release contains archived material ($x); refusing." >&2; exit 1; }; done
echo "$SHA" > "$STAGE/RELEASE"

log "Syntax check of theme PHP inside the app container (same PHP as production)"
TMPC="/tmp/jcrtp-theme-$SHA"
dc cp "$STAGE" "$APP_SERVICE:$TMPC"
app sh -c "for f in $TMPC/*.php; do php -l \"\$f\" >/dev/null || exit 1; done && rm -rf $TMPC"

THEME_IN_CONTAINER="$OJS_ROOT/plugins/themes/editorialjournal"
KEEP="$BACKUP_ROOT/theme-previous-$(date +%Y%m%d-%H%M%S)"
if [ "$THEME_VIA_DOCKER_CP" = "no" ]; then
    : "${THEME_HOST_DIR:?THEME_HOST_DIR must be set when THEME_VIA_DOCKER_CP=no}"
    OWNER="$(stat -c '%u:%g' "$THEME_HOST_DIR")"
    log "Swapping theme on the host bind mount (previous copy -> $KEEP)"
    cp -a "$STAGE" "$THEME_HOST_DIR.new"
    chown -R "$OWNER" "$THEME_HOST_DIR.new"
    mv "$THEME_HOST_DIR" "$KEEP" && mv "$THEME_HOST_DIR.new" "$THEME_HOST_DIR"
else
    log "Copying theme into the container (previous copy -> $KEEP)"
    dc cp "$APP_SERVICE:$THEME_IN_CONTAINER" "$KEEP"
    dc cp "$STAGE" "$APP_SERVICE:$THEME_IN_CONTAINER.new"
    app sh -c "chown -R $WEB_USER: '$THEME_IN_CONTAINER.new' && rm -rf '$THEME_IN_CONTAINER.old' && mv '$THEME_IN_CONTAINER' '$THEME_IN_CONTAINER.old' && mv '$THEME_IN_CONTAINER.new' '$THEME_IN_CONTAINER' && rm -rf '$THEME_IN_CONTAINER.old'"
fi
echo "$KEEP" > "$BACKUP_ROOT/THEME_PREVIOUS"

log "Clearing compiled templates and data caches (same effect as Administration > Clear Template/Data Cache)"
app sh -c "cd '$OJS_ROOT' && find cache/t_compile -type f -delete 2>/dev/null; find cache/opcache cache/_db cache/t_cache -type f -delete 2>/dev/null; rm -f cache/fc-*.php cache/*-stylesheet-*.css cache/*-font-*.css; true"
rm -rf "$STAGE"
log "Theme $SHA deployed. Run 04-smoke-test.sh now; on failure run 05-rollback.sh."
