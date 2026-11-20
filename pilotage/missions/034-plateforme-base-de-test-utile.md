# Mission 034 — plateforme-base-de-test-utile

> Ouverte le 2026-11-20 au cycle 12, par délégation (écart mineur relevé aux missions 030 et 033 : `preuve.sh` crée une base `sommier_test_mpreuveNNN` pour terrain, qui n'en a pas l'usage).
> Dépôt : `nemetonplateforme` (pilotage). PR de pilotage, hors plafond.

## Mission

**En une phrase (quoi, et pourquoi) :** Faire que `lance.sh` et `preuve.sh` ne préparent la base de test PostgreSQL (variable `SOMMIER_TEST_DB`, fichier d'environnement, `DROP/CREATE DATABASE`) que pour les dépôts qui s'en servent, pour qu'une mission ou une preuve dans un autre dépôt ne touche pas la base de sommieR.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les sources à lire avant d'agir

- `pilotage/outils/commun.sh`, `lance.sh`, `preuve.sh`, `test.sh`, `renviron.exemple`.
- `docs/adr/0001-agir-dans-un-autre-depot.md`, section « Les outils d'exécution ».
- Journal du 2026-11-20 : lignes 029 (base non créée par `lance.sh`), 030 et 033 (base créée pour terrain).

## Contrat aval lu

- Les outils n'ont qu'un utilisateur : l'orchestrateur. Leur interface reste la même (`lance.sh NNN depot fiche.md`, `preuve.sh NNN depot numero_pr`, codes de sortie 0, 1, 3, `A_BLANC=1`, `SEUIL_CHARGE_IO`, `PRESSURE_IO_FICHIER`).
- Pour sommieR, rien ne change : base `sommier_test_mNNN` / `sommier_test_mpreuveNNN`, recréée à chaque preuve.

## Ce qui est attendu

1. Dans `commun.sh`, une fonction unique qui dit si un dépôt a besoin de la base. Critère le plus simple et le plus sûr, écrit dans un commentaire : une liste réglable (variable `DEPOTS_AVEC_BASE`, `sommieR` par défaut). `lance.sh` et `preuve.sh` l'appellent avant `charge_renviron`.
2. En passant, `lance.sh` crée la base `sommier_test_mNNN` (avec `postgis` et `pgcrypto`) quand elle manque, comme `preuve.sh` le fait pour la sienne : c'est la cause de l'écart de 029 (journal du 2026-11-20). L'essai à blanc le dit sans le faire.
3. `test.sh` : des cas à blanc qui échoueraient sans le changement (dépôt sans base : ni `SOMMIER_TEST_DB` ni base annoncée ; `sommieR` : base annoncée ; liste réglable). `bash pilotage/outils/test.sh` vert.
4. ADR 0001 : une note datée à la fin de « Les outils d'exécution », sans réécrire le texte.
5. Journal en ajout seul.

## L'Homme

- **Agent :** `dev`, dans un worktree de ce dépôt. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** budget 2 $.
- **Ce qui ne lui est pas demandé :** lancer un vrai `claude -p`, `gh`, `docker` ou `psql` (essais à blanc seulement) ; lire ou recopier `~/.config/nemetonplateforme/renviron` (mot de passe) ; toucher un autre dépôt ; fusionner.
- **Dépend de / rouge attendu jusqu'à :** rien.
