# Mission 003 — plugin et commande de tests dans `nemetonmcp`

> Mission qui prépare la délégation des fusions (spec § 5, ADR 0001) : sans commande de
> tests complète et versionnée, rien n'est vert, donc rien n'est délégué. Dépôt :
> `nemetonmcp`. Exécutée par une session ouverte dans ce dépôt (`claude -p -w`, ADR 0001).

## Mission

**En une phrase (quoi, et pourquoi) :** Activer le plugin `imperatrice` et versionner une `.claude/test-command` dans `nemetonmcp` qui lance ses deux suites de tests comme la CI (`npm test` et `testthat::test_local("r")`), pour que le vert d'une PR de `nemetonmcp` soit prouvable et sa fusion déléguable.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? (sources, conventions nommées ci-dessous) | oui : la CI du projet dit déjà comment il lance ses tests | |
| A-t-il les moyens ? (outils, données d'essai, tests) | oui : les tests existent, R et les paquets sont installés sur le PC | |

**Temps de la main :** appuyer — mission courte et sans enjeu de durée, mais première
mission confiée à ce dépôt depuis `nemetonplateforme`.

> `.claude/` existe dans le clone mais n'est pas versionné ; l'agent le lit avant
> d'écrire, et ne versionne rien de personnel (jetons, chemins propres au PC).

## Ma réponse d'abord

_Rempli par Pascal seul, avant de lire le travail de l'agent._

## L'Homme

- **Agent :** `testeur` (la mission pose l'outillage des tests, sans écrire de code produit).
- **Modèle :** sonnet.
- **Ce qui ne lui est pas demandé :** corriger un test rouge, augmenter la couverture,
  installer le reste de la méthode (`pilotage/`, brief).

## Harnais

- **Peut :** créer et versionner `.claude/settings.json` (plugin `imperatrice@pobsteta` et sa marketplace) en gardant les réglages déjà présents dans le `.claude/settings.json` non versionné s'ils sont propres au projet (sinon les laisser en `settings.local.json`) ; créer `.claude/test-command` ; ouvrir une PR.
- **Ne doit pas :** toucher à `main` ni à l'arbre de travail principal ; modifier du code
  ou des tests du projet (si un test échoue, le dire, ne pas le corriger) ; changer la
  version ; fusionner sa PR (l'orchestrateur fusionne, spec § 5) ; écrire hors du dépôt
  du projet.
- **Sources autorisées :** le `CLAUDE.md` du projet, ses workflows `.github/workflows/`,
  son dossier de tests, `docs/adr/0001-agir-dans-un-autre-depot.md` et `docs/spec.md` § 5
  de `nemetonplateforme`.

## Valeur provisoire (chiffre, réglage)

- **Valeur provisoire :** aucune durée connue pour `npm test && Rscript -e 'testthat::test_local("r", stop_on_failure = TRUE)'`. Le hook
  `tests_obligatoires` coupe à 630 s.
- **Mesurée par :** l'agent, en première tâche : durée réelle de la commande sur le PC.
- **Gel :** avant d'écrire la commande. Si elle dépasse 630 s, l'agent ne choisit pas
  seul un sous-ensemble : il rend la mesure, et Pascal tranche (la commande complète
  reste celle de la preuve du vert, ADR 0001).

## Dépend de / rouge attendu jusqu'à

- **Dépend de :** rien.
- **Ordre de fusion :** indépendante des missions 002 et 003.
- **PR en brouillon jusqu'à :** sans objet.
- **CI rouge attendue :** aucune.

## Tests

- **Comment saura-t-on que c'est juste :** code 0 sur `main` à jour ; code non nul si un
  test JS ou R est cassé exprès dans un worktree jetable ; les deux suites tournent.

## Terrain

- **Échantillon que Pascal vérifiera :** la commande et sa durée, dans la PR.

## Qui veille, qui tranche

- **Relecteur :** `relecteur`, puis l'orchestrateur, qui prouve le vert (ADR 0001) et
  fusionne par délégation de Pascal (spec § 5).
- **Critère d'arrêt de la relecture :** 3 allers-retours ; au-delà, la décision remonte à
  Pascal.
- **Point de suivi :** à la fin de la session du projet (sortie JSON), puis après la
  preuve du vert.
- **Budget de la session :** 3 $ au plus (`--max-budget-usd`, provisoire : les deux
  essais à blanc ont coûté 0,64 et 0,68 $).
- **Qui tranche :** Pascal (tout test rouge, tout choix de sous-ensemble de tests).

## Comment saura-t-on que ça marche ?

Une session `claude -p -w` lancée dans `nemetonmcp` après la fusion trouve
`.claude/test-command` dans son worktree, et le hook `tests_obligatoires` la lance à
l'arrêt.
