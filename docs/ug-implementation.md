# Implémentation des Unités de Gestion (UG) dans nemetonShiny

> **Statut** : proposition de design — à valider avant lancement
> **Auteur** : équipe nemeton
> **Date** : 2026-04-10
> **Cible** : `nemetonShiny` (package R / Shiny)
> **Approche** : DDD + Walking Skeleton + BMAD

---

## 1. Contexte et problème

Aujourd'hui, `nemetonShiny` calcule les indicateurs écosystémiques (12 familles, score
Néméton) à la maille de la **parcelle cadastrale**. Or, dans la pratique forestière
française (régime forestier ONF, plans simples de gestion CRPF), l'unité opérationnelle
n'est **pas** la parcelle cadastrale mais la **parcelle forestière**, qui peut :

- **regrouper** plusieurs parcelles cadastrales contiguës homogènes (ex. parcelles 54-59
  de la forêt communale de Couchey) ;
- **subdiviser** une parcelle cadastrale en plusieurs sous-unités hétérogènes
  (ex. parcelle 22 de Couchey → 22a TSF chêne, 22b dispositif expérimental résineux,
  22n hors sylviculture).

Tant que cette maille métier n'est pas représentée dans l'outil, les rapports nemeton
ne sont pas alignés avec les documents d'aménagement officiels et ne peuvent pas être
utilisés directement par les gestionnaires.

**Objectif** : introduire la notion d'**Unité de Gestion (UG)** comme maille de calcul
et de restitution, en garantissant que toute UG reste traçable jusqu'au cadastre.

---

## 2. Domain-Driven Design

### 2.1 Langage ubiquitaire

| Terme | Définition | Synonymes à proscrire |
|---|---|---|
| **Parcelle cadastrale** | Polygone immuable issu du cadastre (PCI / DGFiP). Identifiant officiel `INSEE-section-numéro`. | "parcelle" tout court, "lot" |
| **Atome** | Plus petite subdivision géométrique manipulable. Soit une parcelle cadastrale entière, soit un fragment issu d'un découpage. Pave intégralement sa parcelle d'origine. | "morceau", "fragment", "tile" |
| **Unité de Gestion (UG)** | Regroupement d'un ou plusieurs atomes formant l'unité métier de gestion forestière. Équivalent de la "parcelle forestière" ONF. | "parcelle forestière" (en interne uniquement), "unité sylvicole" |
| **Groupe d'aménagement** | Classification fonctionnelle d'un ensemble d'UG partageant un itinéraire sylvicole (AMETS, AMER, IRR, TSF, REGT, HSN…). | "série", "type" |
| **Composition cadastrale** | Liste ordonnée des références cadastrales sources d'une UG, avec surfaces. C'est ce qui permet de régénérer l'annexe 2 ONF. | "ascendance", "lignage" |

**Règle d'or du domaine** :
> Toute UG est un sous-ensemble strict du foncier cadastral. Aucune géométrie d'UG
> ne peut exister en dehors d'un atome, et aucun atome ne peut exister en dehors
> d'une parcelle cadastrale.

### 2.2 Bounded contexts

```
┌─────────────────────────────────────────────────────────────────────┐
│                    nemetonShiny (application)                       │
│                                                                     │
│  ┌────────────────────┐   ┌────────────────────┐   ┌─────────────┐  │
│  │  Cadastre Context  │   │  Gestion Context   │   │  Indicateurs │  │
│  │                    │   │                    │   │   Context    │  │
│  │  - PARCELLE_CAD    │──▶│  - ATOME           │──▶│  - SCORE_UG  │  │
│  │  - import PCI      │   │  - UG              │   │  - 12 fam.   │  │
│  │  - validation topo │   │  - GROUPE_AMENGT   │   │  - rapport   │  │
│  └────────────────────┘   └────────────────────┘   └─────────────┘  │
│       (immuable)              (éditable user)        (calculé)      │
└─────────────────────────────────────────────────────────────────────┘
```

- **Cadastre Context** : source de vérité géométrique, en lecture seule après import.
- **Gestion Context** : cœur du domaine. C'est ici que vit la nouvelle logique UG.
  L'utilisateur n'agit que dans ce contexte.
- **Indicateurs Context** : consomme les UG, ne connaît pas le cadastre directement.
  Travaille uniquement sur `ug_geometry()` et métadonnées UG.

Les contextes communiquent par des **ports** (fonctions R pures) — pas de couplage
direct sur les structures internes.

### 2.3 Agrégats et invariants

**Agrégat racine : `Projet`**

```
Projet
├── parcelles_cadastrales : Set<ParcelleCadastrale>   [immuable post-import]
├── atomes               : Set<Atome>
├── ugs                  : Set<UG>
└── groupes              : Set<GroupeAmenagement>
```

**Invariants à maintenir en permanence** (vérifiés à chaque commande) :

1. **Pavage cadastral** : pour toute parcelle cadastrale `P`,
   `union(atomes où parent = P) ≡ P` (à tolérance topologique près, ex. 0.01 m²).
2. **Partition par UG** : tout atome appartient à **exactement une** UG. Pas de trou,
   pas de recouvrement.
3. **Non-vacuité** : une UG contient au moins un atome. Supprimer le dernier atome
   d'une UG supprime l'UG.
4. **Traçabilité** : toute UG peut produire sa composition cadastrale (références +
   surfaces) sans information externe.
5. **Cohérence des surfaces** : `surface(UG) = somme(surface(atomes))` à tolérance.

Toute commande qui violerait un invariant est **rejetée** au niveau du domaine,
pas au niveau de l'UI.

### 2.4 Commandes du domaine (API publique du Gestion Context)

```r
# Création / initialisation
ug_init_default(projet)                    # 1 atome = 1 parcelle = 1 UG

# Découpage (Cadastre → Atomes)
atome_split_by_geometry(projet, parcelle_id, polygones_sf)
atome_split_by_import(projet, parcelle_id, fichier_geojson)
atome_undo_split(projet, parcelle_id)      # restaure l'atome unique

# Composition d'UG (Atomes → UG)
ug_create(projet, atomes_ids, label, groupe = NULL)
ug_merge(projet, ug_ids, nouveau_label)
ug_split(projet, ug_id, partition_atomes)
ug_assign_atom(projet, atome_id, ug_id)    # déplace un atome vers une UG existante
ug_delete(projet, ug_id)                   # interdit si non vide
ug_set_groupe(projet, ug_id, groupe)

# Requêtes (read model)
ug_geometry(projet, ug_id)                 # st_union des atomes
ug_surface(projet, ug_id)
ug_cadastral_refs(projet, ug_id)           # pour l'annexe 2 ONF
ug_list(projet, filter_groupe = NULL)
projet_validate(projet)                    # vérifie tous les invariants
```

Chaque commande retourne un **nouveau** `projet` (immutabilité fonctionnelle), facilite
le undo/redo et les tests.

---

## 3. Walking Skeleton

> *"A Walking Skeleton is a tiny implementation of the system that performs a small
> end-to-end function. It need not use the final architecture, but it should link
> together the main architectural components."* — Alistair Cockburn

### 3.1 Définition du squelette pour ce projet

Le walking skeleton est la plus petite tranche verticale qui prouve que **toute la
chaîne UG fonctionne de bout en bout**, depuis l'import jusqu'au rapport PDF.

**Scénario du squelette** : *"Sur la forêt communale de Couchey, l'utilisateur ouvre
le projet, regroupe les parcelles cadastrales 54, 55 et 56 en une seule UG nommée
'TSF-Sud', recalcule, et exporte un rapport PDF où cette UG apparaît comme une ligne
unique avec ses trois références cadastrales en annexe."*

Pas de découpage. Pas de sélection multiple sophistiquée. Pas de carte. Juste :

1. Import projet existant ✅ (déjà là)
2. Génération automatique des atomes et UG par défaut ✨ (nouveau)
3. Une table éditable où l'on peut cocher 3 lignes et cliquer "Regrouper" ✨ (nouveau)
4. Recalcul des indicateurs sur la nouvelle UG ✨ (nouveau, mais pipeline existant)
5. Export PDF avec la nouvelle ligne et l'annexe cadastrale ✨ (nouveau)

**Critère d'acceptation du squelette** : un utilisateur réalise ce scénario en moins
de 2 minutes sans documentation, et le PDF généré est cohérent avec les attentes ONF.

### 3.2 Pourquoi un squelette d'abord ?

- **Risque d'intégration éliminé tôt** : on découvre dès la semaine 1 si le pipeline
  d'indicateurs supporte un changement de maille, plutôt qu'en fin de projet.
- **Démontrable au métier** : Ghislain et les forestiers peuvent voir quelque chose
  fonctionner et donner du feedback réel, pas sur un mockup.
- **Architecture validée par l'usage**, pas par anticipation.
- **Pas de big-bang** : le reste du projet enrichit le squelette par couches, sans
  jamais le casser.

### 3.3 Ce qui est volontairement **hors** du squelette

- Découpage de parcelles (interactif ou par import) → phase suivante
- Carte leaflet avec sélection graphique → phase suivante
- Undo/redo, historique → phase suivante
- Migration des projets existants → script séparé, livré ensuite
- Annexe 2 ONF complète, formatée → version minimale dans le squelette

---

## 4. Approche BMAD (Build-Measure-Analyze-Decide)

Au lieu d'un plan en cascade par phases figées, on travaille en **boucles BMAD
hebdomadaires**. Chaque boucle :

- **Build** : livrer un incrément fonctionnel testable
- **Measure** : collecter des métriques objectives (tests, perfs, feedback métier)
- **Analyze** : confronter les mesures aux hypothèses de design
- **Decide** : ajuster le plan de la boucle suivante (continuer, pivoter, refactorer)

### 4.1 Boucle 0 — Walking Skeleton (semaine 1)

| | |
|---|---|
| **Build** | Le scénario "Couchey 54+55+56" décrit en §3.1, de bout en bout. Code minimal, pas de polish. |
| **Measure** | (a) le scénario passe en démo live ; (b) tests de non-régression sur 1 projet existant : scores inchangés à ε près ; (c) temps d'exécution du recalcul. |
| **Analyze** | Le pipeline d'indicateurs accepte-t-il vraiment une géométrie d'UG sans modification profonde ? Y a-t-il des hypothèses cachées sur "1 ligne = 1 parcelle cadastrale" ailleurs dans le code (ex. jointures, IDs, exports) ? |
| **Decide** | Si oui → continuer en boucle 1. Si non → refactorer le pipeline avant d'aller plus loin (et le dire honnêtement, pas masquer la dette). |

**Definition of Done de la boucle 0** :
- [ ] Le scénario tourne sur la machine de dev ET sur l'instance partagée
- [ ] Les invariants 1-5 sont vérifiés par `projet_validate()` à chaque commande
- [ ] Les tests caractérisation Phase 0 (cf. plan détaillé ci-dessous) passent
- [ ] Une démo de 5 min est enregistrée et partagée

### 4.2 Boucle 1 — Regroupement carte + groupes d'aménagement (semaine 2)

| | |
|---|---|
| **Build** | Carte leaflet avec sélection multiple d'atomes au clic, bouton "Créer UG", champ "groupe d'aménagement" éditable, coloration par groupe. |
| **Measure** | Test utilisateur avec 1 forestier réel sur Couchey. Mesurer : nombre de clics pour reproduire l'aménagement officiel (objectif < 50), erreurs commises, points de friction verbalisés. |
| **Analyze** | Les regroupements ONF de Couchey sont-ils tous reproductibles avec cette UI ? Lesquels échouent et pourquoi ? |
| **Decide** | Prioriser les manques pour la boucle 2 ou 3. |

### 4.3 Boucle 2 — Découpage par import externe (semaine 3)

| | |
|---|---|
| **Build** | Mode A du découpage : import d'un GeoJSON/Shapefile de polygones de subdivision, intersection automatique avec les parcelles cadastrales concernées, création des atomes. |
| **Measure** | Cas test : reproduire la subdivision 22a/22b/22n de Couchey à partir d'un GeoJSON fabriqué à la main. Vérifier l'invariant de pavage à 0.01 m² près. |
| **Analyze** | La tolérance topologique tient-elle sur des données réelles ? Que faire des résidus (atome "reste") ? |
| **Decide** | Garder ou non l'atome "reste" automatique. Définir le seuil de tolérance final. |

### 4.4 Boucle 3 — Découpage interactif (semaine 4-5)

| | |
|---|---|
| **Build** | Mode B : outil de dessin leaflet limité à une parcelle sélectionnée, calcul de subdivision via `lwgeom::st_split()`, nommage automatique des atomes. |
| **Measure** | Temps moyen pour subdiviser une parcelle en 3 morceaux. Robustesse sur géométries complexes (parcelles non convexes, trous). |
| **Analyze** | Quels cas font échouer `st_split` ? Faut-il un fallback ? |
| **Decide** | Livrer ou repousser. Le mode A reste un filet de sécurité acceptable. |

### 4.5 Boucle 4 — Migration, annexe ONF, polish (semaine 5-6)

| | |
|---|---|
| **Build** | `migrate_project_v1_to_v2()`, génération de l'annexe 2 ONF format PDF, vignette utilisateur, exclusion des UG hors sylviculture (HSN/HSY) des scores production. |
| **Measure** | Migration testée sur tous les projets existants en base. 0 régression de score sur les projets non modifiés. |
| **Analyze** | Le format de sérialisation est-il pérenne ? Faut-il versionner explicitement ? |
| **Decide** | Tag de release `v2.0.0` ou boucle supplémentaire. |

---

## 5. Plan détaillé par tâches techniques

> Ce plan est l'**implémentation concrète** des boucles BMAD ci-dessus. Il liste les
> fichiers à créer/modifier, sans figer l'ordre exact (qui sera ajusté à chaque boucle).

### 5.1 Phase 0 — Filet de sécurité (avant tout code)

- [ ] `tests/testthat/test-regression-scores.R` : snapshot des scores d'un projet
      jouet (ex. extrait Couchey 3 parcelles) avec `testthat::expect_snapshot_value()`.
- [ ] `inst/extdata/projet-test-couchey-mini.rds` : projet jouet versionné.
- [ ] CI GitHub Actions : faire tourner ces tests à chaque PR.

### 5.2 Refactor invisible (boucle 0)

Nouveau fichier `R/domain-ug.R` contenant les structures et primitives :

```r
# Constructeurs internes
new_atome <- function(id, parent_parcelle_id, geometry, surface_m2) { ... }
new_ug    <- function(id, label, atome_ids, groupe = NA_character_) { ... }

# API publique (cf. §2.4)
ug_init_default <- function(projet) { ... }
ug_create       <- function(projet, atomes_ids, label, groupe = NULL) { ... }
ug_geometry     <- function(projet, ug_id) { ... }
ug_surface      <- function(projet, ug_id) { ... }
ug_cadastral_refs <- function(projet, ug_id) { ... }
projet_validate <- function(projet) { ... }
```

Modifications :

- [ ] `R/compute-indicators.R` : la fonction principale prend désormais `ug` au lieu
      de `parcelle`. Wrapper de compatibilité conservé temporairement.
- [ ] `R/report.R` : la table principale est indexée par `ug_id`, avec colonne
      `cadastral_refs` (string concaténant les références).
- [ ] `tests/testthat/test-domain-ug.R` : tests unitaires de chaque commande,
      vérification des invariants après chaque opération.

### 5.3 Module Shiny `mod_ug_manager` (boucle 1)

- [ ] `R/mod_ug_manager.R` : module Shiny isolé, avec UI et server.
- [ ] Composants :
  - `DT::datatable` éditable des UG (label, groupe, surface, nb atomes, refs)
  - `leaflet` avec couches `atomes` (cliquables) et `ugs` (colorées par groupe)
  - Boutons : Créer / Fusionner / Dissocier / Réinitialiser
  - Panneau latéral : détails de l'UG sélectionnée
- [ ] `R/app.R` : intégration du module dans l'onglet "Unités de gestion".

### 5.4 Découpage (boucles 2-3)

- [ ] `R/atome-split.R` :
  - `atome_split_by_import(projet, parcelle_id, sf_polygones)`
  - `atome_split_by_geometry(projet, parcelle_id, sf_polygones)` (mode dessin)
  - `atome_undo_split(projet, parcelle_id)`
- [ ] Validation topologique stricte avec `sf::st_is_valid()` et tolérance configurable.
- [ ] Module Shiny étendu : outil de dessin via `leaflet.extras::addDrawToolbar`,
      activé uniquement quand une parcelle est sélectionnée.

### 5.5 Migration et persistance (boucle 4)

- [ ] `R/migrate.R` : `migrate_project_v1_to_v2(path)` détecte automatiquement la
      version et crée atomes + UG par défaut.
- [ ] Versionnage explicite dans le `.rds` : champ `projet$schema_version`.
- [ ] Test de migration sur un dossier de projets réels.

### 5.6 Documentation (boucle 4)

- [ ] `vignettes/ug-workflow.Rmd` : tutoriel basé sur Couchey.
- [ ] `docs/dev/ug-implementation.md` : ce document, mis à jour avec les apprentissages.
- [ ] `NEWS.md` : entrée v2.0.0 décrivant le breaking change et la migration auto.
- [ ] Captures d'écran dans `man/figures/`.

---

## 6. Risques et mitigations

| Risque | Probabilité | Impact | Mitigation |
|---|---|---|---|
| Le pipeline d'indicateurs a des hypothèses cachées sur "1 ligne = 1 parcelle" | Moyenne | Élevé | Walking skeleton dès la boucle 0, tests de régression caractérisation |
| `lwgeom::st_split` échoue sur géométries pathologiques | Moyenne | Moyen | Mode A (import) livré en premier comme fallback |
| Tolérance topologique mal calibrée → atomes "reste" partout | Moyenne | Moyen | Mesure sur Couchey en boucle 2, ajustement empirique |
| Forestiers déroutés par la distinction atome / UG | Élevée | Moyen | Cacher complètement le mot "atome" dans l'UI, ne parler que d'UG et de "découper une parcelle" |
| Régression de scores sur projets existants | Faible | Élevé | Tests snapshot Phase 0, migration auto sans recalcul forcé |
| Performance dégradée si beaucoup d'atomes (>1000) | Faible | Moyen | Benchmark en boucle 1, indexation spatiale `sf` si besoin |

---

## 7. Definition of Done globale

Le projet est considéré terminé (release v2.0.0) quand :

- [ ] Les 5 invariants du §2.3 sont vérifiés à chaque commande, avec tests dédiés
- [ ] Le scénario walking skeleton tourne en démo
- [ ] Les regroupements et subdivisions de la forêt de Couchey sont reproductibles
      à l'identique de l'aménagement ONF officiel
- [ ] Tous les projets existants migrent automatiquement sans perte de données
- [ ] Les scores des projets non modifiés sont identiques à v1 (tests snapshot)
- [ ] L'annexe 2 ONF est générée automatiquement dans le PDF
- [ ] Une vignette utilisateur couvre le workflow complet
- [ ] CI verte sur `main`
- [ ] Au moins un forestier non-développeur a validé l'UI sur un cas réel

---

## 8. Hors périmètre (explicite)

Pour éviter tout malentendu, **ne sont pas couverts** par ce chantier :

- L'édition du parcellaire cadastral lui-même (le cadastre reste source de vérité).
- Les UG inter-propriétés (une UG ne peut contenir que des atomes du même propriétaire).
- La gestion temporelle des UG (versioning, historique des aménagements successifs).
- L'import direct de fichiers ONF (.aménagement, formats propriétaires).
- L'intégration avec les outils ONF (Symphonie, etc.).

Ces sujets feront l'objet de chantiers ultérieurs si le besoin est confirmé.

---

## 9. Références

- Document d'aménagement de la forêt communale de Couchey (ONF, 2025) — cas d'école
- Rapport nemeton de Couchey (mars 2026) — état actuel de la sortie outil
- Eric Evans, *Domain-Driven Design*, 2003
- Alistair Cockburn, *Walking Skeleton*, http://wiki.c2.com/?WalkingSkeleton
- Dan North, *BMAD and short feedback loops*, https://dannorth.net/

---

*Document vivant — à mettre à jour à la fin de chaque boucle BMAD avec les
apprentissages réels.*