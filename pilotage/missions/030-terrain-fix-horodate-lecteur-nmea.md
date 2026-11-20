# Mission 030 — terrain-fix-horodate-lecteur-nmea

> Ouverte le 2026-11-20 au cycle 10, sous la délégation du 2026-11-18 (« code ce qu'il reste à faire partout »), sur le brief `~/dev/briefs/vers-terrain/2026-11-18-groma-fix-horodate-et-lecteur-nmea.md`.
> Dépôt : `terrain` (session ouverte dans le projet, ADR 0001). Fusion par l'orchestrateur quand les contrôles sont verts.

## Mission

**En une phrase (quoi, et pourquoi) :** Ajouter à `terrain-gnss`, sans rien casser, l'heure UTC du fix et un lecteur NMEA en flux que Groma demande, pour que Groma puisse supprimer sa copie du code NMEA et qu'une correction se fasse à un seul endroit.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les sources à lire avant d'agir

- Le brief, en entier : `/home/pascal/dev/briefs/vers-terrain/2026-11-18-groma-fix-horodate-et-lecteur-nmea.md`.
- Dans `terrain` (vérifié le 2026-11-20 sur `origin/main` 330ac46) : `terrain-gnss/src/main/kotlin/fr/nemeton/terrain/gnss/NmeaParser.kt` (`TrameRmc`, `TrameGga`, `NmeaParser`), `FixGnss.kt` (`FixGnss`, `QualiteFix`, `OrigineFix`), `NmeaDecoupeur.kt` ; **`LecteurNmea` n'existe pas encore**. Le `CLAUDE.md` et le `pilotage/` de terrain.
- Le code de Groma, en lecture seule et sur `origin/main` (le clone local est en retard : `git -C ~/dev/groma fetch` puis `git show origin/main:<chemin>`) : `android/groma-core/src/main/kotlin/groma/core/Nmea.kt`, `Gnss.kt`, et les tests `android/groma-core/src/test/kotlin/groma/core/HeureUtcDuFixTest.kt`, `NmeaTest.kt`, `NtripTest.kt`.

## Contrat aval lu

- Avals de `terrain` (Gradle, version épinglée) : Marculus, Surculus, Groma (`docs/carte.yaml`). Ils ne changent qu'en montant de version : tout ajout doit être **additif**, avec des valeurs par défaut (`= null`), pour qu'une montée de version ne casse rien.
- **Ne renommer rien.** Les noms diffèrent entre Groma et terrain (`QualiteFix`, `OrigineFix`, API `Nmea.gga` / `NmeaParser.parseGga`…) et les valeurs sont écrites dans des GeoPackage : c'est une question réservée à Pascal (brief, dernière rubrique). La mission garde les noms de terrain et ajoute les champs et le lecteur sous des noms de terrain.
- Cas limites, chacun testé (les 8 tests `HeureUtcDuFixTest` de Groma les couvrent, à porter) : RMC de statut `V` (pas d'instant) ; GGA sans RMC valide (`heureUtcMs` null) ; passage de minuit UTC (veille, même jour, lendemain) ; séquences GSV incomplètes.

## Ce qui est attendu

1. Points 1 à 4 du brief, additifs, aux noms de terrain : `TrameRmc.instantUtcMs`, `TrameGga.heureJourMs`, `FixGnss.heureUtcMs` et `recuMonotoneMs`, `LecteurNmea` (horloge monotone injectable, `pousser(texte)`, `derniereGga`), qui s'appuie sur `NmeaDecoupeur`.
2. Point 5 : porter les tests de Groma (`HeureUtcDuFixTest`, et de `NmeaTest` / `NtripTest` ce qui porte sur une API que terrain a), adaptés aux noms de terrain ; dire dans la PR ce qui n'a pas été porté et pourquoi.
3. Version mineure suivante selon la règle de terrain, CHANGELOG ou NEWS, journal en ajout seul ; `.claude/test-command` (`./gradlew test`) verte ; CI verte.
4. Le brief rangé dans `~/dev/briefs/traites/` (convention du README de la boîte), avec une ligne à `traites/INDEX.md`. Profiter de la session pour vérifier les quatre briefs d'octobre encore dans `vers-terrain/` (`terrain-style`, `ecarts-terrain-voix`, `marculus-palette-reste-verte`, `complement-ecarts-terrain-voix`) : traités dans le code (inventaire du 2026-11-18) → les ranger avec la preuve (fichier ou commit) ; sinon les laisser et le dire.
5. Un mot à Groma : `~/dev/briefs/vers-groma/2026-11-20-reponse-terrain-fix-horodate.md` (version de terrain qui porte l'ajout, noms retenus, ce qui reste à Groma).

## L'Homme

- **Agent :** `dev`, dans une session ouverte dans `terrain`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** budget 3 $ ; worktree depuis `origin/main`.
- **Ce qui ne lui est pas demandé :** toucher un autre dépôt (sauf les boîtes `vers-groma` et `traites/`) ; renommer un type ou une valeur existants ; publier une release à la main ; fusionner.
- **Dépend de / rouge attendu jusqu'à :** rien.
