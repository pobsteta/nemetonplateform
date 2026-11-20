#!/bin/bash
# usage : relance.sh NNN depot k fichier_message — reprend la session de la mission NNN (flux{k}.jsonl)
# Le coût d'une reprise est cumulé (ADR 0001, « Les outils d'exécution »).
# A_BLANC=1 : affiche la commande `claude -p --resume` sans la lancer.
. "$(dirname "$0")/commun.sh"
n=$1; repo=$2; k=$3; msg=$4; M=$CACHE/m$n
controle_charge || exit $?
sid=$(grep -ho '"session_id":"[^"]*"' "$M"/flux*.jsonl | tail -1 | cut -d'"' -f4)
cd "$DEV/$repo/.claude/worktrees/mission-$n" || exit 1
if charge_renviron; then export SOMMIER_TEST_DB=sommier_test_m$n; export R_ENVIRON_USER=$M/Renviron; fi
CMD=(timeout 7200 claude -p "$(cat "$msg")" --resume "$sid" --model sonnet --settings '{"enabledPlugins":{"imperatrice@pobsteta":true}}' --permission-mode auto --permission-prompts none --disallowedTools "Bash(gh pr merge *)" --max-budget-usd 3 --output-format stream-json --verbose --json-schema "$(cat "$OUTILS/schema.json")")
if [ -n "$A_BLANC" ]; then echo "À BLANC, dans $PWD (session $sid) :"; printf '%q ' "${CMD[@]}" | cut -c1-400; echo; exit 0; fi
nohup "${CMD[@]}" > "$M/flux$k.jsonl" 2> "$M/err$k.log" < /dev/null &
echo $! > "$M/pid$k"; echo "relancée $n ($sid) pid $(cat "$M/pid$k")"
