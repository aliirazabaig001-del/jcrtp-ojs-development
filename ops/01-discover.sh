#!/usr/bin/env bash
# READ-ONLY production discovery. Changes nothing. Safe to run any time.
# Usage: ./01-discover.sh [compose-dir]   (before jcrtp.env exists)
set -uo pipefail
DIR="${1:-${COMPOSE_DIR:-/docker/jcrtp}}"
echo "== Host";        uname -a; uptime; free -h; df -h /
echo "== Docker";      docker --version; docker compose version
echo "== Compose projects"; docker compose ls
echo "== Compose file in $DIR"; ls -la "$DIR"; (cd "$DIR" && docker compose config --services && docker compose ps)
echo "== Containers (health)"; docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
echo "== Mounts per container"
for c in $(cd "$DIR" && docker compose ps -q); do
    echo "-- $(docker inspect -f '{{.Name}}' "$c")"
    docker inspect -f '{{range .Mounts}}{{.Type}}  {{.Source}} -> {{.Destination}}{{"\n"}}{{end}}' "$c"
done
echo "== Next: inside the app container, run (replace SERVICE):"
cat <<'CMDS'
  docker compose exec SERVICE sh -c 'cd /var/www/html 2>/dev/null || pwd; ls; grep -m1 "<release>" dbscripts/xml/version.xml; php -v | head -1; php -m'
  docker compose exec SERVICE sh -c 'grep -nE "^(installed|base_url|driver|host|name|files_dir|restful_urls)" config.inc.php'   # shows NO passwords
  docker compose exec SERVICE sh -c 'ls -la plugins/themes/'
  docker compose exec SERVICE sh -c 'ls -ld cache cache/* | head; id'
  docker compose exec DBSERVICE sh -c 'mysql --version 2>/dev/null || mariadb --version 2>/dev/null || psql --version'
CMDS
echo "== TLS certificate"
echo | openssl s_client -servername jcrtp.com -connect jcrtp.com:443 2>/dev/null | openssl x509 -noout -subject -issuer -dates
echo "== DNS"; (command -v dig >/dev/null && dig +short jcrtp.com A jcrtp.com AAAA) || getent hosts jcrtp.com
echo "== Web server"; curl -sI https://jcrtp.com | grep -iE '^(server|x-powered-by|strict-transport-security):'
