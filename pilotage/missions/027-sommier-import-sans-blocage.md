# Mission 027 — sommier-import-sans-blocage

> Ouverte le 2026-11-19 sur décision de Pascal au bilan du cycle 9 : « fais ce qu'il y a de
> mieux et de plus logique qui ne bloque pas le travail de terrain et continue ».
> Dépôt : `sommieR` (session ouverte dans le projet, ADR 0001). Fusion par l'orchestrateur quand
> les contrôles sont verts.

## Mission

**En une phrase (quoi, et pourquoi) :** Faire qu'aucun écart de forme d'une tournée de terrain ne fasse refuser l'import quand la donnée reste lisible : l'écart est accepté et signalé, pour que le travail de terrain ne soit jamais bloqué et que rien ne se perde.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les sources à lire avant d'agir

- La spec de Surculus, en lecture seule : `/home/pascal/dev/surculus/docs/spec.md` § 5 (vers la l. 380) et l. 95 (« un lecteur ignore les champs en plus »).
- Les réponses déjà envoyées : `/home/pascal/dev/briefs/vers-surculus/2026-11-19-reponse-sommier-photos-terrain.md`, `/home/pascal/dev/briefs/vers-surculus/2026-11-18-niveaux-de-concurrence-reponse.md`.
- Le journal de sommieR (missions 022, 025, 026) et les relectures citées au journal de nemetonplateforme du 2026-11-19.

## Ce qui est attendu

1. **`photos_terrain`, colonnes en trop** : une colonne inconnue n'empêche plus l'import. Elle est ignorée et nommée dans le compte rendu d'import (avertissement, pas faute), comme le veut la spec de Surculus. Une colonne **obligatoire manquante** reste une faute lisible. Les cas limites relevés à la relecture de #82 (sha256 vide, deux lignes pour la même photo) donnent un avertissement, pas une erreur R.
2. **Position du fix** : la géométrie POINT de `photos_terrain` est lue et inscrite au payload de la photo (coordonnées et SCR de la couche), à côté de la position EXIF brute, sans conversion de repère.
3. **Concurrence** (`registre6_controle()`) : quand les deux comptages sont fournis et que `concurrence` est absent, le niveau est déduit par `sommier_niveau_concurrence()`. Quand le niveau saisi contredit les comptages, l'entrée est **acceptée** telle que saisie et l'écart est signalé (avertissement, et une trace dans le payload, par exemple `concurrence_calculee`). Répondre au commentaire Codex P2 de la PR sommieR #78.
4. **Date de l'ortho** : `sommier_projet_qfield_travaux()` (et ce qui produit `ortho.mbtiles`) accepte une date facultative pour `date_mise_a_jour` ; sans elle, la date du fichier comme aujourd'hui. Doc qui dit le sens de cette date.
5. Corriger la phrase de NEWS 0.40.0 « validation de `registre6_controle()` inchangée » par une ligne de la nouvelle version (NEWS ne se réécrit pas en arrière si le projet l'interdit ; sinon, une note).
6. Tests pour chaque point ; `.claude/test-command` verte ; CI verte ; version mineure suivante (0.44.0), NEWS, journal en ajout seul.
7. Un mot à Surculus dans `~/dev/briefs/vers-surculus/2026-11-19-reponse-sommier-import-souple.md` : colonnes en plus ignorées, position du fix lue, niveau de concurrence déduit ou signalé.

Aucune rupture : l'import accepte plus qu'avant, il ne refuse rien de ce qu'il acceptait.

## L'Homme

- **Agent :** `dev`, dans une session ouverte dans `sommieR`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** budget 3 $ ; worktree depuis `origin/main`.
- **Ce qui ne lui est pas demandé :** toucher un autre dépôt (sauf la boîte `vers-surculus`) ; fusionner ; changer les seuils 20 % et 50 % ni la règle du besoin absent (gardés, décision du 2026-11-19).
