#!/bin/bash
# usage : lance.sh NNN depot fiche.md  — session de mission (ADR 0001), agent dev
# A_BLANC=1 : affiche la commande `claude -p` sans la lancer.
. "$(dirname "$0")/commun.sh"
n=$1; repo=$2; fiche=$3; M=$CACHE/m$n
controle_charge || exit $?
if [ -z "$A_BLANC" ]; then mkdir -p "$M"; cp "$OUTILS/schema.json" "$M/"; cp "$DEPOT/pilotage/missions/$fiche" "$M/fiche.md"; fi
read -r -d '' CONSIGNE <<EOC
Tu es l'agent \`dev\` de la mission $n, confiée par l'orchestrateur de nemetonplateforme (méthode de l'Impératrice, plugin imperatrice). Lis d'abord la fiche : $M/fiche.md, puis chaque brief qu'elle cite, en entier. Lis le CLAUDE.md de ce dépôt et son pilotage/ s'il existe, et respecte-les (langue, conventions, version, NEWS/CHANGELOG).

Règles :
- Commence par redire la mission en une phrase (champ \`redite\`). Si tu n'y arrives pas, arrête-toi.
- \`git fetch origin\` puis crée la branche \`mission/$n\` depuis \`origin/main\` (jamais depuis la branche courante du clone).
- Délégation de Pascal du 2026-11-18 : ne lui pose pas de question de détail ; tranche par la valeur la plus prudente et la plus réversible, et note chaque choix au journal du projet (ajout seul, s'il en a un) et dans la PR. Seules une rupture de contrat public ou une action extérieure sans retour justifient \`question_pour_pascal\` ; sinon laisse ce champ vide.
- Pas de code sans tests. Lance \`.claude/test-command\` avant de dire terminé ; note sha, commande, code de sortie, durée dans \`tests\`.
- Pousse, ouvre une PR vers main (français ; corps : ce qui est fait pour chaque demande du brief, les choix tranchés, terminé par « 🤖 Generated with [Claude Code](https://claude.com/claude-code) »), puis attends la CI (\`gh pr checks --watch\`) et corrige jusqu'au vert. Ne fusionne jamais.
- Ne touche à aucun autre dépôt (sauf la boîte ~/dev/briefs/vers-<projet>/ si la fiche demande d'y écrire une réponse).
- Commits terminés par : Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>
Rends le résultat selon le schéma JSON fourni.
EOC
[ -z "$A_BLANC" ] && printf '%s\n' "$CONSIGNE" > "$M/consigne.txt"
cd "$DEV/$repo" || exit 1
if charge_renviron; then
  export SOMMIER_TEST_DB=sommier_test_m$n
  if [ -z "$A_BLANC" ]; then sed "s/^SOMMIER_TEST_DB=.*/SOMMIER_TEST_DB=sommier_test_m$n/" ~/.Renviron > "$M/Renviron"; fi
  export R_ENVIRON_USER=$M/Renviron
fi
CMD=(timeout 7200 claude -p "$CONSIGNE" -w mission-$n --model sonnet --settings '{"enabledPlugins":{"imperatrice@pobsteta":true}}' --permission-mode auto --permission-prompts none --disallowedTools "Bash(gh pr merge *)" --max-budget-usd 3 --output-format stream-json --verbose --json-schema "$(cat "$OUTILS/schema.json")")
if [ -n "$A_BLANC" ]; then echo "À BLANC, dans $PWD (SOMMIER_TEST_DB=${SOMMIER_TEST_DB:-}) :"; printf '%q ' "${CMD[@]}" | cut -c1-400; echo; exit 0; fi
nohup "${CMD[@]}" > "$M/flux.jsonl" 2> "$M/err.log" < /dev/null &
echo $! > "$M/pid"; echo "lancée $n pid $(cat "$M/pid")"
