# Mission 006 — tests, commande de tests et CI dans `victor`

> Ouverte par Pascal le 2026-11-17 (« ouvre la mission victor »), en réponse à la
> question 2 du cycle 3. **Ce n'est pas une mission de même nature que 001 à 004** :
> elle écrit des tests, c'est du développement. Elle n'entre donc pas dans la délégation
> élargie du 2026-11-16 : **Pascal relit et fusionne la PR**. Dépôt : `victor`. Exécutée
> par une session ouverte dans ce dépôt (`claude -p -w`, ADR 0001).
>
> Numéro 006 : le 005 est déjà pris par la mission `nemetonshiny`
> (`service_monitoring_wiring`), dont la fiche est sur la branche locale
> `pilotage/cycle-3`, pas encore poussée.

## Mission

**En une phrase (quoi, et pourquoi) :** Donner à `victor` un premier jeu de tests
`pytest` sur son cœur existant, une `.claude/test-command` versionnée qui les lance et une
CI GitHub minimale qui les lance sur chaque PR, sans toucher au code de l'application,
pour que ce qui se fait dans `victor` puisse enfin être prouvé vert.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? | oui : `pytest` et `uv`, déjà le gestionnaire du projet (`pyproject.toml`, `uv.lock`) ; tests de caractérisation (ce que le code fait aujourd'hui, pas ce qu'il devrait faire) | |
| A-t-il les moyens ? | oui : 4 fichiers Python (3 507 lignes), dont 3 modules purs (`confirmation.py`, `journal_dictees.py`, `production.py`) ; aucune clé ni service réseau nécessaires pour eux | |

**Temps de la main :** appuyer.

## Ma réponse d'abord

_Rempli par Pascal seul, avant de lire le travail de l'agent._

## L'Homme

- **Agent :** `dev`. **Modèle :** sonnet (`--model sonnet`).
- **Ce qui ne lui est pas demandé :** corriger un bug trouvé en écrivant les tests (il le
  note dans la PR, avec le test marqué `xfail` et la raison) ; refactoriser `server.py`
  pour le rendre testable ; viser une couverture chiffrée ; installer le `pilotage/` de la
  méthode dans `victor`.

## Harnais

- **Peut :**
  - ajouter `tests/` (fichiers `test_*.py`, `conftest.py`) ;
  - ajouter `pytest` dans un groupe de dépendances de développement de `pyproject.toml`
    (`[dependency-groups] dev`) et mettre `uv.lock` à jour par `uv lock` ;
  - ajouter `.claude/test-command` (exécutable, lance `uv run pytest`) et
    `.claude/settings.json` activant le plugin `imperatrice`, au même contenu que celui de
    `foretaccess` (mission 002) ;
  - ajouter `.github/workflows/tests.yml` : `ubuntu-latest`, `astral-sh/setup-uv`, Python
    3.10 et la dernière stable, `uv run pytest`, sur `pull_request` et `push` vers `main` ;
  - ajuster `.gitignore` pour `.pytest_cache/` et, s'il le faut, pour ne versionner de
    `.claude/` que `settings.json` et `test-command` ;
  - ouvrir une PR (en français, comme les commits du dépôt).
- **Ne doit pas :** toucher à `main`, ni au clone principal de Pascal : partir
  d'`origin/main` à jour ; modifier `server.py`, `confirmation.py`, `journal_dictees.py`,
  `production.py`, `index.html` ou `enregistrer_visuel.js` ; changer la version
  (1.0.0) ; versionner `.env`, une clé ou une dictée ; lancer le serveur, Claude Code,
  Gradium ou l'API Anthropic depuis un test ; fusionner sa PR.
- **Sources autorisées :** le code et le `README.md` de `victor`, `specs/`,
  `docs/adr/0001-agir-dans-un-autre-depot.md` et
  `pilotage/missions/002-foretaccess-plugin-et-tests.md` de `nemetonplateforme`.

## Périmètre des tests (ordre de priorité)

1. `confirmation.py` : `extraire`, `valider`, `expire`, `contient_confirmation`,
   `resume_pour_voix`, la classe `Attentes` (l'horloge passée en paramètre, pas de
   `sleep`).
2. `journal_dictees.py` : `masquer`, `ecrire` dans un `tmp_path` (rotation à
   `_max_octets` comprise), `resultat_outil`, `resultat_tache`.
3. `production.py` : journal de production, `etat_production`, `timecodes`,
   `resume_rushes`, `verifier_indicateurs`, sur un kit factice dans `tmp_path`.
4. `server.py`, seulement si son import se fait sans effet de bord bloquant (réseau,
   clés, processus) une fois les variables d'environnement posées dans `conftest.py` :
   fonctions pures (`parse_espaces`, `id_a_dire`, `_norm`, `extraire_vue`,
   `_statut_job`, `message_calcul`, `calculs_a_annoncer`, `resoudre_projet` sur un
   répertoire factice). **Si l'import n'est pas possible sans modifier `server.py`,
   l'agent s'arrête sur ce point, ne le contourne pas, et le dit dans la PR** : la
   question revient à Pascal.

Les liens de `victor` vers `nemetonmcp` (fiches) et `nemetonshiny` (`compute_job.json`)
sont dans `docs/carte-dependances.md`. Un test qui fige la forme lue de ces fichiers est
le bienvenu, avec un exemple écrit à la main et la mention « contrat lu, à confirmer avec
le projet en amont ».

## Valeur provisoire (chiffre, réglage)

- **Valeur provisoire :** aucune suite aujourd'hui ; durée attendue bien sous 60 s.
- **Règle :** `.claude/test-command` lance toute la suite (un seul niveau, sous 600 s).

## Dépend de / rouge attendu jusqu'à

- **Dépend de :** rien. **CI rouge attendue :** aucune.

## Tests

- `uv run pytest` sort en code 0 sur la branche, et en code non nul avec une assertion
  cassée exprès dans un worktree jetable (puis on le jette).
- Le workflow `tests.yml` est vert sur la PR.

## Terrain

- **Échantillon :** dans la PR, la liste des fonctions couvertes, la durée de la suite,
  les tests `xfail` avec leur raison, et ce qui n'a pas pu être testé et pourquoi.

## Qui veille, qui tranche

- **Relecteur :** `relecteur`, puis l'orchestrateur (preuve du vert sur le SHA de la PR,
  ADR 0001).
- **Budget de la session :** 3 $ (`--max-budget-usd`), limite 3600 s.
- **Qui tranche :** **Pascal fusionne** (mission de développement, hors délégation).

## Comment saura-t-on que ça marche ?

Une PR suivante de `victor` montre le workflow `tests` vert, et une session `claude -p -w`
ouverte dans `victor` trouve `.claude/test-command` et le hook la lance à l'arrêt. Les
contrôles 1 et 2 de la spec § 5 existent alors pour `victor`.
