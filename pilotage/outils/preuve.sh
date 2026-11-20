#!/bin/bash
# usage : preuve.sh NNN depot numero_pr — prouve .claude/test-command sur le SHA exact de la PR
# Base de preuve à part : sommier_test_mpreuveNN, recréée à chaque preuve.
# A_BLANC=1 : affiche ce qui serait fait (ni gh, ni worktree, ni base, ni tests).
. "$(dirname "$0")/commun.sh"
n=$1; repo=$2; pr=$3; M=$CACHE/m$n; P=$M/preuve
controle_charge || exit $?
cd "$DEV/$repo" || exit 1
if [ -n "$A_BLANC" ]; then
  if depot_a_base "$repo"; then b=", base sommier_test_mpreuve$n"; else b=", sans base (dépôt hors DEPOTS_AVEC_BASE)"; fi
  echo "À BLANC : preuve de $repo#$pr dans $P (SHA lu par gh pr view)$b, puis bash .claude/test-command > $M/preuve.log"; exit 0
fi
sha=$(gh pr view "$pr" --json headRefOid -q .headRefOid)
git worktree remove -f -f "$P" 2>/dev/null; git fetch -q origin; git worktree add -q --detach "$P" "$sha" || exit 1
if depot_a_base "$repo" && charge_renviron; then
  export SOMMIER_TEST_DB=sommier_test_mpreuve$n
  sed "s/^SOMMIER_TEST_DB=.*/SOMMIER_TEST_DB=sommier_test_mpreuve$n/" ~/.Renviron > "$M/Renviron.preuve"; export R_ENVIRON_USER=$M/Renviron.preuve
  prepare_base "sommier_test_mpreuve$n" recree || exit 1
fi
cd "$P"; s=$(date +%s); bash .claude/test-command > "$M/preuve.log" 2>&1; c=$?
echo "$n $repo#$pr sha=$sha code=$c duree=$(( $(date +%s)-s ))s"
cd "$DEV/$repo" && git worktree remove -f -f "$P"
