# ADR 0001 — agir dans un autre dépôt : une session ouverte dans le dépôt du projet

- **Date :** 2026-11-16
- **Statut :** proposée
- **Proposée par :** Claude (orchestrateur)
- **Tranchée par :** Pascal

## La décision en une phrase

Pour faire avancer une mission dans un projet, l'orchestrateur ne l'exécute pas depuis
ce dépôt : il lance **une session Claude Code ouverte dans le dépôt du projet**
(`claude -p`, sans interface, en arrière-plan), qui y trouve le `CLAUDE.md`, les hooks,
la commande de tests et les worktrees de ce projet ; et il ne lance cette session que
dans un projet qui a le plugin activé et une `.claude/test-command` qui couvre ses tests.

## Contexte

La spec validée (§ 5) délègue à l'orchestrateur les fusions et les releases « quand tout
est vert ». Le vert repose sur les tests du projet. Or, lu dans le plugin `imperatrice`
0.7.0 :

- `hooks/tests_obligatoires.py` lit `.claude/test-command` à la racine de
  `CLAUDE_PROJECT_DIR`, c'est-à-dire du dépôt où la session est ouverte. Ouverte ici, la
  session n'en a pas : le hook ne fait rien, et un agent peut dire « terminé » dans
  `nemeton` sans un seul test lancé.
- `/boucle` lance les agents qui écrivent avec `isolation: "worktree"` : le worktree naît
  dans le dépôt de la session (ici), pas dans celui du projet.
- `hooks/garde_main.py` suit `cd` et `git -C` : il protège `main` dans un autre dépôt
  **si** la commande le nomme ainsi. `journal_ajout_seul.py` reconnaît tout chemin qui
  finit par `pilotage/journal.md`. `journal_intact.py` contrôle le journal du dépôt du
  dossier courant à l'arrêt de l'agent. Ces trois-là tiennent à peu près ; c'est le
  hook de tests qui manque, et c'est lui qui fait le vert.
- Les hooks d'un projet ne s'appliquent que si le plugin y est activé.

Inventaire du 2026-11-16 (`.claude/settings*.json` et `.claude/test-command` des clones
locaux) :

| Projet | Plugin activé | `.claude/test-command` |
|---|---|---|
| `nemeton` | oui | **non** |
| `foretaccess` | non | **non** |
| `nemetonshiny` | oui | oui, mais **filtrée** (`devtools::test(filter = "mcp_…")`) : une partie des tests seulement |
| `nemetonmcp` | non | **non** |
| `victor` | non | **non** |
| `aigora`, `aigora-nemeton` | non | **non** |
| `terrain`, `marculus`, `surculus`, `ramulus`, `groma` | oui | oui (Gradle) |
| `sylvostation` | non lu (pas de clone) | non lu |

### Les options envisagées

1. **Une session ouverte dans le dépôt du projet** (retenue). L'orchestrateur lance
   `cd ~/dev/<projet> && claude -p "<consigne>" --output-format json` en arrière-plan.
   La consigne renvoie au brief déposé dans `~/dev/briefs/vers-<projet>/` (spec § 4).
   Cette session est une session complète : elle charge le `CLAUDE.md` du projet, ses
   hooks, sa commande de tests, et ses propres agents travaillent dans des worktrees de
   **ce** dépôt. Elle ouvre la PR, et fusionne aux conditions de la spec § 5.
   L'orchestrateur lit son résultat (JSON) et le journal du projet.
2. **Corriger le plugin** : faire lire au hook la `.claude/test-command` du dépôt du
   dossier courant, et faire créer les worktrees à la main dans le dépôt cible. Il faut
   changer `methode-imperatrice` (un autre dépôt, tous ses utilisateurs), et l'isolation
   `worktree` de l'outil Agent reste attachée au dépôt de la session : la moitié du
   problème seulement.
3. **`--add-dir`** : ouvrir ici en ajoutant les dossiers des projets. Donne l'accès aux
   fichiers, pas les hooks ni la commande de tests du projet : ne règle rien.
4. **Pascal ouvre lui-même une session par projet** (ce qu'il fait aujourd'hui) : sûr,
   mais c'est exactement ce que le brief veut lui épargner.
5. **Monorepo ou sous-modules git** : écarté par la spec § 9.
6. **Option étrange : GitHub Actions** (une action Claude Code par dépôt, déclenchée par
   une issue que l'orchestrateur ouvre). Les tests tournent en CI, isolés du PC de
   Pascal ; mais il faut des secrets dans treize dépôts, `aigora-nemeton` n'a pas de
   GitHub, et les tests Android ou R lourds (SDK, données locales) ne tournent pas
   tous en CI. Gardée en réserve.

### Les règles qui accompagnent l'option 1

- **Pas de session sans vert possible.** Un projet sans plugin activé ou sans
  `.claude/test-command` ne reçoit qu'une mission : installer la méthode et écrire sa
  commande de tests (`/imperatrice:demarrer`), avec l'accord de Pascal (`CLAUDE.md`).
  Pour `nemetonshiny`, la commande filtrée ne suffit pas au vert délégué : soit elle
  couvre tous les tests, soit la fusion revient à Pascal.
- **Une session à la fois par dépôt**, lancée en arrière-plan, jamais dans l'arbre de
  travail principal si Pascal y travaille : la session travaille dans un worktree du
  projet (le verrou de `tests_obligatoires` évite déjà deux lancements de tests
  simultanés).
- **Permissions** : la session est lancée en mode `auto` ou avec une liste d'outils
  permis, jamais en contournant les permissions ; les règles `deny` du projet
  s'appliquent (celles d'`aigora-nemeton` interdisent d'écrire dans les dépôts Néméton).
- **Ce qui ne délègue pas** : la session d'un projet ne tranche aucune question de sens,
  de périmètre ou de contrat ; elle la rend à l'orchestrateur, qui la pose à Pascal.
- **Trace** : chaque session lancée est inscrite au journal d'ici (projet, brief,
  résultat), et la session inscrit sa mission au journal de son projet.

## Le crible FRANCE

| Lettre | Question | Réponse (une ligne) | Ce que ça coûte | Prêts à payer ? |
|---|---|---|---|---|
| **F**rugale | La plus simple qui tienne ? | Oui : rien à changer dans le plugin, chaque projet garde ses garde-fous tels qu'ils sont | Un processus Claude Code de plus par mission | Oui |
| **R**esponsable | Qui fait quoi ? | L'orchestrateur prépare et lance ; la session du projet exécute sous les règles du projet ; Pascal tranche le sens et les contrats | L'orchestrateur ne voit que le résultat, pas chaque geste | Oui, le journal du projet garde le détail |
| **A**nticiper | Et si l'imprévu arrive ? | Une session qui échoue ou dépasse son temps est dite en quatre temps ; sans tests, pas de session ; GitHub absent, arrêt avant « Agir » (spec § 7) | Des cycles plus lents tant que les commandes de tests manquent | Oui |
| **N**ovateur | Toutes les idées écoutées ? | Six options, dont la CI GitHub et le monorepo | Rien | Oui |
| **C**oût | Que coûte-t-elle à l'ensemble ? | Une session complète par mission, en jetons et en temps machine ; des sessions en parallèle sur le PC de Pascal | Plus de jetons que des sous-agents d'ici ; charge du PC (Gradle et R en même temps) | Oui, en limitant à une session par dépôt et au plafond global |
| **É**cologique | Que réutilise-t-on ? | Les hooks, worktrees et commandes de tests déjà en place dans chaque projet, et la boîte `~/dev/briefs/` | Rien de neuf à maintenir | Oui |

## Valeurs sacrifiées

- **La vue fine de l'orchestrateur** : il ne suit pas la session du projet geste par
  geste, il lit son résultat et son journal. Accepté : c'est la règle « chaque projet
  reste chez lui ».
- **La vitesse au départ** : sept projets sur treize n'ont pas de commande de tests
  complète. Tant qu'elle manque, rien n'y est délégué, et les premières missions sont
  des installations de la méthode. Accepté : un vert sans tests serait un faux vert.

## Sources

- `hooks/tests_obligatoires.py`, `hooks/garde_main.py`, `hooks/journal_ajout_seul.py`,
  `hooks/journal_intact.py`, `hooks/hooks.json` et `skills/boucle/SKILL.md` du plugin
  `imperatrice` 0.7.0 (`~/.claude/plugins/cache/pobsteta/imperatrice/0.7.0/`).
- `claude --help` (Claude Code 2.1.325) : `-p/--print`, `--output-format`,
  `--permission-mode`, `--allowedTools`, `--add-dir`.
- Inventaire des `.claude/settings*.json` et `.claude/test-command` des clones locaux,
  2026-11-16.
- `docs/spec.md` § 4, 5, 7 et 9 ; `docs/brief.md`, « Préalables bloquants ».
- `~/dev/briefs/README.md`.

## Question de contrôle

Cette décision tient-elle nos six valeurs, et que sommes-nous prêts à payer pour cela ?
