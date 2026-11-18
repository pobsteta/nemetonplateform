# Mission 015 — test de contrat `nemeton` → `nemetonshiny`

> Ouverte sur le « oui vas-y » de Pascal du 2026-11-18 (série des tests de contrat, en
> commençant par les trois liens de code R partant de `nemeton`), pour le cycle 9.
> Dépôt : `nemetonshiny` (session ouverte dans le projet, ADR 0001). **La fusion revient à
> Pascal** : un test de contrat écrit un contrat entre projets (`docs/spec.md` § 5).

## Mission

**En une phrase (quoi, et pourquoi) :** Écrire dans `nemetonshiny` un test de contrat qui liste chaque objet de `nemeton` que `nemetonshiny` utilise (fonctions avec leurs arguments, constantes, colonnes des tables rendues quand le code en dépend) et échoue si l'un est renommé, retiré ou change d'arguments, pour qu'une release de `nemeton` qui casse `nemetonshiny` se voie dans sa CI et non chez l'utilisateur.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Le lien (`docs/carte.yaml` de nemetonplateforme)

- Par : Imports: nemeton (>= 2026.11.35), installé depuis la dernière release
- Source : nemetonshiny/DESCRIPTION:15

## Le modèle

`nemetonshiny/tests/testthat/test-contrat_nemetonmcp.R` (sur `origin/main` de nemetonshiny) :
une table des fonctions et de leurs `formals()`, une table des constantes (type, longueur
minimale), un en-tête qui dit « changer cette table = changer le contrat ».

## Ce qui est attendu

1. Le relevé, par lecture du code de `nemetonshiny` (`R/`, `NAMESPACE`, `inst/`) : chaque appel `nemeton::`, `getFromNamespace(…, "nemeton")`, `importFrom(nemeton, …)`, et ce que le code lit dans les objets rendus. Le relevé est fait dans le code, pas supposé.
2. `tests/testthat/test-contrat_nemeton.R` dans `nemetonshiny`, sur le modèle ; vert contre la dernière release de `nemeton` installée.
3. Le test **échoue** si on retire ou renomme un objet de la table : le prouver une fois (mutation locale, non commitée) et le noter dans la PR.
4. Une section « API lue dans nemeton » dans `CONTRAT.md` de nemetonshiny, sur le modèle de « 6 bis. API pour nemetonmcp », qui renvoie au test.
5. Si `nemeton` n'est pas installable dans la CI de `nemetonshiny`, le test ne doit pas sauter en silence en CI (`skip_on_ci` interdit ; `skip_if_not_installed` seulement si la CI installe bien `nemeton`, à vérifier dans le workflow).

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? | oui : le modèle existe | |
| A-t-il les moyens ? | oui : session `claude -p` ouverte dans `nemetonshiny`, budget 3 $ | |

**Temps de la main :** appuyer.

## L'Homme

- **Agent :** `testeur`, dans une session ouverte dans `nemetonshiny`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Ce qui ne lui est pas demandé :** modifier `nemeton` ; corriger le code de `nemetonshiny` (s'il trouve un appel déjà cassé, il le dit sans le corriger) ; fusionner.

## Dépend de / rouge attendu jusqu'à

Rien : le test doit être vert contre la release actuelle de `nemeton`.
