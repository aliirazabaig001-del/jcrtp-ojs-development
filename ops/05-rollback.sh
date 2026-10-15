#!/usr/bin/env bash
# Restore the theme that was live before the last 03-deploy-theme.sh run.
# Database and uploaded files are not touched by theme deployments, so they
# need no rollback. (Full database/file restore: see DEPLOYMENT.md section 8.)
. "$(dirname "$0")/lib.sh"
PREV="$(cat "$BACKUP_ROOT/THEME_PREVIOUS" 2>/dev/null || true)"
[ -n "$PREV" ] && [ -d "$PREV" ] || { echo "No previous theme copy recorded." >&2; exit 1; }
THEME_IN_CONTAINER="$OJS_ROOT/plugins/themes/editorialjournal"
if [ "$THEME_VIA_DOCKER_CP" = "no" ]; then
    : "${THEME_HOST_DIR:?}"
    # The failed copy goes to the backup area: any extra folder left inside
    # plugins/themes/ would break OJS plugin discovery.
    mv "$THEME_HOST_DIR" "$BACKUP_ROOT/theme-failed-$(date +%Y%m%d-%H%M%S)" && cp -a "$PREV" "$THEME_HOST_DIR"
else
    dc cp "$PREV" "$APP_SERVICE:$THEME_IN_CONTAINER.rollback"
    dc cp "$APP_SERVICE:$THEME_IN_CONTAINER" "$BACKUP_ROOT/theme-failed-$(date +%Y%m%d-%H%M%S)"
    app sh -c "chown -R $WEB_USER: '$THEME_IN_CONTAINER.rollback' && rm -rf '$THEME_IN_CONTAINER' && mv '$THEME_IN_CONTAINER.rollback' '$THEME_IN_CONTAINER'"
fi
app sh -c "cd '$OJS_ROOT' && find cache/t_compile cache/opcache cache/_db cache/t_cache -type f -delete 2>/dev/null; rm -f cache/fc-*.php cache/*-stylesheet-*.css; true"
log "Rolled back to $PREV. Re-run 04-smoke-test.sh."
