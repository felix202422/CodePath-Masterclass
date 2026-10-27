#!/usr/bin/env bash
# verify.sh — rebuild the shop schema from the shipped scripts and diff every
# query's output against expected/.
#
# Connection is controlled the way psql already works — environment variables:
#   PGHOST (default 127.0.0.1)  PGPORT (default 5432)  PGUSER (your role)
# The role must be allowed to CREATE DATABASE. The scratch database
# ${VERIFY_DB:-shop_verify} is created and dropped by this script.
#
# Exit status: 0 when every query matches its expected output, 1 otherwise.

set -euo pipefail
cd "$(dirname "$0")"

DB="${VERIFY_DB:-shop_verify}"
PSQL=(psql -X -v ON_ERROR_STOP=1)

echo "== building $DB from scripts/01-schema.sql + 02-seed.sql"
"${PSQL[@]}" -d postgres -c "drop database if exists $DB" >/dev/null
"${PSQL[@]}" -d postgres -c "create database $DB" >/dev/null
trap '"${PSQL[@]}" -d postgres -c "drop database if exists '"$DB"'" >/dev/null 2>&1 || true' EXIT

"${PSQL[@]}" -d "$DB" -f scripts/01-schema.sql >/dev/null
"${PSQL[@]}" -d "$DB" -f scripts/02-seed.sql >/dev/null

tmp="$(mktemp -d)"
pass=0
fail=0
for q in scripts/queries/q*.sql; do
  name="$(basename "$q" .sql)"
  # Windows psql writes CRLF; expected/ files are LF (sed strips the CR either way)
  "${PSQL[@]}" -d "$DB" -f "$q" | sed 's/\r$//' >"$tmp/$name.txt"
  if diff -u "expected/$name.txt" "$tmp/$name.txt" >"$tmp/$name.diff"; then
    echo "PASS  $name"
    pass=$((pass + 1))
  else
    echo "FAIL  $name"
    sed 's/^/      /' "$tmp/$name.diff"
    fail=$((fail + 1))
  fi
done

echo "---- $pass passed, $fail failed"
[ "$fail" -eq 0 ]
