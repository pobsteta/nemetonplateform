# Mission 011 — installer la méthode de l'Impératrice dans `sommieR`

> Ouverte sur l'accord de Pascal du 2026-11-17 (« Lance demarrer dans sommieR »), après
> l'entrée de `sommieR` dans la carte (14ᵉ projet). Un projet sans la méthode ne reçoit
> pas de mission de développement : l'installer est la première mission (`CLAUDE.md` de
> ce dépôt). Dépôt : `sommieR`. Exécutée par une session ouverte dans ce dépôt
> (`claude -p -w`, ADR 0001).

## Mission

**En une phrase (quoi, et pourquoi) :** Installer dans `sommieR` la méthode de l'Impératrice selon `/imperatrice:demarrer` (`CLAUDE.md`, `docs/brief.md`, `pilotage/`, `docs/adr/`, sans rien écraser), avec les réponses de Pascal ci-dessous, et y versionner `.claude/settings.json` (plugin) et une `.claude/test-command` alignée sur la CI, pour que `sommieR` puisse recevoir des missions et que ses PR soient prouvables vertes.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Ma réponse d'abord — réponses de Pascal aux questions de `/demarrer`

Proposées par l'orchestrateur à partir de `DESCRIPTION`, `README.md` et `specs/`,
**validées par Pascal le 2026-11-17** (« Oui je valide ») :

1. **Nom :** `sommieR`.
2. **Ce qu'il fait :** un paquet R qui tient le sommier des forêts unifié, à valeur
   probante : registres permanents en ajout seul, vérifiables par une chaîne de hachages
   SHA-256 sur du JSON canonique (RFC 8785), contraints par des déclencheurs PostGIS ;
   forêts domaniales, communales et privées sous PSG.
3. **Pour qui :** les gestionnaires forestiers, qui enregistrent ce qui advient face à ce
   que l'aménagement prévoit, et les tiers qui vérifient un sommier hors ligne
   (contentieux foncier, certification PEFC, transmission entre gestionnaires).
4. **Référentiels et conventions :** série A50 de l'ONF ; RFC 8785 ; cadre eIDAS pour la
   valeur probante ; PCI et EDIGEO (cadastre) ; la spec
   `specs/brief_sommier-unifie-synthese.md`.

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? | oui : le skill `demarrer` et ses gabarits ; les missions 001 à 004 pour la commande de tests | |
| A-t-il les moyens ? | oui : R, `testthat` et paquets sur le PC ; PostGIS local à vérifier (la CI monte une base PostGIS et échoue sans elle) | |

**Temps de la main :** appuyer.

## L'Homme

- **Agent :** l'orchestrateur de la session ouverte dans `sommieR`, appliquant
  `/imperatrice:demarrer`. **Modèle :** sonnet (`--model sonnet`).
- **Ce qui ne lui est pas demandé :** lancer `/brief` ; remplir les rubriques du brief
  au-delà des réponses ci-dessus ; écrire une mission ; toucher au code (`R/`, `tests/`,
  `inst/`, CI, `DESCRIPTION`, `NEWS.md`).

## Harnais

- **Peut :** créer `CLAUDE.md`, `docs/brief.md`, `pilotage/equipe.md`,
  `pilotage/kanban.md`, `pilotage/journal.md`, `pilotage/missions/`, `docs/adr/` depuis
  les gabarits du plugin ; reprendre dans `CLAUDE.md` les règles déjà écrites dans le
  dépôt (`README.md`, `specs/`, conventions visibles) en citant leur source ; créer
  `.claude/settings.json` (activation du plugin `imperatrice`, même contenu que dans
  `nemetonshiny`) et `.claude/test-command` ; ajuster `.gitignore` pour ne versionner de
  `.claude/` que ces deux fichiers ; ouvrir une PR (en français).
- **Ne doit pas :** écraser ou réécrire un fichier existant ; toucher au clone principal
  (Pascal y travaille sur `a50-1-edition`, avec une modification en cours) : partir
  d'`origin/main` à jour ; modifier le code, les tests, la CI, la version ; sauter des
  tests pour tenir un temps ; fusionner sa PR.
- **Sources autorisées :** le dépôt `sommieR`, les gabarits du skill `demarrer`,
  `docs/adr/0001-agir-dans-un-autre-depot.md` et les fiches 001 à 004 de
  `nemetonplateforme` (deux niveaux de tests si la suite dépasse 600 s).

## La commande de tests

- Lancer la suite comme la CI (`testthat`, base PostGIS comprise). Si une base PostGIS
  locale est joignable, la commande l'utilise comme la CI ; sinon, l'agent le dit dans la
  PR et la question revient à l'orchestrateur : **un vert obtenu en sautant les tests de
  base est trompeur** (commentaire de `.github/workflows/r.yml`).
- Si la suite dépasse 600 s : niveau rapide sous 600 s pour le hook, suite complète en CI
  (règle des deux niveaux, ADR 0001 amendée le 2026-11-16).
- La commande doit échouer avec un test cassé (à montrer, puis à défaire).

## Dépend de / rouge attendu jusqu'à

- **Dépend de :** rien. **CI rouge attendue :** aucune.

## Tests

- `.claude/test-command` sort en code 0 sur la branche, sous 600 s, sans test de base
  sauté sans le dire.
- Aucun fichier existant modifié hors `.gitignore`.

## Qui veille, qui tranche

- **Relecteur :** `relecteur`, puis l'orchestrateur (preuve du vert, ADR 0001) qui fusionne
  par délégation si les contrôles de la spec § 5 sont verts.
- **Budget de la session :** 3 $ ; limite 5400 s.
- **Qui tranche :** l'orchestrateur par délégation ; une question de sens remonte à Pascal.

## Comment saura-t-on que ça marche ?

Une session ouverte dans `sommieR` charge le plugin, trouve son `CLAUDE.md` et son
`pilotage/`, et le hook `tests_obligatoires` y lance la commande de tests.
