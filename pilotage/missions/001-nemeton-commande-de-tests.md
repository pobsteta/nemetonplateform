# Mission 001 — commande de tests versionnée dans `nemeton`

> Mission qui prépare la délégation des fusions (spec § 5, ADR 0001) : sans commande de
> tests complète et versionnée, rien n'est vert, donc rien n'est délégué. Dépôt :
> `nemeton`. Exécutée par une session ouverte dans ce dépôt (`claude -p -w`, ADR 0001).

## Mission

**En une phrase (quoi, et pourquoi) :** Écrire et versionner dans `nemeton` une `.claude/test-command` qui lance toute sa suite `testthat` comme la CI (`.github/workflows/r.yml`), pour que le vert d'une PR de `nemeton` soit prouvable et sa fusion déléguable.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? (sources, conventions nommées ci-dessous) | oui : la CI du projet dit déjà comment il lance ses tests | |
| A-t-il les moyens ? (outils, données d'essai, tests) | oui : les tests existent, R et les paquets sont installés sur le PC | |

**Temps de la main :** appuyer — mission courte et sans enjeu de durée, mais première
mission confiée à ce dépôt depuis `nemetonplateforme`.

## Ma réponse d'abord

_Rempli par Pascal seul, avant de lire le travail de l'agent._

## L'Homme

- **Agent :** `testeur` (la mission pose l'outillage des tests, sans écrire de code produit).
- **Modèle :** sonnet.
- **Ce qui ne lui est pas demandé :** corriger un test rouge, augmenter la couverture,
  installer le reste de la méthode (`pilotage/`, brief).

## Harnais

- **Peut :** créer `.claude/test-command` (une ligne) et l'ajouter à git ; le plugin est déjà activé par le `.claude/settings.json` versionné ; ouvrir une PR (Conventional Commits, voir le `CLAUDE.md` du projet).
- **Ne doit pas :** toucher à `main` ni à l'arbre de travail principal ; modifier du code
  ou des tests du projet (si un test échoue, le dire, ne pas le corriger) ; changer la
  version ; fusionner sa PR (l'orchestrateur fusionne, spec § 5) ; écrire hors du dépôt
  du projet.
- **Sources autorisées :** le `CLAUDE.md` du projet, ses workflows `.github/workflows/`,
  son dossier de tests, `docs/adr/0001-agir-dans-un-autre-depot.md` et `docs/spec.md` § 5
  de `nemetonplateforme`.

## Valeur provisoire (chiffre, réglage)

- **Valeur provisoire :** aucune durée connue pour `Rscript -e 'devtools::test(stop_on_failure = TRUE)'`. Le hook
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

- **Comment saura-t-on que c'est juste :** la commande sort en code 0 sur `main` à jour, et
  en code non nul si l'on casse volontairement un test dans un worktree jetable (puis on
  jette) ; elle lance le même ensemble de tests que la CI.

## Terrain

- **Échantillon que Pascal vérifiera :** la ligne de `.claude/test-command` et la durée
  mesurée, dans la PR.

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

Une session `claude -p -w` lancée dans `nemeton` après la fusion trouve
`.claude/test-command` dans son worktree, et le hook `tests_obligatoires` la lance à
l'arrêt.
