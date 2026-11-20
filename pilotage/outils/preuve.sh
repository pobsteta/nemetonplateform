#!/bin/bash
# usage : preuve.sh NNN depot numero_pr — prouve .claude/test-command sur le SHA exact de la PR
# Base de preuve à part : sommier_test_mpreuveNN, recréée à chaque preuve.
# A_BLANC=1 : affiche ce qui serait fait (ni gh, ni worktree, ni base, ni tests).
. "$(dirname "$0")/commun.sh"
n=$1; repo=$2; pr=$3; M=$CACHE/m$n; P=$M/preuve
controle_charge || exit $?
cd "$DEV/$repo" || exit 1
if [ -n "$A_BLANC" ]; then
  echo "À BLANC : preuve de $repo#$pr dans $P (SHA lu par gh pr view), base sommier_test_mpreuve$n, puis bash .claude/test-command > $M/preuve.log"; exit 0
fi
sha=$(gh pr view "$pr" --json headRefOid -q .headRefOid)
git worktree remove -f -f "$P" 2>/dev/null; git fetch -q origin; git worktree add -q --detach "$P" "$sha" || exit 1
if charge_renviron; then
  export SOMMIER_TEST_DB=sommier_test_mpreuve$n
  sed "s/^SOMMIER_TEST_DB=.*/SOMMIER_TEST_DB=sommier_test_mpreuve$n/" ~/.Renviron > "$M/Renviron.preuve"; export R_ENVIRON_USER=$M/Renviron.preuve
  for q in "DROP DATABASE IF EXISTS sommier_test_mpreuve$n WITH (FORCE)" "CREATE DATABASE sommier_test_mpreuve$n"; do
    docker exec -e PGPASSWORD="$SOMMIER_TEST_PASSWORD" "$CONTENEUR" psql -U "$SOMMIER_TEST_USER" -d postgres -qc "$q"; done
  docker exec -e PGPASSWORD="$SOMMIER_TEST_PASSWORD" "$CONTENEUR" psql -U "$SOMMIER_TEST_USER" -d sommier_test_mpreuve$n -qc "CREATE EXTENSION postgis; CREATE EXTENSION pgcrypto"
fi
cd "$P"; s=$(date +%s); bash .claude/test-command > "$M/preuve.log" 2>&1; c=$?
echo "$n $repo#$pr sha=$sha code=$c duree=$(( $(date +%s)-s ))s"
cd "$DEV/$repo" && git worktree remove -f -f "$P"
