# ADR-013 — Suivi sanitaire multi-méthodes : FAST + FORDEAD (résineux) + RECONFORT (feuillus), avec garde-fous applicatifs

**Statut** : Accepté
**Date**   : 2026-04-26 (initial) — amendements A1 (2026-05-16), A2 (2026-05-16), A3 (2026-05-20), A4 (2026-06-10), A5 (2026-06-18)
**Auteur** : Pascal Obstétar (via Claude)
**Cible initiale** : `nemeton` v0.21.0
**Livraisons réelles** : `nemeton` v0.21.0 (E6.c.1-4 + E6.d) → v0.23.0 (A1 migration fordead 2.x) → v0.24.0 (A2 refonte signature) → v0.42.0 (A3 L1 bundle diagnostic) → v0.43.0 (A3 L2 `read_fordead_pixel_series()`) ; `nemetonshiny` v0.31.0+ (modules suivi sanitaire), v0.42.0 (basculement raster spec 013)
**Amendement A4** : paperwork seul à ce jour (2026-06-10), cible `nemeton` v0.68.0+ (RECONFORT, lots L1→L5 de spec 021) — non encore livré
**Note titre** : l'intitulé initial (« Méthode officielle … : FORDEAD ») est reframé par A4 en « suivi sanitaire **multi-méthodes** » — FORDEAD reste la méthode officielle pour les **résineux**, RECONFORT devient la méthode officielle pour les **feuillus** (routage par essence). Voir A4.
**Précédents pertinents** : ADR-008 (souveraineté UE), ADR-009 (séparation cœur/app), ADR-011 (NDP augmenté), ADR-012 (extensions PG futures — TimescaleDB, pgvector)
**Source historique** : porté depuis `nemeton/specs/008-suivi-sanitaire/ADR-013-suivi-sanitaire-fordead.md` (2026-05-25)

---

## Contexte

Le chantier E6 a été initialement spécifié (spec 007) comme un « monitoring forestier continu » générique fondé sur des baisses brutales de NDVI/NBR détectées dans une fenêtre roulante de 30 jours. La phase squelette (E6.a, livrée en v0.20.0) a montré que cette approche est légitime pour détecter des **chocs récents** (coupes, chablis, incendies) mais n'a pas la précision sémantique pour répondre à la question métier centrale : *« mes peuplements résineux dépérissent-ils ? »*

La filière forestière française (ONF, IGN, INRAE/CIRAD) a déjà standardisé une méthode dédiée à cette question : **FORDEAD** (Boissieu et al. 2024, GPL-3), qui modélise la phénologie de l'indice **CRSWIR** par pixel sur une période de référence saine, puis détecte les anomalies confirmées par 3 acquisitions consécutives au-delà d'un seuil (0.16 par défaut).

Une étude de validation terrain conduite par l'ONF / Département de la Santé des Forêts en automne 2023 (Bernard & Doridant 2024, 397 relevés sur Vosges, Jura, Alpes du Nord, Massif Central) a quantifié les performances et les limites :

- Bonne détection (>80%) sur la classe **3-forte anomalie** ;
- Détection raisonnable (70%) sur la classe **4-sol nu**, mais sans distinction interne entre coupe rase et dépérissement avancé ;
- **Taux élevé de faux positifs** sur les classes **1-faible** (~50%) et **2-moyenne** (~37%) ;
- **Détection précoce médiocre** : ~60% des stades précoces (« scolyte vert ») non détectés ;
- **Confusion dépérissement / perturbation mécanique** : 25% des trouées-chablis, 38% des interventions sylvicoles récentes, 41% des casses de cime apparaissent comme anomalies FORDEAD ;
- **Validité géographique restreinte** (massifs résineux du Nord-Est et Alpes du Nord), **validité essences restreinte** (épicéa commun, sapin pectiné).

La modification du seuillage d'anomalie *« n'a pas d'effet réel sur les performances »* selon le rapport — citation directe — donc on ne peut pas régler le problème de calibration en jouant sur les paramètres.

---

## Décision

### 1. Méthode officielle de suivi sanitaire : FORDEAD

`nemeton` adopte FORDEAD comme méthode canonique pour le diagnostic sanitaire des peuplements résineux.

**Paramétrage par défaut** :

- Indice : **CRSWIR**
- Période d'entraînement : **2 ans** (2016-2017 par défaut, configurable)
- Seuil d'anomalie : **0.16**
- Confirmation : **3 anomalies consécutives**
- Masque forêt : **BD Forêt v2 IGN** (FR), avec possibilité de fournir un masque tiers

Ces valeurs sont alignées sur le paramétrage validé par le rapport ONF/DSF 2024 et ne sont **pas exposées à l'utilisateur final** dans la première version (v0.21.0). Une re-calibration éventuelle se fera par ADR ultérieur, à partir de nouvelles études de validation.

### 2. Stratégie hybride : FORDEAD ⨯ rolling-window

`nemeton` conserve le pipeline rolling-window NDVI/NBR (E6.a, v0.20.0) comme **deuxième méthode complémentaire**, dédiée à la détection des **chocs récents** (coupes, chablis, incendies). Les deux pipelines alimentent la même table `alert` (TimescaleDB) avec un champ `alert_type` discriminant.

Une fonction de fusion `classify_disturbance()` combine les deux signaux pour qualifier chaque alerte FORDEAD :

- FORDEAD ∩ rolling-window (±30 j) → `disturbance_type = "mechanical"` (coupe, chablis, casse de cime)
- FORDEAD seul → `disturbance_type = "progressive"` (dépérissement scolyte/sécheresse, signal qualifié)
- Rolling-window seul → `disturbance_type = "recent_event"` (événement récent sans signe antérieur de dépérissement)

Cette fusion est la mitigation directe du finding ONF sur la confusion dépérissement / perturbation mécanique. Elle constitue une valeur ajoutée propre à `nemeton` qui n'existe ni dans FORDEAD seul ni dans un rolling-window seul.

### 3. Cinq garde-fous applicatifs obligatoires

Traduction directe des limites identifiées dans le rapport ONF/DSF 2024 :

#### G1 — Filtrage par défaut classes 3-forte + 4-sol-nu

Les classes **1-faible** et **2-moyenne**, dont le rapport montre qu'elles produisent 50% et 1/3 de faux positifs respectivement, ne sont **pas affichées par défaut** dans l'interface ni utilisées dans le calcul de l'indicateur R5. L'utilisateur peut les activer via une option avancée, mais une bannière d'avertissement explicite l'informe alors du taux de faux positifs élevé.

#### G2 — Fusion rolling-window × FORDEAD

cf. point 2 ci-dessus.

#### G3 — Avertissements géographiques et essences

Une couche `inst/extdata/fordead_validity_zones.geojson` matérialise les départements où la calibration FORDEAD est validée par le rapport ONF (Vosges, Jura, Ain, Savoie, Haute-Savoie). Quand l'AOI projet n'intersecte pas cette couche à plus de 50%, ou quand la composition d'essences (BD Forêt v2) n'atteint pas 70% d'épicéa+sapin pectiné, l'interface affiche des bannières d'avertissement explicites, et l'utilisateur doit confirmer pour lancer le calcul.

#### G4 — Workflow de validation terrain par QField

Toute alerte FORDEAD est créée en statut `pending` et passe par un cycle de vie (`pending → confirmed | false_positive | closed`) alimenté par un workflow de saisie terrain QField, **réutilisant l'infrastructure E5.b**. Le schéma de saisie est aligné sur la nomenclature du rapport ONF (codes Sain, Scolyte_vert, Scolyte_rouge, Scolyte_gris, etc.) pour interopérabilité avec les bases DSF existantes.

L'objectif de ce garde-fou est d'institutionnaliser le couplage humain-machine que le rapport ONF identifie comme indispensable : *« couplée à l'expertise des correspondants-observateurs ».*

#### G5 — Indicateur R5 dépérissement pondéré par confiance

Un nouvel indicateur **R5** rejoint la famille R (Risques) du radar nemeton, calculé avec une pondération directement issue des taux de bonne détection observés sur le terrain :

```
R5(UGF) = Σ surface(classe_k, UGF) × FORDEAD_CONFIDENCE_WEIGHTS[k] / surface(UGF)

FORDEAD_CONFIDENCE_WEIGHTS <- c(
  "1-faible"  = 0.10,
  "2-moyenne" = 0.30,
  "3-forte"   = 0.82,
  "4-sol-nu"  = 0.70
)
```

R5 retourne **NA** quand l'UGF :
- contient moins de 30% de résineux (BD Forêt v2),
- ou n'intersecte pas une zone de validité géographique,
- ou n'a pas été couverte par un run FORDEAD.

### 4. Architecture d'intégration

- **Frontière R/Python** : FORDEAD est appelé via `reticulate` dans un environnement virtuel isolé (`~/.virtualenvs/nemeton-fordead/`), créé idempotemment au premier appel. Les dépendances Python sont figées dans `inst/python/requirements.txt`.
- **Licence** : FORDEAD est sous GPL-3. L'appel via reticulate est un appel runtime (RPC), pas un linking statique. `nemeton` reste sous MIT, FORDEAD est référencé dans `Suggests` (dépendance optionnelle) et attribué dans `inst/NOTICE`.
- **Frontière cœur/app** (ADR-009 préservé) : toute la logique métier (pipeline, post-processing, R5, schémas de saisie, ingestion validation) vit dans le package `nemeton`. Le package `nemetonshiny` est purement présentationnel (UI mode toggle, bannières, plotly, leaflet, async wrapper).

### 5. Persistance des limites dans le code et la documentation

- Les coefficients de confiance et leurs justifications citent **explicitement le rapport ONF/DSF 2024** dans les commentaires de code.
- La spec 008 §4.5 documente les 8 limites (§4.5 du présent ADR).
- L'interface affiche systématiquement la classe d'anomalie et le `stress_index` à côté de chaque alerte, pour que l'utilisateur ne perde jamais de vue le niveau de confiance.
- Le profil expert LLM `gestionnaire_onf` est enrichi d'instructions de prudence dans son prompt (rappel systématique de la classe, des sources de faux positifs, de la nécessité de vérification terrain).

---

## Conséquences

### Positives

- **Crédibilité scientifique** : le projet s'appuie sur la méthode validée et utilisée par la communauté forestière française (ONF, IGN, INRAE/CIRAD, DSF).
- **Documentation des limites** : les utilisateurs sont prévenus, le risque de mauvaise interprétation est minimisé.
- **Valeur ajoutée propre** : la fusion FORDEAD × rolling-window n'existe nulle part ailleurs et résout directement la principale source de bruit identifiée par le rapport.
- **Boucle terrain** : la validation QField institutionnalise le couplage humain-machine.
- **Extensibilité** : les coefficients vivent dans une constante R, faciles à ré-évaluer quand de nouvelles études paraîtront.

### Négatives / coûts

- **Dépendance Python** : ajoute une complexité opérationnelle (gestion de venv, debugging cross-langage). Mitigation : helpers reticulate idempotents + messages d'erreur explicites + `Suggests` (dégradation propre quand absent, rolling-window reste utilisable).
- **Coût d'exécution** : FORDEAD prend 2-4 minutes par parcelle, 30-90 min par massif. Mitigation : ExtendedTask + future_promise pour ne pas bloquer l'UI ; communication explicite des durées attendues.
- **Validité restreinte par construction** : la méthode ne peut pas être utilisée légitimement hors épicéa/sapin et hors massifs validés. Mitigation : G3 (bannières) ; FORDEAD reste désactivable au profit du mode rapide qui n'a pas ces restrictions.
- **Calibration figée à v0.21.0** : pas de re-calibration par l'utilisateur. Mitigation : explicite dans la doc ; ADR ultérieur si besoin.

### Risques résiduels acceptés

- L'algorithme FORDEAD reste un **outil d'aide à la décision**, pas un outil de prédiction quantitative. Il ne doit **pas** être utilisé pour produire des estimations de volumes ou de pertes économiques. Cela est explicite dans la doc et dans les disclaimers UI.
- La **détection précoce reste médiocre** (60% des stades précoces non détectés). Mitigation : bandeau d'information dans l'UI, le mode sanitaire complète mais ne remplace pas les inventaires terrain réguliers.

---

## Alternatives considérées et écartées

### A. Tout fordead, pas de rolling-window

**Pour** : architecture plus simple, une seule méthode officielle.
**Contre** : ne distingue pas dépérissement vs perturbation mécanique (problème central du rapport ONF). L'utilisateur perdrait la capacité de détecter rapidement coupes/chablis/incendies. Le travail E6.a (v0.20.0) deviendrait du throwaway.
**Verdict** : rejeté.

### B. Rolling-window uniquement

**Pour** : zéro dépendance Python, zéro problème de calibration, zéro restriction géographique.
**Contre** : aucune valeur scientifique pour le suivi sanitaire à proprement parler. Faux positifs garantis sur les transitions saisonnières. Pas adapté à la question métier centrale.
**Verdict** : rejeté.

### C. Méthode ML maison (Bárta 2021, Deepak 2024)

**Pour** : possibilité de mieux faire que le seuillage harmonique, suggéré en conclusion du rapport ONF.
**Contre** : effort R&D massif, calibration locale nécessaire, pas dans l'état de l'art francophone reconnu, pas d'écosystème.
**Verdict** : reporté en V+1, listé en §10 de la spec 008.

### D. Fork de FORDEAD avec ré-implémentation R native

**Pour** : éliminer la dépendance Python.
**Contre** : maintenance lourde, divergence inévitable du upstream, redéveloppement de xarray/dask en R.
**Verdict** : rejeté (rapport coût/bénéfice catastrophique).

---

## Mise à jour à prévoir dans la documentation projet

- **CLAUDE.md** : mise à jour de la table des familles d'indicateurs (R passe à R1-R5 quand FORDEAD a tourné), ajout du `contexte_sante` dans les Bounded Contexts, ajout de l'ADR-013 dans la liste.
- **PLAN.md** : reframing du chantier E6 « monitoring continu » → « suivi sanitaire », mise à jour du découpage (cf. spec 008 §1).
- **README** (cœur et app) : section « Suivi sanitaire » avec disclaimer de validité.
- **NOTICE** : attribution FORDEAD (CIRAD/INRAE, GPL-3, citation Zenodo) + attribution rapport ONF/DSF 2024 (référence d'évaluation des limites).

---

## Références

- Boissieu F, Fernandez E, Dutrieux R, Ose K, Féret J-B (2024). *fordead: a python package for vegetation anomalies detection from SENTINEL-2 images.* Zenodo. doi:10.5281/zenodo.12802456 (GPL-3)
- Bernard C, Doridant JB (2024). *Méthode FORDEAD — analyse de la validité des détections d'anomalies de végétation dans le cas des résineux par contrôle sur le terrain.* ONF / DSF, mai 2024.
- ADR-008, ADR-009, ADR-011, ADR-012 (`platform_nemeton/docs/`)
- Spec 007 (devient la couche surveillance rapide de spec 008)
- Spec 008 (`specs/008-suivi-sanitaire/`)

---

## Amendement A1 — Migration vers l'API fordead 2.x (2026-05-16, cible v0.23.0)

**Statut** : approuvé (paperwork avant code).
**Lien** : spec 008 §12, plan 008 §9, PLAN.md journal 2026-05-16.

### Contexte de l'amendement

L'ADR-013 v1 (2026-04-26) supposait fordead 1.x avec les 5 step modules `fordead.steps.step1_*..step5_*` et un format d'entrée THEIA L2A pour les scènes Sentinel-2. La cascade de patches `v0.22.2..v0.22.5` (16 mai 2026) a révélé :

1. **Kwargs incorrects** dans `R/fordead_pipeline.R` (e.g. `vegetation_index` au lieu de `vi`, `input_directory` au lieu de `data_directory`).
2. **Aucun pont** entre notre cache STAC COG (sortie de `ingest_sentinel2_timeseries()`) et le format THEIA L2A attendu par fordead 1.x.
3. **Tests mockés complaisants** (44 tests offline) qui n'ont jamais touché un vrai fordead. La double dérive est passée inaperçue jusqu'à la première exécution réelle par l'utilisateur final.

Bilan : le pipeline FORDEAD livré en `v0.21.0` était techniquement non-fonctionnel. R5 dépendant de FORDEAD n'a donc jamais produit de valeur non-NA en pratique. Spec 008 §6 G5 (R5 pondéré) reste valide, mais nécessite un pipeline FORDEAD qui marche réellement.

### Décision

**Migrer vers fordead 2.x** (`@v2.1.1`, pin git+gitlab.com).

Justification courte :

- **fordead 2.x accepte une `simplestac.ItemCollection` directement** via `fordead.workflow.FordeadProcess(collection, output_dir, bbox, geometry, config=FordeadConfig())`. C'est exactement le format de notre cache. Plus de gap STAC ↔ THEIA à combler.
- **API unifiée** : une classe `FordeadProcess` avec `fit()` puis `predict()`, au lieu de 5 modules dispersés.
- **Calibration ONF/DSF préservée** : tous les défauts de `FordeadConfig()` (CRSWIR, 0.16, 3 anomalies, 2-ans training) correspondent exactement aux valeurs ADR-013. Aucune dérive métier.
- **Active branch** : fordead 1.x est en maintenance. La 2.x est la branche de développement INRAE/CNES.

### Ce que cet amendement modifie dans ADR-013 v1

| Décision ADR-013 v1 | Statut après A1 |
|---------------------|-----------------|
| §1 Méthode officielle = FORDEAD | ✅ inchangé |
| §2 Stratégie hybride FORDEAD ⨯ rolling-window | ✅ inchangé |
| §3 G1 — classes 3-forte + 4-sol-nu par défaut | ✅ inchangé. Le mapping (raster fordead → classes 1-4) est ajusté dans plan 008 §9.3 mais le résultat métier est le même. |
| §3 G2 — fusion rolling-window × FORDEAD | ✅ inchangé (logique SQL côté `classify_disturbance()`, indépendante de la version fordead) |
| §3 G3 — bannières géo + essences | ✅ inchangé |
| §3 G4 — workflow validation QField | ✅ inchangé |
| §3 G5 — R5 pondéré par confiance, weights `(0.10, 0.30, 0.82, 0.70)` | ✅ inchangé (`R/indicators-deperissement.R` intact). Les poids restent calibrés sur le rapport ONF/DSF 2024. |
| §4 Architecture (reticulate + fordead Python) | 🟨 **modifié** : `reticulate::import("fordead")` (top-level) au lieu de `import("fordead.steps")`. Voir plan 008 §9.2. |
| §5 Persistance des limites dans code et doc | ✅ inchangé. La calibration reste figée v0.23.0 sur les défauts 2.x (qui matchent ONF/DSF). |

### Ce que cet amendement ajoute

- **Une couche STAC assembly côté R** (`.build_stac_collection_for_aoi()`) qui transforme notre cache disque `<cache_dir>/{scene_id}/{band}.tif` en `pystac.Item[]` consommable par `FordeadProcess`. Cette couche n'existait pas en v1 (où fordead 1.x était supposé manger des SAFE folders qu'on n'a jamais).
- **Tests d'intégration `skip_if_no_fordead()`** (≥ 2) qui touchent réellement le venv fordead 2.x, pour qu'une dérive de signature soit attrapée en CI/dev plutôt qu'à l'exécution prod.
- **Documentation explicite** que `run_fordead_dieback(cache_dir = ...)` devient quasi-obligatoire : sans cache local, les hrefs PC SAS expirent pendant `fit()` long-running (cf. v0.22.1). Avec cache, on passe des paths locaux à `pystac.Asset(href = ...)` → pas de problème d'expiration.

### Conséquences

**Positives (au-delà du fix correctness)** :
- Le pipeline devient testable end-to-end (les tests intégration cassent si le mapping change).
- Pas de fork de fordead à maintenir (alternative D de ADR-013 v1 reste rejetée — la 2.x suit notre besoin).
- Calibration ONF/DSF est désormais documentée comme "défaut fordead 2.x" — donc plus stable face à un futur changement de paramètres dans 2.x (si INRAE/CNES bouge, on bougera avec, après revue).

**Coûts** :
- Travail de migration : ~18 h (plan 008 §9.6).
- Régénération du fixture des alertes pour `test-indicators-deperissement.R` (mapping confidence_class § 9.3).
- Wiring `nemetonshiny@v0.32.0` à venir (noms de phases changent : `vegetation_index → fit / predict`).

**Risque résiduel accepté** : `simplestac` est pin git-only (forge.inrae.fr/umr-tetis). Si la forge INRAE est down au moment d'un install, ça échoue. Identique au risque fordead lui-même (gitlab.com). Pas de mitigation locale ; documenté.

### Historique des décisions sur le pin fordead

| Date | Tag | Justification |
|------|-----|---------------|
| 2026-04-26 | (spec 008 v1) | « fordead 2.1.x » mentionné sans vérification. |
| 2026-04-29 | (E6.c.1 livré) | `fordead==2.1.4` dans `requirements.txt`. Version inexistante (PyPI 404 par dessus le marché). |
| 2026-05-15 (v0.22.2) | `git+gitlab@v2.1.1` | Fix install : fordead n'est pas sur PyPI, on bascule sur git+gitlab. Latest 2.x tag = v2.1.1. |
| 2026-05-15 (v0.22.5) | `git+gitlab@v1.11.4` | Découverte du mismatch d'API : pipeline R écrit pour 1.x, downgrade au dernier 1.x stable. |
| 2026-05-16 (v0.23.0, amendement A1) | `git+gitlab@v2.1.1` | Migration propre : 2.x accepte notre STAC natif. Réécriture du pipeline R. Approche endorsed. |

### Tests de validation de A1

Avant clôture v0.23.0 :

1. `Rscript -e 'devtools::test(filter = "fordead")'` → tous tests verts, dont les nouveaux `test-fordead-integration.R` quand fordead est dispo.
2. AOI de référence (≤ 1 km², Vosges) — `run_fordead_dieback()` termine en `status = "success"`, `rasters$state` ouvert avec `terra::rast()` sans erreur.
3. R5 calculé sur une zone avec FORDEAD réel — valeur dans `[0, 100]`, status = `"calculated"`.

Ces checks sont aussi listés en spec 008 §12.7 (AC.12.1-12.5).

---

## Amendement A2 — Intégration FORDEAD ↔ ingest FAST (2026-05-16, cible v0.24.0)

**Statut** : approuvé (paperwork avant code).
**Lien** : spec 008 §13, plan 008 §10, PLAN.md journal 2026-05-16.

### Contexte de l'amendement

L'amendement A1 (v0.23.0, livré le 2026-05-16) a sorti FORDEAD du gouffre 1.x / THEIA en migrant sur l'API `FordeadProcess` 2.x. À la **première utilisation app** (même jour), trois frictions sont apparues, toutes à la frontière entre le pipeline FAST (rolling-window NDVI/NBR) et le pipeline FORDEAD :

1. **L'app a `con + zone_id` mais pas `scenes_df`**. Le scene_id Sentinel-2 est consommé pendant l'ingest FAST puis non persisté en DB (`obs_pixel` est indexée par `(plot_id, obs_date, band)`). La signature v0.23.0 forçait l'app à walker le cache disque pour reconstituer `scenes_df` — duplication de logique côté présentation.
2. **FAST et FORDEAD partagent déjà le `cache_dir`** (`{projet}/cache/layers/sentinel2/`) mais FORDEAD n'utilise pas le downloader de FAST. Si FAST a tourné avec ses 3 bandes (B04, B08, B12) avant que l'utilisateur n'enchaîne sur FORDEAD, les 4 bandes additionnelles (B02, B05, B8A, B11) manquent — `.build_stac_collection_for_aoi()` skip toutes les scènes avec un warning agrégé, pipeline blocking sans message clair.
3. **Aucun pont entre les deux pipelines**, alors qu'ils visent la même donnée d'entrée et le même cache. `ingest_sentinel2_timeseries()` est *partial-coverage-aware* depuis v0.21.3 (skip_cached vérifie `obs_pixel` band-par-scène) : appelée avec la liste FORDEAD complète et `skip_cached = TRUE`, elle ne descend que les bandes manquantes.

### Décision

**Refondre la signature publique** de `run_fordead_dieback()` pour qu'elle prenne `con + zone_id + cache_dir` (au lieu de `aoi + scenes_df + cache_dir`) **et** ajouter une phase 0 d'ingest interne qui délègue à `ingest_sentinel2_timeseries()`.

Justification courte :

- **Une seule porte d'entrée** côté app : tout est connu par `(con, zone_id, cache_dir)`. Le pipeline devient invocable depuis un bouton Shiny sans glue code.
- **Réutilisation totale du downloader FAST** : pas de duplication, partial-coverage gratuit, plus de race condition cache.
- **Cohérence d'événements** : `s2:*` et `fordead:*` se superposent dans le même `progress_callback` — l'app affiche déjà les toasts FAST depuis `nemetonshiny@v0.32.0`, donc 0 dev UI pour le feedback ingest.
- **Breaking change assumé** : il n'y a qu'un seul caller (`nemetonshiny`). La migration est triviale (cf. spec 008 §13.8).

### Ce que cet amendement modifie dans ADR-013 (post-A1)

| Décision après A1 | Statut après A2 |
|-------------------|-----------------|
| §1 Méthode officielle = FORDEAD | ✅ inchangé |
| §2 Stratégie hybride FORDEAD ⨯ rolling-window | ✅ inchangé — A2 rapproche les deux pipelines côté exécution, mais la logique de fusion (G2) reste identique. |
| §3 G1 — classes 3-forte + 4-sol-nu par défaut | ✅ inchangé |
| §3 G2 — fusion rolling-window × FORDEAD | ✅ inchangé (logique SQL côté `classify_disturbance()`) |
| §3 G3 — bannières géo + essences | ✅ inchangé |
| §3 G4 — workflow validation QField | ✅ inchangé |
| §3 G5 — R5 pondéré, weights `(0.10, 0.30, 0.82, 0.70)` | ✅ inchangé |
| §4 Architecture reticulate + STAC assembly | 🟨 **complété** : pipeline `run_fordead_dieback()` passe de 5 phases (v0.23.0) à 6 phases (v0.24.0). La nouvelle phase 0 `ingest` délègue à `ingest_sentinel2_timeseries()`. Voir plan 008 §10.2. |
| §5 Persistance des limites dans code et doc | ✅ inchangé. Calibration toujours figée sur défauts fordead 2.x. |
| A1 §1 STAC assembly côté R | ✅ inchangé. Le helper `.build_stac_collection_for_aoi()` reste, ré-utilisé par phase 1. |

### Ce que cet amendement ajoute

- **Une phase 0 d'ingest interne** dans `run_fordead_dieback()` qui appelle `ingest_sentinel2_timeseries()` avec `bands = FORDEAD_BANDS` et `skip_cached = TRUE`. Garantit que le cache contient les 6 bandes nécessaires avant la phase STAC assembly.
- **Une constante exportée `FORDEAD_BANDS`** (`c("B02","B04","B05","B8A","B11","B12")`) — matérialise publiquement la liste de bandes spécifique à fordead 2.x (CRSWIR + masques), différente du triplet FAST (B04, B08, B12).
- **Un helper `.get_zone_aoi(con, zone_id)`** qui dérive l'AOI sf depuis la table `monitoring_zone`. Erreur typée via `cli::cli_abort()` si zone_id inconnu.
- **Tests offline mockés** : 4 nouveaux tests sur l'ordre des phases, la propagation des événements `s2:*`, et la gestion d'erreur sur zone_id manquant.

### Ce que cet amendement RETIRE de l'API publique

- ❌ `aoi` — dérivé de `monitoring_zone.aoi` via `.get_zone_aoi()`.
- ❌ `scenes_df` — retourné par l'ingest interne, plus à fabriquer par le caller.
- ❌ `forest_mask` — déjà deprecated en v0.23.0, supprimé définitivement.

Breaking change pour `nemetonshiny` (un seul caller). Migration documentée spec 008 §13.8.

### Conséquences

**Positives** :
- L'app devient invocable depuis un bouton "Lancer FORDEAD" sans logique de cache ou de scenes côté UI.
- Plus de race condition possible entre cache FAST et cache FORDEAD — c'est le même cache, géré par le même downloader.
- Régression future sur le partial-coverage de l'ingest serait détectée par les tests FORDEAD, ce qui augmente la couverture indirecte.

**Coûts** :
- Travail de migration : ~7 h (plan 008 §10.8).
- Breaking change côté `nemetonshiny@v0.33.0` (1 call site).
- Nouvelle clé i18n `monitoring_fordead_phase_ingest` à ajouter côté app.

**Risque résiduel accepté** : la phase 0 ingest peut être longue si beaucoup de bandes manquent (4 bandes × N scènes). Mitigé par les événements `s2:scene_cached` / `s2:band_fetched` qui passent au `progress_callback` — l'utilisateur voit ce qui descend en temps réel.

### Tests de validation de A2

Avant clôture v0.24.0 :

1. `Rscript -e 'devtools::test(filter = "fordead")'` → tous tests verts, dont les 4 nouveaux tests `test-fordead-pipeline.R` (ordre phases, propagation `s2:*`, zone_id inconnu, `FORDEAD_BANDS` contenu).
2. AOI de référence (zone de prod de l'utilisateur, Vosges) — `run_fordead_dieback(con, zone_id, cache_dir, ...)` termine en `status = "success"` sans intervention manuelle (AC.13.1).
3. `diagnose_s2_cache()` avant et après — nombre de bandes par scène passe de 3 (FAST) à 6+ (union FAST ∪ FORDEAD) (AC.13.2).
4. Re-lancement immédiat sur la même zone — domination des événements `s2:scene_cached` dans les logs (AC.13.3).

Ces checks sont aussi listés en spec 008 §13.7 (AC.13.1-13.6).

## Amendement A3 — Persistance du modèle harmonique pour le diagnostic pixel (2026-05-20, cible v0.42.0–v0.43.0)

**Statut** : approuvé (paperwork avant code).
**Lien** : spec 008 §14, PLAN.md journal 2026-05-20.

### Contexte de l'amendement

La Carte FORDEAD de l'app n'affiche que le masque catégoriel 0-4 ; un clic n'y déclenche rien. La Carte pixel FAST (spec 010), elle, offre un diagnostic au clic — série temporelle NDVI/NBR en modal plotly. Le forestier réclame l'équivalent FORDEAD : voir, pour un pixel flaggé, le **signal CRSWIR observé**, la **courbe du modèle harmonique** et le **seuil d'anomalie** qui a déclenché la détection.

Ces bornes ne peuvent pas être recalculées côté R : ADR-013 §1 fait de FORDEAD la méthode officielle, et l'alternative D (fork / ré-implémentation R) a été explicitement écartée. Les bornes affichées doivent donc être *celles du run FORDEAD réel*. Or le working set FORDEAD (CRSWIR, `coeff_model`, masques) vit dans un `output_dir` temporaire effacé en fin de session — seul le masque 0-4 est persisté (v0.41.0). Sans persistance du modèle harmonique, le diagnostic pixel est impossible.

### Décision

**Persister un bundle diagnostic curé** à la fin du run FORDEAD, et **exposer une API de lecture** qui reconstruit la prédiction harmonique par parité stricte avec FORDEAD.

Justification courte :

- **Fidélité méthodologique** : les bornes proviennent du `coeff_model` réellement fitté par FORDEAD — pas d'une 2ᵉ implémentation. Cohérent avec ADR-013 §1 et le rejet de l'alternative D.
- **Empreinte maîtrisée** : on ne persiste pas les ~1000 rasters du working set, mais un bundle curé (`coeff_model` 5 bandes, stack CRSWIR masqué, `first_anomaly`, `run_meta.json`) — quelques Mo. `keep_output = TRUE` reste l'option « tout garder ».
- **Parité par reticulate** : la prédiction est calculée en appelant `fordead.modeling.HarmonicModel` (Python), pas une base harmonique réécrite en R. Zéro risque de dérive.
- **Best-effort** : la persistance du bundle, comme le persist-hook du masque (v0.41.0), `warn` en cas d'échec mais n'aborte jamais le run.

### Ce que cet amendement modifie dans ADR-013 (post-A2)

| Décision après A2 | Statut après A3 |
|-------------------|-----------------|
| §1 Méthode officielle = FORDEAD | ✅ inchangé — A3 renforce le principe : la viz consomme les sorties FORDEAD, ne les recalcule pas. |
| §2 Stratégie hybride FORDEAD ⨯ rolling-window | ✅ inchangé |
| §3 G1-G5 (garde-fous, R5, weights) | ✅ inchangé |
| §4 Architecture reticulate + STAC assembly | 🟨 **complété** : la phase `persist` écrit en plus un bundle modèle ; un nouveau lecteur cœur `read_fordead_pixel_series()` rappelle `fordead.modeling` via reticulate pour la prédiction. Pas de nouvelle phase pipeline (6 phases, A2, inchangé). |
| §5 Persistance des limites dans code et doc | ✅ inchangé — A3 persiste des *artefacts de run*, distincts des *limites de calibration* figées du §5. |
| A1 §1 STAC assembly côté R | ✅ inchangé |
| A2 — signature `con + zone_id + cache_dir`, 6 phases | ✅ inchangé |

### Ce que cet amendement ajoute

- **Un bundle diagnostic persistant** écrit par la phase `persist` sous `<mask_cache_dir>/zone_<id>/model_<run_id>/` : `coeff_model.tif`, `crswir_stack.tif`, `first_anomaly.tif`, `run_meta.json` (cf. spec 008 §14.3). Best-effort.
- **Une fonction de lecture exportée `read_fordead_pixel_series(con, zone_id, xy, crs, run_id, cache_dir)`** — retourne la série CRSWIR observée + prédite + seuil + flag d'anomalie d'un pixel, sur le modèle de `read_fordead_dieback_mask()` et `extract_pixel_timeseries()` (cf. spec 008 §14.4).
- **La reconstruction de la prédiction harmonique via reticulate** (`fordead.modeling.HarmonicModel`), garantissant la parité avec le run (cf. spec 008 §14.5).
- **Tests offline** : ≥ 8 tests (`test-fordead-pixel-series.R`) avec fixture `coeff_model` synthétique.

### Conséquences

**Positives** :
- La Carte FORDEAD devient un véritable outil de diagnostic, à parité fonctionnelle avec la Carte pixel FAST.
- Le `coeff_model` persistant ouvre la voie à d'autres usages (re-jeu de `postprocess`, comparaison de pixels, export) sans re-`fit`/`predict`.
- Les bornes affichées sont auditables : elles sont exactement celles du run, traçables via `run_meta.json`.

**Coûts** :
- Empreinte disque additionnelle : quelques Mo par run et par zone (le `crswir_stack` domine).
- Dépendance de la viz à `reticulate` + un venv FORDEAD valide au moment de la lecture (pas seulement au moment du run).
- 3 sous-livraisons (2 releases cœur + 1 app), cf. spec 008 §14.2.

**Risque résiduel accepté** : la lecture nécessite que le venv `nemeton-fordead` soit disponible côté lecteur (la prédiction harmonique passe par Python). Mitigé : le venv est déjà requis pour exécuter FORDEAD ; si un run a produit le bundle, le venv était présent. `read_fordead_pixel_series()` `warn` + retourne `NULL` proprement si le venv manque.

### Tests de validation de A3

Avant clôture des releases v0.42.0 / v0.43.0 :

1. `Rscript -e 'devtools::test(filter = "fordead")'` → tous tests verts, dont les ≥ 8 nouveaux tests `test-fordead-pixel-series.R`.
2. Après un run réel (zone Mouthe), `<mask_cache_dir>/zone_<id>/model_<run_id>/` contient les 4 artefacts du bundle (AC.14.1).
3. `read_fordead_pixel_series()` sur un pixel connu — `crswir_pred` égale (tolérance 1e-6) la prédiction de `fordead.modeling.HarmonicModel` sur les mêmes coefficients (AC.14.2).
4. Cohérence `anomalie` ⨯ masque 0-4 : un pixel classe ≥ 1 a au moins une date `anomalie = TRUE` (AC.14.4).
5. Persistance best-effort : `model_dir` non inscriptible → `warn`, run `status = "success"` (AC.14.5).

Ces checks sont aussi listés en spec 008 §14.7 (AC.14.1-14.8).

---

## Amendement A4 — Suivi sanitaire multi-méthodes : RECONFORT pour les feuillus (2026-06-10, cible v0.68.0+)

**Statut** : approuvé (paperwork avant code).
**Lien** : spec 021 (`specs/021-suivi-sanitaire-reconfort/plan.md`), source amont vérifiée (clone Framagit `fl.mouret/reconfort`, `main` 25198c9).

### Contexte de l'amendement

ADR-013 (et A1-A3) a verrouillé une chaîne de diagnostic **résineux** : FORDEAD est validé sur épicéa commun + sapin pectiné, sur les massifs du Nord-Est et des Alpes du Nord (rapport ONF/DSF 2024). La spec 008 a explicitement laissé les **feuillus hors-scope** (§1.4, §4.5 limite 5) : *« Détection sur essences feuillues (FORDEAD non validé sur feuillus) ».* C'est un trou de domaine assumé, pas un oubli — FORDEAD n'a tout simplement pas de calibration feuillus.

Une méthode dédiée existe désormais pour combler ce trou : **RECONFORT** (Mouret et al. 2023, *IEEE J-STARS*, doi:10.1109/JSTARS.2023.3332420 ; CESBIO / Université d'Orléans / programme SYCOMORE, financement Région Centre-Val de Loire). C'est une **classification supervisée Random Forest** (≠ FORDEAD qui s'auto-calibre par pixel) entraînée sur le dépérissement du **chêne**, étendue au **châtaignier** et au **pin sylvestre**, en région **Centre-Val de Loire**. Elle exploite deux indices Sentinel-2 complémentaires — **CRswir** (teneur en eau, signal discriminant) et **CRre** (chlorophylle) — sur série temporelle interpolée par la chaîne **IOTA²**.

Le dépôt amont a été cloné et lu intégralement (les 6 incertitudes de la spec 021 §10 sont tranchées sur le code source, pas sur la littérature) :

- **Licence Apache-2.0** (`LICENSE.md`) — permissive, **sans copyleft**. Différence structurante avec FORDEAD (GPL-3) : code **et** modèles redistribuables avec attribution, glue Python **vendorisable** dans le package.
- **Indices** (`iota2/external_features/custom_index.py`, formules de production *sans* offset additif) :
  - `CRswir = B11 / [ B8A + (1610−865)·(B12−B8A)/(2190−865) ]`
  - `CRre   = B5  / [ B4  + (704−665)·(B6−B4)/(741−665) ]`
  - → bandes requises `B04, B05, B06, B8A, B11, B12` (**ni B02 ni B07**).
- **Modèles** : 4 modèles Shark/OTB versionnés (`v3` chêne 2 ans / `v3_early_may` chêne 1,5 an / `v3_chestnut` / `v3_pine`), de 5,7 à 197 Mo. Redistribuables (Apache-2.0) mais **trop volumineux pour `inst/extdata/`** → téléchargement à la demande + checksum + cache.
- **IOTA² obligatoire** : `run_map_production_reconfort.py` invoque `Iota2.py` en subprocess ×2 (échantillonnage puis classification), applique le modèle via OTB/Shark. Environnement **conda** (`mamba install iota2`), pas un `requirements.txt` pip.
- **Validité** : 6 départements CVL (18/28/36/37/41/45) calibrés, mais **aucun verrou géo dans le code** (l'exemple amont tourne sur la FD Saint-Gobain, Aisne, hors CVL). Classes 1 sain / 2 dépérissant / 3 très dépérissant (chêne, châtaignier) ; 1/2 (pin). Score continu dérivé de la carte de probabilité, borné ~1..100 (0 = no-data), CRS EPSG:2154.

### Décision

**Faire passer ADR-013 de « méthode officielle FORDEAD » à « suivi sanitaire multi-méthodes »** : FAST (surveillance rapide, tout peuplement) + FORDEAD (diagnostic résineux) + **RECONFORT (diagnostic feuillus)**, avec **routage par essence dominante** de chaque UGF. Plutôt qu'un ADR-014 distinct, c'est un amendement : la stratégie hybride, les garde-fous G1-G5, la frontière cœur/app et le principe « méthode validée + garde-fous documentés » sont identiques — seul le domaine de validité s'élargit aux feuillus via une 2ᵉ méthode officielle.

Sous-décisions structurantes :

1. **Méthode officielle feuillus = RECONFORT.** FORDEAD reste officiel pour les résineux ; RECONFORT le devient pour les feuillus. Les deux ne se recouvrent pas (domaines de validité disjoints par essence).
2. **R5 unifié, routé par essence** (pas de R6 séparé). L'indicateur `indicateur_r5_deperissement()` gagne un paramètre `reconfort_results` et une logique de routage : UGF résineux + zone FORDEAD valide → R5 via FORDEAD ; UGF feuillus + zone RECONFORT valide → R5 via RECONFORT ; sinon R5 = NA. Aucun changement de la signature radar (R5 reste 0-100). Un R6 introduirait une asymétrie résineux/feuillus dans le radar que rien ne justifie côté métier.
3. **Fusion G2 étendue à 3 voies.** `classify_disturbance()` gère la co-occurrence des trois `alert_type` (`ndvi_drop`/`nbr_drop`, `fordead_dieback`, `reconfort_dieback`) : FAST seul → `recent_event` ; FORDEAD **ou** RECONFORT seul → `progressive` ; (FORDEAD ∣ RECONFORT) + FAST → `mechanical` ; FORDEAD + RECONFORT (zone mixte limitrophe) → `progressive` + drapeau `method_overlap` (signaler sans double-compter).
4. **Licence vendorisable.** RECONFORT étant Apache-2.0, la glue Python est vendorisée dans `inst/python/reconfort/` (pas un appel « contenu à la frontière reticulate » comme la GPL-3 de FORDEAD). `nemeton` reste sous MIT ; RECONFORT est attribué dans `inst/NOTICE`. Les modèles RF (Apache-2.0) sont distribués hors-package (téléchargement + checksum).
5. **IOTA²/conda** : 2ᵉ environnement reticulate dédié (`nemeton-reconfort`, conda), isolé de `nemeton-fordead`. Le code d'entraînement amont (`train_new_model/`) est **hors-scope** (aligné sur le hors-scope « pas de ré-entraînement » de spec 008 §1.4).

### Ce que cet amendement modifie dans ADR-013 (post-A3)

| Décision après A3 | Statut après A4 |
|-------------------|-----------------|
| Titre « Méthode officielle … FORDEAD » | 🟨 **reframé** en « suivi sanitaire multi-méthodes ». FORDEAD = officiel résineux ; RECONFORT = officiel feuillus. |
| §1 Méthode officielle = FORDEAD | 🟨 **généralisé** : officielle **par domaine d'essence**. FORDEAD inchangé sur son domaine (résineux). |
| §2 Stratégie hybride FORDEAD ⨯ rolling-window | 🟨 **étendu** à 3 pipelines (FAST + FORDEAD + RECONFORT). La logique reste « pipelines complémentaires, même table `alert`, `alert_type` discriminant ». |
| §3 G1 — filtrage par confiance | ✅ principe inchangé. RECONFORT filtre par probabilité RF (seuil depuis sa matrice de confusion), miroir du filtrage classes 3-4 de FORDEAD. |
| §3 G2 — fusion | 🟨 **étendu à 3 voies** (cf. décision 3). |
| §3 G3 — bannières géo + essences | 🟨 **étendu** : zones CVL + feuillus. **Nuance** : côté RECONFORT la bannière **avertit sans bloquer** (aucun verrou géo amont), là où FORDEAD demandait confirmation. Séparation feuillus/résineux par masque externe (OSO), pas par le RF. |
| §3 G4 — workflow validation QField | ✅ inchangé (réutilisé), schéma de saisie adapté aux stades de dépérissement feuillus (protocole DSF feuillus). |
| §3 G5 — R5 pondéré par confiance | 🟨 **étendu** : R5 unifié routé par essence (cf. décision 2). Poids FORDEAD `(0.10, 0.30, 0.82, 0.70)` inchangés ; poids RECONFORT distincts (`RECONFORT_CONFIDENCE_WEIGHTS`, calibrés sur la matrice de confusion RECONFORT). |
| §4 Architecture (reticulate + venv FORDEAD GPL-3) | 🟨 **complété** : 2ᵉ env conda `nemeton-reconfort` (IOTA²/Shark) ; licence amont **Apache-2.0 vendorisable** (≠ confinement GPL-3). |
| §5 Persistance des limites dans code et doc | ✅ inchangé — RECONFORT documente ses propres limites (validité CVL, supervision RF, dépendance IOTA²). |
| A1/A2/A3 (FORDEAD plumbing, 6 phases, bundle pixel) | ✅ inchangés — A4 n'altère aucune brique FORDEAD ; il ajoute une chaîne parallèle qui réutilise l'infra FAST (ingest, STAC, cache, `alert`). |

### Ce que cet amendement ajoute

- **Une 2ᵉ méthode de diagnostic officielle** (feuillus), pipeline `run_reconfort_dieback(con, zone_id, cache_dir, dates_obs, model = NULL, ...)` calqué sur `run_fordead_dieback()` (phases 0 ingest → 1 STAC → 2 features IOTA² → 3 predict RF → 4 postprocess → 5 persist).
- **Constante exportée `RECONFORT_BANDS`** `c("B04","B05","B06","B8A","B11","B12")` (parallèle à `FORDEAD_BANDS`), λ documentés.
- **Constante `RECONFORT_CONFIDENCE_WEIGHTS`** (G1/G5), calibrée sur la matrice de confusion RECONFORT.
- **Score continu RECONFORT** `(1001 + (−P1 + P2 + 2·P3))/30` (1 sain → 100 très dépérissant, 0 = no-data) → `stress_index` de la table `alert`.
- **Téléchargement de modèle** `R/reconfort_model.R` (fetch à la demande + checksum + cache + fallback chemin utilisateur), les 4 modèles ne pouvant être embarqués.
- **Couche de validité** `R/reconfort_validity.R` + `inst/extdata/reconfort_validity_zones.geojson` (6 départements CVL) — **avertit, ne bloque pas**.
- **Datasource** `reconfort_anomalies` (`FR.json`) + **flag NDP** `health_reconfort` dans `detect_ndp()` (niveau NDP et confiance φ inchangés).
- **Migration SQL additive** `0005_reconfort.sql` (réutilise `confidence_class`/`stress_index` ; index sur `alert_type = 'reconfort_dieback'` au besoin).
- **Glue Python vendorisée** `inst/python/reconfort/` (Apache-2.0) + 2ᵉ env conda `nemeton-reconfort`.

### Conséquences

**Positives** :
- **Couverture feuillus** : le projet répond enfin à la question sanitaire sur chêne/châtaignier/pin, hors-scope depuis spec 008. Crédibilité scientifique préservée (méthode publiée, calibrée régionalement).
- **Symétrie d'architecture** : RECONFORT réutilise l'infra FAST/FORDEAD (ingest partial-coverage, STAC assembly, cache, table `alert`, QField). Peu de code neuf, beaucoup de réemploi.
- **Radar cohérent** : R5 unifié routé par essence — un seul indicateur de dépérissement, quelle que soit la méthode sous-jacente (détail d'implémentation).
- **Licence plus souple** : Apache-2.0 autorise la vendorisation, simplifiant le déploiement (moins de dépendances runtime opaques que la GPL-3).

**Coûts** :
- **2ᵉ pile Python lourde** : IOTA²/conda + Shark/OTB. Complexité opérationnelle accrue (un env conda en plus du venv FORDEAD). Mitigation : env dédié idempotent, `Suggests`, dégradation propre (FAST reste utilisable sans RECONFORT).
- **Modèles hors-package** : 197 Mo × 2 → stratégie fetch+checksum+cache à maintenir, dépendance à un hébergement amont disponible.
- **Découpage en 6 lots** (spec 021 §9, L1→L6 dont l'app), ~plusieurs releases mineures.

**Risques résiduels acceptés** :
- **Validité géographique restreinte par construction** (CVL) mais **non verrouillée** : le code amont n'interdit pas l'usage hors CVL (son propre exemple le fait). La bannière G3 avertit, l'utilisateur reste responsable de l'extrapolation. Mitigation : message explicite, R5 reste NA hors essence/zone routée.
- **Supervision RF figée** : pas de ré-entraînement local (hors-scope), donc pas d'adaptation à un contexte régional non couvert sans nouveau modèle amont. Identique au principe « calibration figée » des résineux (§5).
- **Dépendance IOTA²** : chaîne lourde, orientée production batch ; un extracteur pixel-wise léger relèverait d'une R&D non validée (spec 021 §10 Q5), explicitement hors v0.68.x.

### Tests de validation de A4

Avant clôture des releases RECONFORT (spec 021 §6) :

1. `Rscript -e 'devtools::test(filter = "reconfort")'` → tous tests verts, dont `test-reconfort-validity.R` (AOI CVL valide / hors-zone warning), `test-reconfort-postprocess.R` (raster classes → POINT → `alert`), `test-reconfort-pipeline.R` (orchestration mockée).
2. `RECONFORT_BANDS` contient exactement `B04, B05, B06, B8A, B11, B12` (ni B02 ni B07).
3. R5 routé : UGF feuillus + zone RECONFORT valide → `r5_status = "calculated_reconfort"`, valeur dans `[0, 100]` ; UGF sans méthode applicable → `skipped_no_method`.
4. `classify_disturbance()` étendu : un plot avec `reconfort_dieback` + `ndvi_drop` (±30 j) → `mechanical` ; `reconfort_dieback` seul → `progressive` ; FORDEAD + RECONFORT co-présents → `progressive` + `method_overlap`.
5. Test d'intégration opt-in (`NEMETON_RECONFORT_INTEGRATION=TRUE`) : modèle RF réel appliqué sur une AOI ≤ 1 km², `status = "success"`, score continu lu en EPSG:2154.

Ces checks reprennent spec 021 §6.

### Mise à jour à prévoir dans la documentation projet (A4)

- **CLAUDE.md** : table des familles (R5 « dépérissement, FORDEAD **ou RECONFORT**-conditionné »), §4 `contexte_sante` (3 pipelines), mention spec 021 + ADR-013/A4.
- **spec 021** : `plan.md` (déjà à jour) ; `spec.md` fonctionnel à rédiger si parité avec spec 008 souhaitée.
- **NOTICE** : attribution RECONFORT (Mouret et al. 2023, CESBIO, Apache-2.0) + modèles RF.
- **README** (cœur et app) : section « Suivi sanitaire » étendue aux feuillus, disclaimer de validité CVL.

### Références ajoutées par A4

- Mouret F, Morin D, Martin H, Planells M, Vincent-Barbaroux C (2023). *Toward an Operational Monitoring of Oak Dieback With Multispectral Satellite Time Series: A Case Study in Centre-Val De Loire Region of France.* IEEE J-STARS. doi:10.1109/JSTARS.2023.3332420. (Apache-2.0)
- RECONFORT — dépôt : https://framagit.org/fl.mouret/reconfort (clone vérifié `main` 25198c9).
- Spec 021 (`specs/021-suivi-sanitaire-reconfort/`).

---

## Amendement A5 (2026-06-18) — Découplage de la placette : l'alerte santé est une entité raster/pixel

**Statut** : Accepté (paperwork) — cible `nemeton` v0.92.0 + `nemetonshiny` vX.Y.0
**Spec associée** : spec 008 §15
**Déclencheur** : incident **Mouthe** (zone 5 `mouthe_tot`).

### Contexte de la décision

Vérifié sur la base de production (2026-06-18) : la zone Mouthe `mouthe_tot` (id 5) a un masque FORDEAD à **813 pixels classe 4 (sol-nu)** écrit sur disque, **aucune placette `plot` enregistrée**, et **0 alerte** en base. L'interface affichait « Zone saine — aucune anomalie / Aucune placette ». Le diagnostic a montré que **toute la persistance d'alertes santé est conditionnée à l'existence de placettes** : `alert.plot_id` est `NOT NULL REFERENCES plot(id)`, la table n'a ni géométrie ni `zone_id`, et `.insert_fordead_alerts()` *snappe* les centroïdes de cluster sur la placette la plus proche (≤ 200 m) en jetant la géométrie réelle.

La placette est un héritage de la surveillance rapide par échantillonnage GRTS (E6.a). Or les trois méthodes opérationnelles — FAST (raster pur depuis v0.60.0, `obs_pixel` retiré), FORDEAD, RECONFORT — sont **pixel/raster** : la placette n'y a pas de rôle.

### Décision

**La `plot` est intégralement découplée du suivi sanitaire, pour les trois méthodes (FAST, FORDEAD, RECONFORT).** L'unité d'alerte santé devient une **entité raster/pixel géoréférencée** (centroïde de cluster + classe + surface) rattachée à la **zone de suivi** (`monitoring_zone`), jamais à une placette. La table `plot` subsiste pour la validation terrain QField future (G4) mais aucun flux santé n'en dépend.

### Phasage (sans migration immédiate)

- **Phase A (v0.92.0)** : la table `alert` est vidée (`TRUNCATE`, 2026-06-18) et **n'est plus alimentée**. Le **masque 0-4 sur disque devient la source de vérité unique** de l'affichage santé. Le cœur débranche `.insert_fordead_alerts()` / `.insert_reconfort_alerts()` de la phase `persist` (les rasters + bundle restent écrits). **R5 n'est pas impacté** : il lit l'`alerts_sf` en mémoire, pas la DB. L'UI décide « zone saine » sur le raster (pixels classe ≥ 1), plus sur le compte d'alertes. **Aucune migration.**
- **Phase B (ultérieure)** : la re-persistance d'alertes pixel exigera une migration (ajout `zone_id` + géométrie + `n_pixels`/`area_m2`, `plot_id` nullable, nouvelle clé d'unicité, fusion G2 sur proximité spatiale). Schéma cible documenté en spec 008 §15.3, **non appliqué**.

### Affichage multi-strates : calcul sur `_tot`, masquage à l'affichage (D2)

Depuis spec 020, chaque projet a jusqu'à 4 strates de zone (`_tot`, `_res`, `_feu`, `_mix`) issues d'un filtrage par essence des UGF, derrière un sélecteur de zone unique partagé par FAST et FORDEAD.

**Précédent FAST** : `read_fast_alert_raster()` masque le raster à la géométrie UGF de la zone (`.get_zone_aoi()` + `terra::mask()`, NA hors UGF) **avant** discrétisation, et **recalcule par strate** (calcul léger + caché — acceptable).

**Décision D2 — FORDEAD diverge volontairement sur le *quand* du masquage.** Le pipeline FORDEAD est lourd (reticulate, fit harmonique, des centaines de scènes S2) : le recalculer par strate serait du gaspillage. Donc :

- **calcul une seule fois sur `_tot`** (la sélection d'une autre strate ne déclenche aucun run) ;
- **masquage à l'affichage** : le masque 0-4 `_tot` est clippé à la volée par `terra::mask(masque_tot, .get_zone_aoi(con, zone_selectionnee))` selon la strate choisie (`_res`, `_mix`, ou `_tot` sans masque) ;
- le primitif est le même qu'en FAST (`.get_zone_aoi()` + `terra::mask()`), seul le moment du masquage diffère (compute pour FAST, affichage pour FORDEAD).

Bénéfice annexe : résout la question `_tot` vs `_res`. FORDEAD ne concerne que les résineux ; on calcule sur `_tot` mais on peut n'afficher que les pixels résineux (`_res`) par masquage, sans relancer.

### Alternatives écartées

- **Garder le modèle placette et créer une placette par cluster** : réintroduit l'artefact qu'on supprime, pollue la table `plot` (modèle d'échantillonnage), et fait dépendre la santé d'un concept étranger. Écarté.
- **Migration immédiate (Phase B tout de suite)** : non nécessaire tant qu'on ne re-persiste pas ; coût et risque (schéma de prod) prématurés. Reporté.
- **Recalculer FORDEAD par strate (comme FAST)** : gaspillage de calcul lourd alors qu'un masquage du raster `_tot` suffit. Écarté (D2).

### Garde-fous impactés

- **G4 (validation terrain)** : les colonnes `validation_*` portées par `alert` sont gelées jusqu'à Phase B.
- **G2 (fusion multi-méthodes)** : `classify_disturbance()` jointe aujourd'hui sur `plot_id` — dormant en Phase A (table vide), à refondre sur proximité spatiale en Phase B.
- **G1, G3, G5** : inchangés (filtrage de classes, bannière de validité, conditions R5).

### Risques résiduels acceptés

- **Aucune alerte interrogeable en base pendant la Phase A** : l'affichage et R5 fonctionnent (raster + `alerts_sf` mémoire), mais l'historique/validation d'alertes est suspendu jusqu'à Phase B. Accepté explicitement (« on verra plus tard comment remplir la table »).

### Tests de validation de A5

Avant clôture de la release v0.92.0 :

1. Run FORDEAD sur une zone sans placette produisant des pixels classe ≥ 1 → carte raster 0-4 affichée, jamais « zone saine ».
2. Masque tout-classe-0 → « zone saine » (vrai négatif).
3. `Rscript -e 'devtools::test(filter = "deperissement")'` → R5 inchangé, vert.
4. Aucune occurrence de « placette » dans les clés i18n du mode santé.
5. Pipelines (mockés) verts après débranchement de l'insertion ; `devtools::check()` propre.
6. FORDEAD calculé une seule fois sur `_tot` ; sélectionner `_res` / `_mix` ne relance aucun run et masque le raster `_tot` à la géométrie UGF de la strate (D2).
