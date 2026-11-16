# ADR 0001 — agir dans un autre dépôt : une session ouverte dans le dépôt du projet

- **Date :** 2026-11-16
- **Statut :** acceptée par Pascal le 2026-11-16 (amendée le même jour après la critique
  du `contradicteur`, puis après les deux essais à blanc dans `terrain`)
- **Proposée par :** Claude (orchestrateur)
- **Tranchée par :** Pascal

## La décision en une phrase

Pour faire avancer une mission dans un projet, l'orchestrateur lance **une session
Claude Code ouverte dans le dépôt du projet** (`claude -p`, en arrière-plan, dans un
worktree neuf), qui s'arrête à la PR ; **l'orchestrateur prouve lui-même le vert** en
lançant les tests sur le commit exact de la PR, vérifie les six contrôles de la spec § 5,
puis fusionne. Rien de tout cela ne part avant un essai à blanc réussi dans `terrain`.

## Contexte

La spec validée (§ 5) délègue à l'orchestrateur les fusions et les releases « quand tout
est vert ». Il faut donc que le vert soit réel. Lu dans le plugin `imperatrice` 0.7.0 :

- `hooks/tests_obligatoires.py` lit `.claude/test-command` à la racine de
  `CLAUDE_PROJECT_DIR`, le dépôt de la session : ouverte ici, elle n'en a pas, et le hook
  ne fait rien.
- **Même ouvert dans le bon dépôt, ce hook ne prouve pas le vert** (critique du
  `contradicteur`) : il ne lance rien si `git status --porcelain` ne montre pas de code
  modifié (un agent qui a commité avant de s'arrêter passe sans test) ; au second arrêt,
  il laisse finir même rouge et l'inscrit seulement au journal ; son budget est de
  630 s, court pour Gradle ou R complet. C'est un garde-fou, pas une preuve.
- Son verrou est pris dans `git rev-parse --absolute-git-dir` : il vaut **par worktree**,
  pas par dépôt.
- `/boucle` lance les agents qui écrivent avec `isolation: "worktree"` : le worktree naît
  dans le dépôt de la session.
- `hooks/garde_main.py` suit `cd` et `git -C` ; `journal_ajout_seul.py` reconnaît tout
  chemin qui finit par `pilotage/journal.md` ; `journal_intact.py` contrôle le journal du
  dépôt courant. Les hooks d'un projet ne s'appliquent que si le plugin y est activé.
- Les arbres de travail sont occupés : celui de `nemetonshiny` est sur une branche de
  Pascal (`claude/cycle-2026.11q`), avec 7 worktrees.

Inventaire du 2026-11-16 (clones locaux) :

| Projet | Plugin activé | `.claude/test-command` | CI (`.github/workflows`) |
|---|---|---|---|
| `nemeton` | oui | **non** | à relever |
| `foretaccess` | non | **non** | à relever |
| `nemetonshiny` | oui | **filtrée** (`devtools::test(filter = "mcp_…")`) | à relever |
| `nemetonmcp` | non | **non** | à relever |
| `victor` | non | **non** | **aucune** |
| `aigora` | non | **non** | **aucune** |
| `aigora-nemeton` | non | **non** | sans GitHub (spec § 10) |
| `terrain` | oui | oui (`./gradlew test`, tests unitaires seuls) | à relever |
| `marculus`, `surculus`, `ramulus`, `groma` | oui | oui (Gradle) | à relever |
| `sylvostation` | non lu (pas de clone) | non lu | non lu |

### Les options envisagées

1. **Session ouverte dans le dépôt du projet, sans interface (`claude -p`)** : retenue,
   avec les règles ci-dessous.
2. **Session en arrière-plan (`claude --bg`)** que Pascal peut rejoindre (`attach`,
   `logs`, `stop`). Elle répond bien à « qui répond quand la session a une question ? »,
   mais ne se combine pas avec `-p` (pas de sortie structurée que l'orchestrateur puisse
   contrôler). **Gardée comme recours** quand Pascal veut prendre la main.
3. **Corriger le plugin** (hook qui lit la commande du dépôt courant, worktrees créés à la
   main) : change `methode-imperatrice` pour tous ses utilisateurs et ne règle que la
   moitié du problème (l'isolation de l'outil Agent reste attachée au dépôt de la
   session).
4. **`--add-dir`** : donne l'accès aux fichiers, pas les hooks ni les tests du projet.
5. **Pascal ouvre lui-même une session par projet** : sûr, mais c'est ce que le brief veut
   lui épargner.
6. **Monorepo ou sous-modules** : écarté par la spec § 9.
7. **GitHub Actions (Claude Code en CI)** : tests isolés du PC, mais secrets dans treize
   dépôts, pas de GitHub pour `aigora-nemeton`, tests Android et R lourds hors CI. En
   réserve.

### Les règles de l'option retenue

**Avant tout : l'essai à blanc.** Une session `claude -p` dans `terrain`, avec `-w`, sur
une branche jetable, sans PR ni fusion, avec une consigne qui modifie du code et s'arrête.
L'orchestrateur relève : le plugin `imperatrice` présent à l'initialisation, les hooks
`Stop` et `SubagentStop` déclenchés, le worktree de ses agents créé dans `terrain`, le
`CLAUDE.md` de `terrain` chargé, le coût. Si les hooks ou le `CLAUDE.md` ne sont pas
chargés, **l'ADR tombe** et revient à Pascal. Le résultat est inscrit au journal.

**Le lancement.** Une session par mission, dans un worktree neuf :

```
cd ~/dev/<projet> && claude -p "<consigne>" -w <mission> \
  --settings '{"enabledPlugins":{"imperatrice@pobsteta":true}}' \
  --permission-mode auto --permission-prompts none \
  --disallowedTools "Bash(gh pr merge *)" \
  --max-budget-usd <plafond de la fiche> \
  --output-format stream-json --json-schema <schéma de sortie>
```

- Jamais dans l'arbre de travail principal : `-w` est obligatoire.
- **Le plugin est imposé au lancement** (`--settings`) : un worktree ne contient que les
  fichiers versionnés, et `.claude/settings.json` ne l'est pas partout (premier essai
  à blanc, ci-dessous).
- **Un verrou par dépôt tenu par l'orchestrateur** : une seule session lancée par lui à
  la fois dans un dépôt.
- La consigne renvoie au brief déposé dans `~/dev/briefs/vers-<projet>/` (spec § 4).
- La session ne fusionne pas : elle **s'arrête à la PR** (fusion interdite par
  `--disallowedTools`).
- Les règles `deny` du projet s'appliquent (celles d'`aigora-nemeton` interdisent
  d'écrire dans les dépôts Néméton). Jamais de contournement des permissions.

**Le contrat de sortie.** Le schéma JSON impose au moins : la PR ouverte (ou aucune),
les tests lancés (SHA, commande, code de sortie), la question pour Pascal (vide ou non).
L'orchestrateur **rejette** le résultat si :

- l'événement `system/init` ne liste pas `imperatrice` dans ses plugins (cas, entre
  autres, d'un `--bare` devenu le défaut de `-p`) ;
- `permission_denials` n'est pas vide ;
- la sortie structurée manque ou ne dit pas quels tests ont tourné.

Une **question pour Pascal** remonte à l'orchestrateur, qui la pose à Pascal, puis reprend
la session avec `--resume` et la réponse. La session ne tranche aucune question de sens,
de périmètre ou de contrat.

**La preuve du vert** (contrôle n° 2 de la spec § 5). L'orchestrateur lance lui-même la
`.claude/test-command` du projet **sur le commit exact de la PR**, dans un worktree
jetable du projet, sans limite de 630 s, et inscrit au journal le SHA, la commande et le
code de sortie. Le hook de la session reste un garde-fou, il n'est pas la preuve. Les
contrôles n° 3 à 5 (tests en aval, tests de contrat, relecture du `contradicteur`) sont
lancés par l'orchestrateur de la même façon. Puis il fusionne, ou rend à Pascal.

**Pas de délégation sans contrôles.** Un projet sans plugin activé, sans
`.claude/test-command` complète, ou sans CI, ne voit aucune fusion déléguée : soit sa
première mission pose ce qui manque (avec l'accord de Pascal, `CLAUDE.md`), soit la
fusion revient à Pascal. C'est aujourd'hui le cas de `nemetonshiny` (commande filtrée),
de `victor` et d'`aigora` (pas de CI), et de tous les projets sans commande de tests.

**La trace et le coût.** Chaque session lancée est inscrite au journal d'ici : projet,
brief, PR, tests (SHA, code), `total_cost_usd`. Le plafond de dépense d'une mission est
écrit dans sa fiche et validé par Pascal à la porte n° 2.

### Les essais à blanc (2026-11-16, dans `terrain`)

1. **Sans `--settings`** (5 tours, 0,68 $) : `CLAUDE.md` chargé, worktrees de la session
   et du sous-agent créés dans `terrain`, sortie structurée remplie, aucun refus de
   permission ; mais **plugin absent et aucun hook**. Cause vérifiée :
   `.claude/settings.json` n'est pas versionné dans `terrain` (ni dans `nemetonshiny` ni
   dans `groma`), donc absent du worktree créé par `-w`.
2. **Avec `--settings`** (9 tours, 0,64 $) : plugin `imperatrice` listé à
   l'initialisation ; hooks `PreToolUse` (garde de `main`, journal), `SubagentStop` et
   `Stop` déclenchés et sortis en succès ; `./gradlew test` vert sur d74d2f3. **Réussi.**

Les deux worktrees et branches d'essai ont été supprimés ; `terrain` est revenu à son
état.

## Le crible FRANCE

| Lettre | Question | Réponse (une ligne) | Ce que ça coûte | Prêts à payer ? |
|---|---|---|---|---|
| **F**rugale | La plus simple qui tienne ? | Rien à changer dans le plugin : chaque projet garde ses garde-fous, l'orchestrateur ajoute la preuve | Un processus par mission, et des tests lancés deux fois (session, puis preuve) | Oui |
| **R**esponsable | Qui fait quoi ? | La session écrit et ouvre la PR ; l'orchestrateur prouve et fusionne ; Pascal tranche sens, contrats et budgets | L'orchestrateur ne suit pas chaque geste de la session | Oui : le journal du projet et le flux `stream-json` gardent le détail |
| **A**nticiper | Et si l'imprévu arrive ? | Essai à blanc d'abord ; résultat rejeté sans plugin, avec refus de permission ou sans tests ; question remontée à Pascal ; `--bg` en recours | Des cycles lents tant que les contrôles manquent | Oui |
| **N**ovateur | Toutes les idées écoutées ? | Sept options, dont `--bg`, la CI GitHub et le monorepo | Rien | Oui |
| **C**oût | Que coûte-t-elle ? | Une session par mission, plafonnée en dollars ; tests en double ; charge du PC | Jetons et temps machine, chiffrés au journal à chaque session | Oui, dans le plafond de chaque fiche |
| **É**cologique | Que réutilise-t-on ? | Hooks, worktrees, commandes de tests des projets, boîte `~/dev/briefs/` | Rien de neuf à maintenir hors d'un schéma de sortie | Oui |

## Valeurs sacrifiées

- **La vue fine de l'orchestrateur** : il lit le résultat et le journal de la session,
  pas chaque geste. Accepté : « chaque projet reste chez lui ».
- **La vitesse au départ** : sept projets sur treize n'ont pas de commande de tests
  complète, deux n'ont pas de CI. Rien n'y est délégué tant que c'est le cas. Accepté :
  un vert sans tests serait un faux vert.
- **La frugalité en calcul** : les tests tournent deux fois. Accepté : c'est le prix de
  la preuve, puisque Pascal ne relit plus.

## Sources

- Plugin `imperatrice` 0.7.0 (`~/.claude/plugins/cache/pobsteta/imperatrice/0.7.0/`) :
  `hooks/tests_obligatoires.py` (`code_modifie`, `second_arret`, `BUDGET`, verrou),
  `hooks/garde_main.py`, `hooks/journal_ajout_seul.py`, `hooks/journal_intact.py`,
  `hooks/hooks.json`, `skills/boucle/SKILL.md`.
- `claude --help` (Claude Code 2.1.325) : `-p`, `-w/--worktree`, `--bg`,
  `--permission-mode`, `--permission-prompts`, `--disallowedTools`, `--max-budget-usd`,
  `--output-format`, `--json-schema`, `--bare`, `--add-dir`.
- Documentation Claude Code, mode sans interface :
  https://code.claude.com/docs/en/headless (relevée par le `contradicteur`).
- `git worktree list` et `git branch --show-current` dans `nemeton` et `nemetonshiny` ;
  `.github/workflows` absent dans `victor` et `aigora` ; inventaire des
  `.claude/settings*.json` et `.claude/test-command`, 2026-11-16.
- `docs/spec.md` § 4, 5, 7, 9, 10 ; `docs/brief.md`, « Préalables bloquants ».
- Critique du `contradicteur`, 2026-11-16 (`pilotage/journal.md`).

## Question de contrôle

Cette décision tient-elle nos six valeurs, et que sommes-nous prêts à payer pour cela ?
