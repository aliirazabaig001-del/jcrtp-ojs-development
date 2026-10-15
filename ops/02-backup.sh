#!/usr/bin/env bash
# Full pre-deployment backup: database, uploaded files, theme, configuration,
# compose files, checksums, and an integrity check of every archive.
# Writes only under $BACKUP_ROOT. Never prints credentials.
. "$(dirname "$0")/lib.sh"

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="$BACKUP_ROOT/$STAMP"
umask 077
mkdir -p "$OUT"
log "Backup directory: $OUT"

log "1/6 Database ($DB_ENGINE)"
DB_NAME="$(ojs_db name)"; DB_USER="$(ojs_db username)"; DB_PASS="$(ojs_db password)"
[ -n "$DB_NAME" ] || { echo "Could not read database name from config.inc.php" >&2; exit 1; }
case "$DB_ENGINE" in
    mysql|mariadb)
        # The password travels over stdin, so it never appears in any process list.
        printf '%s\n' "$DB_PASS" | dbx sh -c '
            IFS= read -r P; export MYSQL_PWD="$P"
            D=mysqldump; command -v mariadb-dump >/dev/null 2>&1 && D=mariadb-dump
            exec "$D" --single-transaction --quick --routines --triggers --default-character-set=utf8mb4 -u "$1" "$2"
        ' sh "$DB_USER" "$DB_NAME" | gzip -9 > "$OUT/database.sql.gz" ;;
    postgres)
        printf '%s\n' "$DB_PASS" | dbx sh -c '
            IFS= read -r P; export PGPASSWORD="$P"
            exec pg_dump -U "$1" -d "$2" --no-owner --format=plain
        ' sh "$DB_USER" "$DB_NAME" | gzip -9 > "$OUT/database.sql.gz" ;;
    *) echo "Unknown DB_ENGINE=$DB_ENGINE" >&2; exit 1 ;;
esac
unset DB_PASS

log "2/6 Uploaded files ($OJS_FILES_DIR)"
app tar -C "$(dirname "$OJS_FILES_DIR")" -czf - "$(basename "$OJS_FILES_DIR")" > "$OUT/files_dir.tar.gz"

log "3/6 Public files, themes and plugins"
app tar -C "$OJS_ROOT" -czf - public plugins/themes > "$OUT/public_and_themes.tar.gz"

log "4/6 Configuration (kept private, mode 600)"
app cat "$OJS_ROOT/config.inc.php" > "$OUT/config.inc.php"
cp -a "$COMPOSE_DIR"/docker-compose*.yml "$OUT"/ 2>/dev/null || true
cp -a "$COMPOSE_DIR"/compose*.yml "$OUT"/ 2>/dev/null || true
[ -f "$COMPOSE_DIR/.env" ] && cp -a "$COMPOSE_DIR/.env" "$OUT/compose.env"
docker compose -f "$COMPOSE_DIR/docker-compose.yml" ps --format json > "$OUT/containers.json" 2>/dev/null || true

log "5/6 Integrity checks"
gzip -t "$OUT/database.sql.gz"
tar -tzf "$OUT/files_dir.tar.gz" > /dev/null
tar -tzf "$OUT/public_and_themes.tar.gz" > /dev/null
# zgrep (not "zcat | grep -q") so an early grep exit is not a pipefail error.
zgrep -qiE 'CREATE TABLE|COPY ' "$OUT/database.sql.gz" || { echo "Dump looks empty" >&2; exit 1; }
for t in journals submissions publications issues users; do
    zgrep -qiE "CREATE TABLE [\`\"]?(public\.)?$t[\`\"]? " "$OUT/database.sql.gz" || { echo "Table $t missing from dump" >&2; exit 1; }
done

log "6/6 Checksums"
(cd "$OUT" && sha256sum ./* > SHA256SUMS)
du -sh "$OUT"/*
log "Backup complete and verified: $OUT"
echo "$OUT" > "$BACKUP_ROOT/LATEST"
