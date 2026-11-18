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

**Dernier cycle :** 8 _(augmenté de 1 à la fin de chaque `/boucle`, même quand elle n'a
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

## Terminé

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
