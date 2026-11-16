# Mission 004 — commande de tests versionnée dans `nemetonshiny`

> Même nature que les missions 001 à 003 : sans commande de tests versionnée, rien n'est
> prouvé vert, donc rien n'est délégué. Dépôt : `nemetonshiny`. Exécutée par une session
> ouverte dans ce dépôt (`claude -p -w`, ADR 0001). Validée par l'orchestrateur par
> délégation de Pascal (`pilotage/equipe.md`, élargie le 2026-11-16).

## Mission

**En une phrase (quoi, et pourquoi) :** Versionner dans `nemetonshiny` sa `.claude/test-command` (aujourd'hui ignorée par la ligne `.claude/` de `.gitignore`), en niveau rapide sous 600 s si la suite complète dépasse ce temps, pour que le vert d'une PR de `nemetonshiny` soit prouvable et sa fusion déléguable.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? | oui : missions 001 et 002 (`nemeton` #667, `foretaccess` #166) en modèles, la CI (`r.yml`, job `tests`, `testthat::test_local`) | |
| A-t-il les moyens ? | oui : 189 fichiers de tests, R et paquets sur le PC | |

**Temps de la main :** appuyer.

## Ma réponse d'abord

_Rempli par Pascal seul, avant de lire le travail de l'agent._ (Pascal a délégué : sans objet pour ce cycle.)

## L'Homme

- **Agent :** `testeur`. **Modèle :** sonnet (`--model sonnet`).
- **Ce qui ne lui est pas demandé :** corriger un test rouge, augmenter la couverture,
  toucher au `pilotage/` de `nemetonshiny`.

## Harnais

- **Peut :** modifier `.gitignore` pour ne plus ignorer `.claude/test-command` (la plus
  petite règle qui tient, par exemple `.claude/*` puis `!.claude/settings.json` et
  `!.claude/test-command`, en vérifiant que `.claude/settings.json`, déjà versionné, et les
  réglages locaux restent comme avant) ; réécrire `.claude/test-command` ; ouvrir une PR
  (conventions du `CLAUDE.md` du projet).
- **Ne doit pas :** toucher à `main`, ni au clone principal (Pascal y travaille sur la
  branche `claude/cycle-2026.11q`) : partir de `origin/main` à jour ; modifier du code,
  des tests ou la CI ; changer la version ; fusionner sa PR ; versionner
  `.claude/settings.local.json` ou tout autre fichier de `.claude/`.
- **Sources autorisées :** le `CLAUDE.md` du projet, `.github/workflows/`, `tests/`,
  `docs/adr/0001-agir-dans-un-autre-depot.md` (amendement du 2026-11-16) et
  `pilotage/missions/001-nemeton-commande-de-tests.md` de `nemetonplateforme`.

## Valeur provisoire (chiffre, réglage)

- **Valeur provisoire :** la commande locale actuelle ne lance que les tests MCP et le
  contrat `nemetonmcp`, durée inconnue ; durée de la suite complète inconnue.
- **Mesurée par :** l'agent, en première tâche (suite complète, bornée à 1800 s).
- **Règle (décision de Pascal du 2026-11-16, deux niveaux) :** si la suite complète tient
  sous 600 s, la commande la lance en entier. Sinon, `.claude/test-command` est un niveau
  rapide de moins de 600 s, dont la première ligne est le commentaire « niveau rapide ;
  suite complète en CI (ADR 0001 de nemetonplateforme, amendement du 2026-11-16) » ; il
  garde les tests de contrat (`contrat_nemetonmcp`) et choisit un filtre lisible ; la
  session vérifie que la CI lance toute la suite sur chaque PR.

## Dépend de / rouge attendu jusqu'à

- **Dépend de :** rien. **CI rouge attendue :** aucune.

## Tests

- La commande sort en code 0 sur `origin/main` à jour, et en code non nul avec un test
  cassé exprès dans un worktree jetable (puis on le jette).

## Terrain

- **Échantillon :** la commande, sa durée, les fichiers retenus et écartés, dans la PR.

## Qui veille, qui tranche

- **Relecteur :** `relecteur`, puis l'orchestrateur (preuve du vert, ADR 0001) qui fusionne
  par délégation.
- **Budget de la session :** 3 $ (`--max-budget-usd`).
- **Qui tranche :** l'orchestrateur par délégation ; une question de sens remonte à Pascal
  au bilan.

## Comment saura-t-on que ça marche ?

Une session `claude -p -w` lancée dans `nemetonshiny` après la fusion trouve
`.claude/test-command` dans son worktree, et le hook la lance à l'arrêt.
