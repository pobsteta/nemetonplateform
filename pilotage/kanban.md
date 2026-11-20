# Kanban de nemetonplateforme

> Cinq colonnes (fiche n° 8). Chaque carte porte l'Homme (qui), la Mission (quoi, quand,
> combien) et les Moyens (comment, où, avec qui), et renvoie à sa fiche dans
> `pilotage/missions/`. Elle note aussi depuis quel cycle de `/boucle` elle est dans sa
> colonne ; on change ce numéro chaque fois qu'elle change de colonne.
> **Une carte qui ne bouge pas est souvent la mauvaise nouvelle à dire tout de suite.**
>
> Ce kanban est commun à tous les projets pilotés : chaque carte nomme son **dépôt**. Une
> mission propre à un projet qui a son `pilotage/` reste dans le kanban de ce projet ;
> ici, sa carte y renvoie par un lien, sans la recopier.

**Dernier cycle :** 12 _(augmenté de 1 à la fin de chaque `/boucle`, même quand elle n'a
rien lancé. Une carte est immobile quand dernier cycle − N ≥ 2.)_

_Modèle de carte :_

```
- [NNN-titre](missions/NNN-titre.md) · dépôt · depuis le cycle N
  - Homme : qui
  - Mission : quoi, quand, combien
  - Moyens : comment, où, avec qui
  - Dépend de : mission ou release en amont, ou « rien »
```

## Bac à sable

## Validé

## Planifié

## En cours

## Terminé

- [035-groma-terrain-gnss-2026-11-1](missions/035-groma-terrain-gnss-2026-11-1.md) · groma · depuis le cycle 12 · PR #116 fusionnée en squash (f6e7c22) après un aller-retour ; release 2026.11.9 (PR release-please #114) à décider
  - Homme : `dev` d'une session ouverte dans `groma` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : terrain v2026.11.1 et `terrain-gnss` à la place de la copie GNSS de Groma, noms de terrain dans le code, GeoPackage inchangé (voie A)
  - Moyens : budget 3 $ (1,85 $ dépensés, coût cumulé)
  - Dépend de : terrain v2026.11.1 (fait)
- [034-plateforme-base-de-test-utile](missions/034-plateforme-base-de-test-utile.md) · nemetonplateforme · depuis le cycle 12 · PR #45 fusionnée (00e7eea)
  - Homme : `dev` dans un worktree de ce dépôt (sonnet), relu par le `relecteur`
  - Mission : base de test PostgreSQL préparée seulement pour les dépôts qui s'en servent (sommieR)
  - Moyens : budget 2 $
  - Dépend de : rien
- [033-terrain-version-calendaire](missions/033-terrain-version-calendaire.md) · terrain · depuis le cycle 11 · PR #35 fusionnée (39bba22) ; tag et release v2026.11.1 posés par l'orchestrateur, JitPack sert v2026.11.1
  - Homme : `dev` d'une session ouverte dans `terrain` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : tags, releases et versions de terrain en `vAAAA.M.N`, première v2026.11.1 (porte la 030) ; tag posé par l'orchestrateur après fusion
  - Moyens : budget 3 $ ; worktree depuis `origin/main`
  - Dépend de : rien
- [028-sommier-import-comptages](missions/028-sommier-import-comptages.md) · sommieR · depuis le cycle 10 · PR #86 fusionnée en squash (fa558ed) après deux allers-retours ; release v2026.11.2
  - Homme : `dev` d'une session ouverte dans `sommieR` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : l'import QField lit `nb_plants_vivants` et `nb_plants_concurrences`
  - Moyens : budget 3 $
  - Dépend de : fusion de 029 (mêmes fichiers de version)
- [029-sommier-version-calendaire](missions/029-sommier-version-calendaire.md) · sommieR · depuis le cycle 10 · PR #85 fusionnée en squash (df94a39) ; release v2026.11.1
  - Homme : `dev` d'une session ouverte dans `sommieR` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : versions, tags et releases en `AAAA.M.N` (convention de `nemeton`), première 2026.11.1
  - Moyens : budget 3 $ ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien
- [030-terrain-fix-horodate-lecteur-nmea](missions/030-terrain-fix-horodate-lecteur-nmea.md) · terrain · depuis le cycle 10 · PR #34 fusionnée (e49186a) ; tag v0.8.0 à poser par Pascal
  - Homme : `dev` d'une session ouverte dans `terrain` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : heure UTC du fix et lecteur NMEA demandés par Groma, additifs, aux noms de terrain
  - Moyens : budget 3 $ ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien
- [031-nemetonshiny-hebergeur-hostinger](missions/031-nemetonshiny-hebergeur-hostinger.md) · nemetonshiny · depuis le cycle 10 · PR #307 fusionnée (c6f94cf7), documentation seule
  - Homme : `dev` d'une session ouverte dans `nemetonshiny` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : note datée Hostinger dans le brief et l'ADR 0003, documentation seule
  - Moyens : budget 1 $
  - Dépend de : rien
- [032-plateforme-outils-execution](missions/032-plateforme-outils-execution.md) · nemetonplateforme · depuis le cycle 10 · PR #40 fusionnée (9d6c16d), un aller-retour
  - Homme : `archiviste`, relu par le `relecteur`
  - Mission : outils d'exécution versés au dépôt et décrits dans l'ADR 0001 ; état de la plateforme à jour
  - Moyens : worktree de ce dépôt ; PR de pilotage, hors plafond
  - Dépend de : rien

- [027-sommier-import-sans-blocage](missions/027-sommier-import-sans-blocage.md) · sommieR · depuis le cycle 9 · PR #84 fusionnée en squash (2ca88d8), 0.44.0 ; 3,15 $ pour un budget de 3 $ (coût cumulé de la dernière passe)
  - Homme : `dev` d'une session ouverte dans `sommieR` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : aucun écart de forme d'une tournée de terrain ne fait refuser l'import ; accepté et signalé
  - Moyens : quatre passes ; vert prouvé par l'orchestrateur sur 6a24a90 (568 s)
  - Dépend de : rien

- [025-sommier-ortho-tuilee](missions/025-sommier-ortho-tuilee.md) · sommieR · depuis le cycle 9 · PR #83 fusionnée en squash (ab21e89), 0.43.0 ; remplace #79 ; rupture acceptée par Pascal
  - Homme : `dev` d'une session ouverte dans `sommieR` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : ortho de la tournée des travaux en MBTiles EPSG:3857, zooms 12 à 18, PNG à bords transparents, attribution et date
  - Moyens : budget 3 $ par passe ; cinq passes ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [014-contrat-nemeton-sommier](missions/014-contrat-nemeton-sommier.md) · sommieR · depuis le cycle 9 · PR #73 fusionnée en squash
  - Homme : `testeur` d'une session ouverte dans `sommieR` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : test de contrat de ce que sommieR lit dans nemeton
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [015-contrat-nemeton-nemetonshiny](missions/015-contrat-nemeton-nemetonshiny.md) · nemetonshiny · depuis le cycle 9 · PR #306 fusionnée (6fe1df4d)
  - Homme : `testeur` d'une session ouverte dans `nemetonshiny` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : test de contrat de ce que nemetonshiny lit dans nemeton ; R-CMD-check et coverage relancés deux fois (runners lents)
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [016-contrat-nemeton-nemetonmcp](missions/016-contrat-nemeton-nemetonmcp.md) · nemetonmcp · depuis le cycle 9 · PR #37 fusionnée en squash
  - Homme : `testeur` d'une session ouverte dans `nemetonmcp` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : test de contrat de ce que nemetonmcp lit dans nemeton ; enable_rag et ingest verrouillés
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [017-nemetonmcp-suivre-nemeton](missions/017-nemetonmcp-suivre-nemeton.md) · nemetonmcp · depuis le cycle 9 · PR #38 fusionnée en squash (0f5c666)
  - Homme : `dev` d'une session ouverte dans `nemetonmcp` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : suivre nemeton 2026.11.32-34 : froid d'hiver en tâche de fond, erreur si E-OBS manque, cache avant le choix d'UG
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [018-marculus-tarifs-et-style](missions/018-marculus-tarifs-et-style.md) · marculus · depuis le cycle 9 · PR #80 fusionnée en squash (8255b8f)
  - Homme : `dev` d'une session ouverte dans `marculus` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : tarifs IFN et style commun ; issue #2 fermée
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [019-groma-texte-et-heure-utc](missions/019-groma-texte-et-heure-utc.md) · groma · depuis le cycle 9 · PR #113 fusionnée en squash (8859705)
  - Homme : `dev` d'une session ouverte dans `groma` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : styles typographiques Material3 communs ; heure UTC complète du fix GNSS
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [020-groma-modules-terrain](missions/020-groma-modules-terrain.md) · groma · depuis le cycle 9 · PR #115 fusionnée en squash (4cff183)
  - Homme : `dev` d'une session ouverte dans `groma` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : Position, Projections, Geodesie et FormatGpkg repris de terrain ; brief retour vers terrain (horodate et lecteur NMEA)
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [021-sommier-actions-realisees](missions/021-sommier-actions-realisees.md) · sommieR · depuis le cycle 9 · PR #80 fusionnée en squash (02702cc), 0.41.0 ; remplace #74
  - Homme : `dev` d'une session ouverte dans `sommieR` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : sommier_actions_realisees() et action_id en liste de valeurs QField ; lien nemetonshiny ← sommieR confirmé
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [022-sommier-niveaux-concurrence](missions/022-sommier-niveaux-concurrence.md) · sommieR · depuis le cycle 9 · PR #78 fusionnée en squash (7db28dd), 0.40.0 ; remplace #76
  - Homme : `dev` d'une session ouverte dans `sommieR` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : trois niveaux de concurrence et règle plant → placette ; réponse à Surculus
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [023-sommier-symbologie-travaux](missions/023-sommier-symbologie-travaux.md) · sommieR · depuis le cycle 9 · PR #75 fusionnée en squash (14c54f4), 0.38.0
  - Homme : `dev` d'une session ouverte dans `sommieR` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : symbologie des travaux comme Marculus ; CI épinglée sur ubuntu-24.04
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [024-sommier-demo-marsannay](missions/024-sommier-demo-marsannay.md) · sommieR · depuis le cycle 9 · PR #77 fusionnée en squash (f909f2e), 0.39.0
  - Homme : `dev` d'une session ouverte dans `sommieR` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : démo Marsannay : parcelles communales réelles, écritures inventées
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [026-sommier-photos-terrain](missions/026-sommier-photos-terrain.md) · sommieR · depuis le cycle 9 · PR #82 fusionnée en squash (88f7bdd), 0.42.0 ; remplace #81
  - Homme : `dev` d'une session ouverte dans `sommieR` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : photos de placette et de plant : EXIF (repère, précision, fuseau) et photos_terrain au schéma de Surculus ; réponse à Surculus
  - Moyens : budget 3 $ par passe ; vert prouvé par l'orchestrateur sur le SHA exact
  - Dépend de : rien

- [012-rangement-memoire](missions/012-rangement-memoire.md) · nemetonplateforme · depuis le cycle 8 · PR #27 fusionnée (120ccfe)
  - Homme : `archiviste` (sonnet)
  - Mission : README, renvois à l'ADR 0001, `fusion:` par projet dans la carte, projets observés, comptes, tableau des missions, boîtes de `~/dev/briefs/`
  - Moyens : un worktree de ce dépôt ; un écart relevé au passage (foretaccess #166 fusionnée en squash à tort)
  - Dépend de : rien
- [013-sommier-ci-dependances](missions/013-sommier-ci-dependances.md) · sommieR · depuis le cycle 8 · PR #72 fusionnée en squash (99984d6)
  - Homme : `dev` d'une session ouverte dans `sommieR` (sonnet, ADR 0001), relu par le `relecteur`
  - Mission : cause trouvée (apt des paquets -dev des Suggests, 117 Mo à 171 kB/s, hors du cache R) ; `PKG_SYSREQS=false` ; installation R de 12-20 min à 23-40 s
  - Moyens : budget 3 $ ; deux passes, environ 2,8 $ cumulés
  - Dépend de : rien

- [011-sommier-demarrer](missions/011-sommier-demarrer.md) · sommieR · depuis le cycle 6 · PR #70 fusionnée en squash (cce46d0)
  - Homme : orchestrateur d'une session ouverte dans `sommieR` (`/imperatrice:demarrer`, sonnet, ADR 0001)
  - Mission : méthode installée (brief et ADR dans `pilotage/`), plugin, `.claude/test-command` en niveau rapide (30 fichiers sur 45, base PostGIS jointe)
  - Moyens : budget 3 $ ; entre 1,55 et 2,18 $ estimés, trois passes, environ 78 min
  - Dépend de : rien

- [009-nemetonshiny-availablecores-tests](missions/009-nemetonshiny-availablecores-tests.md) · nemetonshiny · depuis le cycle 5 · PR #305 fusionnée (50de1fd)
  - Homme : `dev` (sonnet), dans une session ouverte dans `nemetonshiny` (ADR 0001)
  - Mission : les deux derniers `future::availableCores()` des tests passés à `parallelly`
  - Moyens : budget 3 $, 5400 s ; 0,43 $ et 261 s
  - Dépend de : 005 (fusionnée)

- [010-confirmer-liens-carte](missions/010-confirmer-liens-carte.md) · nemetonplateforme · depuis le cycle 5 · PR #20 fusionnée (691ebaa)
  - Homme : `archiviste` (sonnet), sous-agent dans un worktree de ce dépôt
  - Mission : 6 liens `confirme: non` relus dans le code : 2 retirés, 4 laissés à `non` avec une question pour Pascal
  - Moyens : lecture seule des clones et de `~/dev/briefs/`
  - Dépend de : 007 et 008 (fusionnées)

- [008-etat-cycle-yaml](missions/008-etat-cycle-yaml.md) · nemetonplateforme · depuis le cycle 4 · PR #18 fusionnée (562542d)
  - Homme : `archiviste` (sonnet), sous-agent dans un worktree de ce dépôt
  - Mission : `pilotage/etat-cycle.yaml`, état lu des 13 projets ; tags et versions retirés de la carte en prose
  - Moyens : `git ls-remote` et `gh` en lecture seule
  - Dépend de : 007 (fusionnée)

- [007-carte-yaml](missions/007-carte-yaml.md) · nemetonplateforme · depuis le cycle 4 · PR #17 fusionnée (37f507a)
  - Homme : `archiviste` (sonnet), sous-agent dans un worktree de ce dépôt
  - Mission : `docs/carte.yaml`, 13 projets et 20 liens (6 à confirmer), source unique des liens
  - Moyens : `docs/carte-dependances.md`, lecture seule des clones
  - Dépend de : rien

- [005-nemetonshiny-service-monitoring-wiring](missions/005-nemetonshiny-service-monitoring-wiring.md) · nemetonshiny · depuis le cycle 3 · PR #304 fusionnée (3a00990)
  - Homme : `dev` (sonnet), dans une session ouverte dans `nemetonshiny` (ADR 0001)
  - Mission : `parallelly::availableCores()` au lieu de `future::availableCores()`, `service_monitoring_wiring` revenu dans le niveau rapide
  - Moyens : budget 3 $, 5400 s ; 0,56 $ et 464 s à la relance
  - Dépend de : rien

- [006-victor-tests-et-ci](missions/006-victor-tests-et-ci.md) · victor · depuis le cycle 3 · PR #1 fusionnée (1ac4cce)
  - Homme : `dev` (sonnet), dans une session ouverte dans `victor` (ADR 0001)
  - Mission : premiers tests `pytest` du cœur, `.claude/test-command`, plugin, CI minimale ; Pascal fusionne
  - Moyens : `uv` du projet ; budget 3 $, 3600 s
  - Dépend de : rien

- [003-nemetonmcp-plugin-et-tests](missions/003-nemetonmcp-plugin-et-tests.md) · nemetonmcp · depuis le cycle 1 · PR #36 fusionnée (cf89cd3)
  - Homme : `testeur` (sonnet), dans une session ouverte dans `nemetonmcp` (ADR 0001)
  - Mission : activer le plugin, versionner une `.claude/test-command` (JS et R)
  - Moyens : la CI du projet comme modèle ; budget 3 $ (provisoire)
  - Dépend de : rien

- [001-nemeton-commande-de-tests](missions/001-nemeton-commande-de-tests.md) · nemeton · depuis le cycle 1 · PR #667 fusionnée (70618fd)
  - Homme : `testeur` (sonnet), dans une session ouverte dans `nemeton` (ADR 0001)
  - Mission : versionner une `.claude/test-command` (niveau rapide, suite complète en CI)
  - Moyens : la CI du projet comme modèle ; budget 3 $ (provisoire)
  - Dépend de : rien

- [002-foretaccess-plugin-et-tests](missions/002-foretaccess-plugin-et-tests.md) · foretaccess · depuis le cycle 1 · PR #166 fusionnée (6c15472)
  - Homme : `testeur` (sonnet), dans une session ouverte dans `foretaccess` (ADR 0001)
  - Mission : activer le plugin, versionner une `.claude/test-command` (niveau rapide, suite complète en CI)
  - Moyens : la CI du projet comme modèle ; budget 3 $ (provisoire)
  - Dépend de : rien

- [004-nemetonshiny-commande-de-tests](missions/004-nemetonshiny-commande-de-tests.md) · nemetonshiny · depuis le cycle 2 · PR #303 fusionnée (5b58734)
  - Homme : `testeur` (sonnet), dans une session ouverte dans `nemetonshiny` (ADR 0001)
  - Mission : versionner la `.claude/test-command` (niveau rapide, suite complète en CI)
  - Moyens : missions 001 et 002 en modèles ; budget 3 $
  - Dépend de : rien

## Abandonné

_Avec la raison, en une ligne._

## Livraisons

_Une ligne par cycle, ajoutée sous la précédente à la fin de chaque `/boucle`, et une
par `/bilan` : la livraison que Pascal a retenue, pour qui, et ce qu'elle apporte de plus
que la précédente du même rythme. Un cycle sans livraison neuve livre sa mauvaise
nouvelle, car
« une mauvaise nouvelle est une livraison sur laquelle on apprend » (Pascal) : on
l'inscrit avec ce qu'elle nous apprend._

```
- cycle N · livraison · pour qui · ce qu'elle apporte de plus que la précédente
- cycle N · mauvaise nouvelle : … · pour qui · ce qu'elle nous apprend
- bilan du AAAA-MM-JJ · livraison · pour qui · ce qu'elle apporte de plus que la précédente
- bilan du AAAA-MM-JJ · mauvaise nouvelle : … · pour qui · ce qu'elle nous apprend
```

- cycle 1 · `nemeton`, `foretaccess` et `nemetonmcp` ont une `.claude/test-command` versionnée (et le plugin pour les deux derniers) · pour l'orchestrateur et Pascal · leurs PR deviennent prouvables vertes, donc leurs fusions délégables ; la règle des deux niveaux (rapide au hook, complet en CI) est née de la mauvaise nouvelle des suites d'une heure
- cycle 2 · `nemetonshiny` versionne sa `.claude/test-command` (niveau rapide, 118 fichiers sur 181, par exclusion des lents) ; ADR-016 rangée, rejetée · pour l'orchestrateur et Pascal · quatre projets ont désormais leurs fusions délégables ; mauvaise nouvelle apprise : une session sur une suite longue dépasse 3600 s, la fiche doit prévoir sa limite
- cycle 3 · `victor` a ses premiers tests, sa `.claude/test-command` et sa CI ; `nemetonshiny` n'a plus de test rouge quand il passe seul, et son niveau rapide repasse à 119 fichiers · pour l'orchestrateur et Pascal · cinq projets ont désormais leurs fusions prouvables ; mauvaise nouvelle apprise : une session lancée en arrière-plan ne survit ni à l'archivage de la session qui l'attend ni à un redémarrage, ses traces vont hors de `/tmp`
- cycle 4 · `docs/carte.yaml` (13 projets, 20 liens sourcés, 6 à confirmer) et `pilotage/etat-cycle.yaml` (état lu des 13 projets) · pour l'orchestrateur · un cycle peut désormais partir de ce qui a changé et trouver l'aval dans un fichier lu par la machine ; critères n° 1 et 2 de la spec en place ; mauvaise nouvelle apprise : la carte en prose recopiait des tags et des versions, périmés en un jour (cinq tags sur treize)
- cycle 5 · plus aucun appel déprécié à `future::availableCores()` dans `nemetonshiny` ; carte relue dans le code (18 liens, 4 questions précises au lieu de 6 liens douteux) · pour l'orchestrateur et Pascal · la carte ne désigne plus d'aval qui n'existe pas (`surculus` n'est pas en aval de `nemetonshiny`) ; mauvaise nouvelle apprise : un trajet réel peut passer par un projet hors carte (sommieR), et une décision « seulement observé » peut perdre sa raison en un cycle (`sylvostation` a désormais un `main`)
- cycle 6 · sommieR, 14ᵉ projet, a la méthode, le plugin et une `.claude/test-command` (niveau rapide, base PostGIS jointe, échec si elle manque) ; carte entièrement tranchée par la règle « un lien suit la dépendance technique » ; `sylvostation` piloté · pour l'orchestrateur et Pascal · sept projets ont leurs fusions prouvables ; mauvaise nouvelle apprise : `/demarrer` pose ses questions à Pascal et ne se lance pas sans lui ; le gabarit met brief et ADR dans `docs/`, publié par pkgdown dans les paquets R ; le coût d'une session reprise est cumulé, pas additionnel
- cycle 7 · rien de neuf à livrer : aucun tag, aucun `main` changé hors de la fusion sommieR #71 (porte n° 3 de sommieR alignée sur la délégation) · pour Pascal · mauvaise nouvelle apprise : la CI de sommieR peut échouer deux fois de suite à l'installation des dépendances (apt, 30 min) sans qu'aucun test tourne ; relancer est la bonne réponse, et le bilan dira si la CI doit mettre ses dépendances en cache
- bilan du 2026-11-18 · carte entièrement tranchée (21 liens relus dans le code, un seul en attente de sommieR), 14 projets dont sommieR et `sylvostation` pilotés, sept projets aux fusions prouvables · pour Pascal et l'orchestrateur · au bilan précédent la carte gardait six liens douteux ; elle ne désigne plus d'aval qui n'en est pas un ; mais aucun changement réel n'a encore descendu la chaîne (aucune release de `nemeton` depuis le cycle 4)
- cycle 8 · la CI de sommieR ne perd plus 12 à 30 min avant le premier test (installation des dépendances R sous 40 s, tests en 4 min 41 s au lieu de 28 min) ; la mémoire de la plateforme est écrite là où elle fait foi (README, convention de fusion par dépôt dans la carte) · pour Pascal et l'orchestrateur · une PR de sommieR est prouvée verte en minutes ; mauvaise nouvelle apprise : un gain mesuré sur une seule étape peut cacher un temps déplacé dans une autre, c'est la durée totale du job qui compte ; et `Setup R` reste lent, hors de portée du workflow
- cycle 9 · 13 missions (014 à 026) fusionnées ; tests de contrat sur les trois liens de code de `nemeton` (vers sommieR, nemetonshiny, nemetonmcp) ; nemetonmcp suit `nemeton` 2026.11.32-34 ; sommieR de 0.38 à 0.43 (réalisé des travaux vers nemetonshiny, photos, symbologie, ortho MBTiles) · pour Pascal et le terrain · mauvaise nouvelle apprise : base de test commune entre sessions, `journal_intact` refuse le rattrapage de `main` par merge (4 PR remplacées), et la spec de l'aval doit être lue avant de coder
- bilan du 2026-11-19 (partiel, deux décisions de Pascal) · règle d'import « accepter et signaler, refuser seulement l'illisible » (mission 027) ; hébergeur du connecteur distant : Hostinger · pour Pascal et le terrain · aucune ligne de livraison n'avait été écrite à ce bilan (trou relevé le 2026-11-20)
- bilan du 2026-11-20 · sommieR de 0.38 à 0.44 sur les briefs du terrain (réalisé des travaux, photos, ortho sans réseau dans QField, import qui ne bloque plus la tournée) et contrats de `nemeton` testés · pour Pascal sur le terrain · au bilan du 2026-11-18 aucun changement réel n'avait descendu la chaîne ; cette fois des changements réels sont arrivés jusqu'aux applications de terrain
- cycle 10 · sommieR v2026.11.2 lit les comptages de plants à l'import (décision du bilan arrivée en release le jour même) et passe aux versions calendaires ; `terrain` porte l'heure UTC du fix pour Groma (v0.8.0 à taguer) ; le pilotage se reprend depuis le dépôt seul (`pilotage/outils/`, contrôle de charge) · pour Pascal sur le terrain et un successeur · mauvaise nouvelle apprise : la lecture des comptages ne sert à rien tant que Surculus n'écrit pas les deux colonnes ; le lanceur ne créait pas la base de la mission ; un disque saturé par une autre session retient tout le cycle
- cycle 12 · Groma 2026.11.9 · le forestier qui fait l'inventaire vidéo · première version de Groma sur la bibliothèque GNSS commune de terrain (v2026.11.1, heure UTC du fix), sans changement de fichier ni d'écran ; la livraison du cycle 11 était la bibliothèque elle-même
