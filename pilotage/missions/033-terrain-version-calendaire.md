# Mission 033 — terrain-version-calendaire

> Ouverte le 2026-11-20 au cycle 11, sur la consigne de Pascal (réponse à la question 2 sur 3 du cycle 10) : « Passe terrain en tag, release, version sur la notation yyyy.mm.xxx ». Forme : celle de `nemeton` et de sommieR (`AAAA.M.N`), comme la mission 029.
> Dépôt : `terrain` (session ouverte dans le projet, ADR 0001). Fusion par l'orchestrateur quand les contrôles sont verts ; le premier tag `v2026.11.1` est posé ensuite par l'orchestrateur, sur la consigne de Pascal (journal du 2026-11-20).

## Mission

**En une phrase (quoi, et pourquoi) :** Faire passer les tags, releases et versions de `terrain` à la notation calendaire `vAAAA.M.N` de la plateforme, première version v2026.11.1 (qui porte l'heure UTC du fix de la mission 030 à la place de v0.8.0), pour qu'une seule convention de version vaille sur la plateforme.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les sources à lire avant d'agir

- La convention, en lecture seule : `/home/pascal/dev/nemeton/CLAUDE.md` § « Consignes de release pour ce projet » (`AAAA.M.N`, mois sans zéro en tête, N repart à 1 chaque mois) et la mission 029 de sommieR (`/home/pascal/dev/nemetonplateforme/pilotage/missions/029-sommier-version-calendaire.md`).
- Dans `terrain` (vérifié le 2026-11-20 sur `origin/main` e49186a) : `README.md` § « Publier une version » (l. ~200-216 : Pascal pose `vX.Y.Z` sur un commit de `main`, JitPack construit au tag, SHA court pour épingler), l. 194-195, `CLAUDE.md` l. 77-78, `.github/workflows/ci.yml` (déclenché sur `tags: ['v*']`, contrôle « le tag désigne un commit de main », ADR 0003), `build.gradle.kts` l. 6-9 (`version` lue dans la variable `VERSION`, « dev » par défaut), les ADR 0002 et 0003 du projet, son `pilotage/`.

## Contrat aval lu

- Avals Gradle, version épinglée, par JitPack (`com.github.pobsteta.terrain:<module>:<tag>`) : Marculus (`gradle/libs.versions.toml:18`, `terrain = "v0.5.0"`), Surculus, Groma. Le nom du tag **est** la version vue par JitPack : `v2026.11.1` est une coordonnée valide, et `2026.11.1 > 0.7.1` dans l'ordre de Gradle. Rien ne change pour un aval tant qu'il ne monte pas de version ; ne toucher aucun de ces dépôts.
- Les tags `v0.x` existants restent (JitPack les sert encore) ; rien n'est retagué.
- Cas limites : mois à un chiffre (`v2026.1.1`, jamais `v2026.01.1`) ; changement de mois (N repart à 1) ; un tag hors format (`v0.8.0`, `v2026.01.1`) doit être refusé par la CI avec un message clair.

## Ce qui est attendu

1. `README.md` (§ « Publier une version », et la l. 194-195) et `CLAUDE.md` : la règle `vAAAA.M.N`, avec un lien vers la convention de `nemeton` plutôt qu'une copie ; dire que v0.7.1 est la dernière version 0.x et que v2026.11.1 la suit (la v0.8.0 annoncée au README l. 60 n'est jamais posée : corriger l'annonce par une note datée).
2. `.github/workflows/ci.yml` : sur un tag, refuser un nom hors du format `^v[0-9]{4}\.([1-9]|1[0-2])\.[1-9][0-9]*$` (après le contrôle ADR 0003, qui reste), et vérifier que l'année et le mois du tag sont ceux du commit taggé ou du jour (le plus simple et le plus sûr des deux, dit dans la PR). Puis, tests verts, créer la release GitHub du tag (`gh release create "$GITHUB_REF_NAME" --generate-notes --verify-tag`, permission `contents: write`), idempotente si elle existe déjà.
3. Un test du contrôle de format (script shell appelé par la CI et par un test, ou test Gradle) qui échouerait sur `v0.8.0` et `v2026.01.1` et passerait sur `v2026.11.1`.
4. Journal en ajout seul ; une ligne d'ADR si le projet consigne ses conventions de publication en ADR (ADR 0003 : ajouter une note datée, ne pas la réécrire). `.claude/test-command` (`./gradlew test`) verte ; CI verte.
5. Un mot aux avals : `~/dev/briefs/vers-groma/2026-11-20-terrain-version-calendaire.md`, et le même dans `vers-marculus/` et `vers-surculus/` (prochaine version de terrain : `v2026.11.1`, pas `v0.8.0` ; coordonnée JitPack ; rien à faire avant de vouloir monter).

## L'Homme

- **Agent :** `dev`, dans une session ouverte dans `terrain`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** budget 3 $ ; worktree depuis `origin/main`.
- **Ce qui ne lui est pas demandé :** poser un tag ou une release ; toucher un autre dépôt (sauf les boîtes de briefs nommées) ; retaguer une version existante ; fusionner.
- **Dépend de / rouge attendu jusqu'à :** rien.
