# Mission 035 — groma-terrain-gnss-2026-11-1

> Ouverte le 2026-11-20 au cycle 12, sur deux décisions de Pascal : noms communs = ceux de terrain (question 3 sur 3 du cycle 10), et voie A (journal du 2026-11-20 : noms de terrain dans le code seulement, GeoPackage inchangé).
> Dépôt : `groma` (session ouverte dans le projet, ADR 0001). Fusion par l'orchestrateur quand les contrôles sont verts. La release (PR release-please) n'est pas dans la mission.

## Mission

**En une phrase (quoi, et pourquoi) :** Faire passer Groma à `terrain` v2026.11.1 et remplacer sa copie du code GNSS (`Nmea.kt`, `Gnss.kt`, `Ntrip.kt`) par `terrain-gnss`, avec les noms de terrain dans le code mais sans changer une seule valeur du GeoPackage, pour que les applications de terrain partagent le même code GNSS (heure UTC du fix comprise) sans rompre la lecture des fichiers par nemeton.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les sources à lire avant d'agir

- Le brief, en entier, **avec son correctif daté en tête** (il remplace le point 2) : `/home/pascal/dev/briefs/vers-groma/2026-11-20-noms-communs-terrain.md`.
- Les deux autres briefs de la boîte : `2026-11-20-reponse-terrain-fix-horodate.md` (heure UTC du fix, `LecteurNmea`) et `2026-11-20-terrain-version-calendaire.md` (coordonnée JitPack `com.github.pobsteta.terrain:<module>:v2026.11.1`).
- Dans `groma` : `CLAUDE.md` (schéma unique, release-please, squash, ne jamais toucher nemeton), `pilotage/`, `android/groma-core/build.gradle.kts:31`, `android/app/build.gradle.kts:87-88` (terrain épinglé en v0.7.1), `android/groma-core/src/main/kotlin/groma/core/{Nmea,Gnss,Ntrip,MesureCentre,GeoPackage,EtatCentre}.kt`, `EquivalenceTerrainBibliothequesTest`.
- terrain, en lecture seule : `/home/pascal/dev/terrain` au tag `v2026.11.1` (module `terrain-gnss` : `QualiteFix`, `OrigineFix`, `NmeaParser`, `Ntrip`, `LecteurNmea`).

## Contrat aval lu

- **nemeton** lit `inventaire_video.gpkg` écrit par Groma : `qualite_gnss` ∈ {`fix`, `float`, `telephone`}, et filtre `telephone` pour l'alerte « centre au téléphone » (`nemeton/R/inventaire_video.R:121-122`, `:769`, `:903`) ; il lit aussi `source_azimut` (`boussole_telephone`, l. 125). **Aucune valeur, aucun champ, aucun domaine de `core/src/groma/donnees/inventaire_video.schema.json` ne change.** Un test le garde : un GeoPackage écrit après le changement contient exactement les mêmes valeurs qu'avant pour un même relevé (`fix`, `float`, `telephone`), et un fichier de l'ancien format (`android/app/src/androidTest/assets/projet_ancien.gpkg` ou équivalent) se relit à l'identique.
- **nemetonshiny** publie le projet QField que Groma télécharge : rien ne change dans ce sens.
- Les valeurs textuelles du fichier ne sont pas les noms d'énumération : la traduction (`OrigineFix.INTERNE` ↔ `telephone`, `QualiteFix.RTK_FIXE` ↔ `fix`, `RTK_FLOAT` ↔ `float`) se fait en un seul endroit, testé dans les deux sens.

## Ce qui est attendu

1. terrain épinglé en `v2026.11.1` pour tous ses modules (`terrain-carte`, `terrain-style`, et `terrain-gnss` ajouté) ; build vert.
2. `Nmea.kt`, `Gnss.kt`, `Ntrip.kt` de `groma-core` supprimés au profit de `terrain-gnss`, appels et tests repris avec les noms de terrain (`QualiteFix`, `OrigineFix`, `NmeaParser.parseGga`, `Ntrip.parseSourcetable`, `Ntrip.statutReponse`). Les tests de Groma qui portaient sur le code supprimé sont gardés là où ils testent un comportement de Groma, retirés avec le code copié sinon (dit dans la PR).
3. `EquivalenceTerrainBibliothequesTest` vert pendant la bascule, puis retiré avec la copie (brief, point 3).
4. Traduction en un seul endroit entre les types de terrain et les valeurs du schéma, et le test de non-changement du GeoPackage décrit plus haut.
5. Les textes affichés (`EtatCentre`, chaînes) ne changent pas pour l'utilisateur.
6. `PLAN.md` à jour (règle 7 du projet), journal du projet en ajout seul ; titre de PR en Conventional Commits (`feat(gnss): …` ou `refactor(gnss): …`, sans `!` : il n'y a pas de rupture) ; ne pas toucher aux numéros de version (release-please).
7. `.claude/test-command` verte sur le dernier commit, CI de la PR verte.
8. Un mot à la plateforme : ranger rien, mais dire dans la PR quels briefs de `vers-groma/` sont réalisés (l'orchestrateur les range).

## L'Homme

- **Agent :** `dev`, dans une session ouverte dans `groma`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** budget 3 $ ; worktree depuis `origin/main`.
- **Ce qui ne lui est pas demandé :** modifier le schéma du GeoPackage ou une valeur écrite ; toucher `nemeton`, `nemetonshiny`, `terrain` ou un autre dépôt ; fusionner ; toucher la PR release-please #114 ; publier une version.
- **Dépend de / rouge attendu jusqu'à :** terrain `v2026.11.1` publiée (fait, JitPack sert `terrain-gnss:v2026.11.1`).
