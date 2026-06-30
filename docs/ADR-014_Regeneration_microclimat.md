# ADR-014 — reGénération : aptitude microclimatique à la régénération forestière (microclimf + LiDAR HD)

**Statut** : Proposé (cadrage) — à valider avant le Lot 1.
**Date**   : 2026-06-30
**Auteur** : Pascal Obstétar (via Claude)
**Cible**  : `nemeton` (cœur, indicateurs + pipeline microclimat) puis
`nemetonshiny` (onglet « reGénération »).
**Spec associée** : `nemeton/specs/027-regeneration-microclimat/spec.md`.
**Précédents pertinents** : ADR-009 (séparation cœur/app), ADR-011 (NDP augmenté,
pondération Fibonacci — **amendé par cet ADR**), spec 005 (Open-Canopy CHM / NDP
augmenté).

## Contexte

La régénération forestière (semis, recrû) est gouvernée par le **microclimat sous
couvert** — température et déficit hydrique au niveau du sol forestier — bien plus
que par le macroclimat de station météo. Néméton ne mesure aujourd'hui aucune
grandeur microclimatique. On veut un onglet « reGénération » répondant à : *où la
régénération est-elle climatiquement viable, et quelles parcelles prioriser pour
l'adaptation ?*

Un modèle mécaniste (**microclimf**, R, forcé par **ERA5-Land**) calcule la
température et l'humidité sous couvert à partir de la **structure de canopée**
(hauteur + densité foliaire PAI). Cette structure est désormais disponible
nationalement via le **LiDAR HD IGN**, avec repli **opencanopy** (CHM ortho, déjà
intégré spec 005) là où le LiDAR manque.

## Décision

1. **Aptitude microclimatique à la régénération** ajoutée comme nouvelle capacité
   d'analyse, calculée par parcelle (UGF) : T° max estivale sous couvert,
   tamponnement de la canopée, VPD sous couvert, et sensibilité du microsite à une
   année chaude.

2. **Pas de 13e famille — sous-indicateurs dans les familles existantes**, pour
   **préserver le radar à 12 axes** (cohérence visuelle, charte Néméton). Insertion
   dans A (Air & Microclimat), W (Eau & Régulation), R (Risques & Résilience) :
   `a3_microclimat`, `a4_tamponnement`, `w4_vpd`, **`r6_sensibilite`**.
   - **Note de code** : le sous-indicateur de sensibilité est **R6** et **non R5**
     — R5 est déjà `indicateur_r5_deperissement` (suivi sanitaire, ADR-013, branché
     au radar). Sens R6 « haut = bon » (pas d'inversion de normalisation, à la
     différence de R5).

3. **Modèle mécaniste augmenté par le LiDAR** — amende **ADR-011** :
   - nouveau flag d'augmentation **`microclimate_model`** dans `detect_ndp()`, à
     côté de `height_ml` / `species_ml` / `texture_ml` ;
   - le **niveau NDP de base et la confiance φ Fibonacci sont préservés** :
     l'augmentation est reportée dans le vecteur `augmented`, comme pour
     `"height_ml"` (spec 005) ;
   - NDP de structure : LiDAR HD nuage > CHM opencanopy > pas de structure.

4. **Repli `opencanopy` obligatoire** : quand le nuage LiDAR HD est absent, le PAI
   et la hauteur sont estimés depuis le CHM opencanopy — NDP dégradé, **jamais
   d'erreur**.

5. **Dépendances lourdes en `Suggests`, jamais `Imports`** (`microclimf`, `mcera5`,
   `ecmwfr`, `lidR`, `lasR`) : chargées via `requireNamespace()`, **dégradation
   propre** si absentes. Cohérent avec ADR-009 et la règle spec 005.

6. **Indice composite « potentiel de régénération » paramétré par essence cible**
   (tolérances chaud/sec tabulées), en **tête d'onglet** — **pas un axe radar**
   (le composite est une lecture par essence, pas une famille de service
   écosystémique).

7. **Honnêteté sur la confiance** : sans validation terrain (capteurs TMS-4, bases
   SoilTemp/ForestTemp), ces indicateurs sont fiables en **rangement relatif**
   entre parcelles, prudents en **valeur absolue** — reflété dans la confiance
   affichée et l'infobulle.

## Conséquences

**Positives**
- Première capacité microclimatique de Néméton, directement actionnable pour
  l'adaptation (priorisation de parcelles).
- Radar inchangé (12 familles) : aucune rupture de charte ni de l'indice général
  Fibonacci.
- Réutilise l'infrastructure existante : `normalize_indicators` /
  `create_family_index`, config espèces, registre de sources, cache projet, NDP
  augmenté (spec 005).

**Négatives / coûts**
- **Coût de calcul** microclimf élevé → tuilage (`runmicro_big`) + **cache disque**
  par `(emprise, année)` obligatoires.
- Chaîne de données lourde (ERA5-Land via clé CDS, dalles LiDAR HD volumineuses) ;
  E-OBS = usage non commercial recherche/enseignement (`inst/NOTICE`).
- Valeurs absolues non validées terrain → confiance bornée (assumé, NDP).

**Risques résiduels acceptés**
- **Canopée figée** pour la sensibilité (R6) : isole l'effet climatique, pas la
  trajectoire (mortalité/coupes). Les **deux années** (moyenne vs canicule) sont
  **détectées automatiquement par défaut** (série estivale E-OBS), avec
  **override utilisateur** ; la détection privilégie des années proches de
  l'acquisition LiDAR pour limiter le biais de structure (cf. spec 027 §6bis).
- **PAI** sensible à la saison d'acquisition LiDAR (feuillaison) et au coefficient
  d'extinction `k` — principal levier de calage.

## Alternatives écartées

- **13e famille « Microclimat »** : romprait le radar 12 axes et la charte ;
  écarté au profit de sous-indicateurs A/W/R.
- **Macroclimat (station/ERA5 brut) sans modèle sous couvert** : ne décrit pas le
  microsite de régénération (le tamponnement de canopée est l'effet recherché) ;
  écarté.
- **Indicateur purement statistique (proxy CHM/altitude)** sans modèle mécaniste :
  moins transférable, pas de tamponnement explicite ; le mode augmenté microclimf
  est retenu, le proxy ne sert que de repli implicite via opencanopy.
- **`microclimf` en `Imports`** : alourdirait l'installation du cœur pour une
  capacité optionnelle ; écarté (Suggests + dégradation propre).

## Lotissement (cf. spec 027 §13)

L1 cœur (inputs/run + a3/a4/w4 + registre) → L2 (r6 + E-OBS) → L3 (composite par
essence) → L4 onglet `nemetonshiny` → L5 doc. Ordre cœur → app respecté (ADR-009).
