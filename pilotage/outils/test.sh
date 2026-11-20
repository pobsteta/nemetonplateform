#!/bin/bash
# Essai des outils : bash -n puis essai à blanc de chacun (n'appelle ni claude, ni gh, ni docker).
# Tout se passe dans un dossier temporaire ; ne touche pas à ~/.cache/nemetonplateforme.
O=$(cd "$(dirname "$0")" && pwd); T=$(mktemp -d); trap 'rm -rf "$T"' EXIT; rc=0
ok(){ echo "ok    $1"; }; ko(){ echo "ECHEC $1"; rc=1; }
for s in commun lance relance preuve resultat test; do bash -n "$O/$s.sh" && ok "bash -n $s.sh" || ko "bash -n $s.sh"; done
grep -v '^#' "$O/renviron.exemple" | grep -q '=' && ko "renviron.exemple ne doit lister que des noms" || ok "renviron.exemple : noms seulement"
mkdir -p "$T/dev/projet/.claude/worktrees/mission-999" "$T/cache/m999"
printf '{"type":"result","subtype":"success","total_cost_usd":1,"session_id":"s1","structured_output":{"a":1}}\n' > "$T/cache/m999/flux.jsonl"
echo "some avg10=1.00 avg60=10.00 avg300=1.00 total=1" > "$T/bas"
echo "some avg10=90.00 avg60=77.00 avg300=1.00 total=1" > "$T/haut"
echo "# message" > "$T/msg.md"
export NEMETON_CACHE=$T/cache NEMETON_DEV=$T/dev NEMETON_RENVIRON=$T/absent A_BLANC=1 PRESSURE_IO_FICHIER=$T/bas
bash "$O/lance.sh" 999 projet x.md 2>&1 | grep -q "claude -p" && ok "lance.sh à blanc" || ko "lance.sh à blanc"
bash "$O/preuve.sh" 999 projet 1 2>&1 | grep -q "À BLANC" && ok "preuve.sh à blanc" || ko "preuve.sh à blanc"
bash "$O/relance.sh" 999 projet 2 "$T/msg.md" 2>&1 | grep -q "resume" && ok "relance.sh à blanc" || ko "relance.sh à blanc"
unset A_BLANC
bash "$O/resultat.sh" 999 2>&1 | grep -q "coût 1" && ok "resultat.sh" || ko "resultat.sh"
export A_BLANC=1
for s in lance preuve relance; do
  PRESSURE_IO_FICHIER=$T/haut bash "$O/$s.sh" 999 projet 1 "$T/msg.md" >"$T/sortie" 2>&1; c=$?
  { [ $c = 3 ] && grep -q ARRÊT "$T/sortie"; } && ok "$s.sh s'arrête sous charge (code 3)" || ko "$s.sh sous charge (code $c)"
  SEUIL_CHARGE_IO=90 PRESSURE_IO_FICHIER=$T/haut bash "$O/$s.sh" 999 projet 1 "$T/msg.md" 2>&1 | grep -q ARRÊT && ko "$s.sh : seuil réglable" || ok "$s.sh : seuil réglable"
done
# Base de test : seulement pour les dépôts de DEPOTS_AVEC_BASE (défaut sommieR).
printf 'SOMMIER_TEST_DB=x\n' > "$T/renv"; mkdir -p "$T/dev/sommieR"
b(){ env -u SOMMIER_TEST_DB NEMETON_RENVIRON=$T/renv "$@" 2>&1; }
b bash "$O/lance.sh" 999 projet x.md | grep -q "SOMMIER_TEST_DB=sommier\|base sommier" && ko "lance.sh : dépôt sans base ne doit pas annoncer de base" || ok "lance.sh : dépôt sans base, pas de base annoncée"
b bash "$O/lance.sh" 999 sommieR x.md | grep -q "SOMMIER_TEST_DB=sommier_test_m999" && ok "lance.sh : sommieR, SOMMIER_TEST_DB annoncée" || ko "lance.sh : sommieR sans base"
b bash "$O/lance.sh" 999 sommieR x.md | grep -q "base sommier_test_m999 créée si elle manque" && ok "lance.sh : sommieR, création de la base dite à blanc" || ko "lance.sh : création non annoncée"
b bash "$O/preuve.sh" 999 projet 1 | grep -q "sans base" && ! b bash "$O/preuve.sh" 999 projet 1 | grep -q mpreuve && ok "preuve.sh : dépôt sans base, pas de base de preuve" || ko "preuve.sh : dépôt sans base"
b bash "$O/preuve.sh" 999 sommieR 1 | grep -q "base sommier_test_mpreuve999" && ok "preuve.sh : sommieR, base de preuve annoncée" || ko "preuve.sh : sommieR sans base de preuve"
b env DEPOTS_AVEC_BASE="projet autre" bash "$O/lance.sh" 999 projet x.md | grep -q "SOMMIER_TEST_DB=sommier_test_m999" && ok "DEPOTS_AVEC_BASE : liste réglable (projet ajouté)" || ko "DEPOTS_AVEC_BASE : projet ajouté"
b env DEPOTS_AVEC_BASE="projet autre" bash "$O/lance.sh" 999 sommieR x.md | grep -q "SOMMIER_TEST_DB=sommier" && ko "DEPOTS_AVEC_BASE : sommieR retiré de la liste" || ok "DEPOTS_AVEC_BASE : sommieR retiré, plus de base"
b env DEPOTS_AVEC_BASE= bash "$O/lance.sh" 999 sommieR x.md | grep -q "SOMMIER_TEST_DB=sommier" && ko "DEPOTS_AVEC_BASE vide : aucune base" || ok "DEPOTS_AVEC_BASE vide : aucune base"
# Cas dégradés : jamais de blocage, un avertissement.
echo "" > "$T/vide"; echo "full avg60=99.00" > "$T/sanssome"; echo "some avg60=abc" > "$T/nan"
cas(){ # nom, fichier, VAR=val
  local nom=$1 fic=$2; shift 2
  env "$@" PRESSURE_IO_FICHIER=$fic bash "$O/lance.sh" 999 projet x.md >"$T/sortie" 2>&1; c=$?
  { [ $c = 0 ] && grep -q "contrôle de charge" "$T/sortie"; } && ok "charge : $nom (pas de blocage, avertissement)" || ko "charge : $nom (code $c)"
}
cas "fichier absent" "$T/nexiste-pas" X=1
cas "fichier vide" "$T/vide" X=1
cas "sans ligne some" "$T/sanssome" X=1
cas "valeur non numérique" "$T/nan" X=1
cas "fenêtre inconnue" "$T/haut" FENETRE_CHARGE_IO=avg7
cas "seuil non numérique" "$T/bas" SEUIL_CHARGE_IO=beaucoup
SEUIL_CHARGE_IO=beaucoup PRESSURE_IO_FICHIER=$T/haut bash "$O/lance.sh" 999 projet x.md >"$T/sortie" 2>&1; [ $? = 3 ] && ok "seuil non numérique : défaut 60 appliqué (77 % arrête)" || ko "seuil non numérique : défaut"
[ "$(ls "$T/cache/m999")" = "flux.jsonl" ] && ok "essai à blanc sans trace" || ko "l'essai à blanc a écrit des traces"
exit $rc
