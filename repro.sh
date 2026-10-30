#!/usr/bin/env bash
# Usage: ./repro.sh [a|b|b+vue] ; extra vitest args via VITEST_ARGS
set -u
cd "$(dirname "$0")"
TARGET="${1:-b}"
restore_sources() { cp .orig/* src/; }
mkdir -p .orig; [ -f .orig/TwoStyles.vue ] || cp src/TwoStyles.vue src/a.css src/b.css .orig/
restore_sources
rm -rf node_modules/.vitest-cache

npx vitest run ${VITEST_ARGS:-} > run1.log 2>&1; R1=$?

case "$TARGET" in
  a) echo '.box { border: 1px solid green; }' >> src/a.css ;;
  b) echo '.box { border: 1px solid green; }' >> src/b.css ;;
  b+vue) echo '.box { border: 1px solid green; }' >> src/b.css; echo '<!-- touched -->' >> src/TwoStyles.vue ;;
esac
[ "${CLEAR_BETWEEN:-0}" = 1 ] && rm -rf node_modules/.vitest-cache

npx vitest run ${VITEST_ARGS:-} > run2.log 2>&1; R2=$?

echo "run1 exit=$R1  run2 exit=$R2"
grep -hE "SCOPE_ATTR|INJECTED_CSS" run1.log | sed 's/^/run1: /'
grep -hE "SCOPE_ATTR|INJECTED_CSS|TypeError|Plugin:|File:" run2.log | sed 's/^/run2: /'
restore_sources
