# Mission 032 — plateforme-outils-execution

> Ouverte le 2026-11-20 au cycle 10, décidée au bilan du 2026-11-20 (test du successeur de l'archiviste).
> Dépôt : `nemetonplateforme` (pilotage). PR de pilotage, hors plafond.

## Mission

**En une phrase (quoi, et pourquoi) :** Verser au dépôt les outils qui lancent, reprennent et prouvent les missions, les décrire dans l'ADR 0001 et remettre à jour l'état de la plateforme, pour qu'un successeur reprenne le pilotage depuis le dépôt seul.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les sources à lire avant d'agir

- Les scripts : `~/.cache/nemetonplateforme/lance.sh`, `relance.sh`, `preuve.sh`, `resultat.sh`, et leurs dépendances `m011/schema.json`, `m011/renviron` (**contient un mot de passe : ne jamais le verser, ni le recopier dans un message**).
- `docs/adr/0001-agir-dans-un-autre-depot.md` (dernière section « Ajout du 2026-11-18 »), `README.md`, `CLAUDE.md`, `pilotage/etat-cycle.yaml`, le journal du 2026-11-18 au 2026-11-20 (une base de test par mission et par preuve, coût cumulé d'une reprise, contrôle de la charge disque).

## Ce qui est attendu

1. `pilotage/outils/` : les quatre scripts, et un `schema.json`, sans chemin en dur vers `m011/` (le schéma lu dans le dépôt ; l'environnement de la base lu depuis un fichier hors dépôt dont le chemin est une variable, avec un `renviron.exemple` qui ne liste que les noms des variables). Ajouter à `lance.sh` et `preuve.sh` le contrôle de charge décidé au bilan : lire `/proc/pressure/io` et s'arrêter avec un message clair au-delà d'un seuil (60 % sur 60 s par défaut, réglable). Un test shell simple (`bash -n` et un essai à blanc qui n'appelle pas `claude`) pour chacun.
2. ADR 0001 : une section datée « Les outils d'exécution » (usage de chaque script, commande `claude -p` complète, base de test par mission et par preuve, coût cumulé d'une reprise, contrôle de charge), et une ligne datée qui met à jour le relevé des traces (m005 à m027 présents au 2026-11-20) sans effacer l'ancien. Lien depuis le `README.md`.
3. `README.md` et `CLAUDE.md` : nommer `~/dev/briefs/` (boîtes d'échange entre sessions, hors dépôt) et son README comme dépendance du pilotage.
4. `pilotage/etat-cycle.yaml` : `sommieR` à `v0.44.0` / `2ca88d8…` (SHA complet par `gh api repos/pobsteta/sommieR/commits/main`), lu le 2026-11-20.
5. `~/dev/briefs/vers-groma/traites/` (dossier imbriqué hors convention) : déplacer son contenu dans `~/dev/briefs/traites/` avec une ligne à `traites/INDEX.md`.
6. Journal en ajout seul ; le hook `journal_intact` du plugin doit rester vert.

## L'Homme

- **Agent :** `archiviste`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** worktree de ce dépôt.
- **Ce qui ne lui est pas demandé :** verser un secret ; modifier les scripts au-delà de leur emplacement, de leurs chemins et du contrôle de charge ; toucher un autre dépôt.
- **Dépend de / rouge attendu jusqu'à :** rien.
