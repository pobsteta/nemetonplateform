# ADR-016 — `firexpovulnR` comme source principale du calcul R1

**Statut** : **Rejeté** — par Pascal le 2026-10-06 (proposé le 2026-08-20). Motif : la
comparaison à l'aveugle (`nemeton/specs/047-r1-firexpovulnr/spec.md`, script
`comparaison.R`) montre que `fev_exposure()` binaire reproduit et sature comme le chemin
actuel, et que seule la version graduée désature, avec des poids que le paquet documente
comme non sourcés. R1 reste sur `fireexposuR` + pente + climat. Rangé ici le 2026-11-16
(brief `2026-10-06-adr-016-rejete.md` de `nemeton`).
**Décideur** : Pascal Obstétar.
**Spec associée** : `specs/047-r1-firexpovulnr/spec.md`.

## Contexte

`indicateur_r1_feu()` produit un indice de risque incendie 0-100 par deux
chemins : `fireexposuR::fire_exp()` sur un raster de combustible dérivé de la
BD Forêt, ou un repli `⅓ pente + ⅓ inflammabilité + ⅓ sécheresse`.

Trois défauts, tous constatés dans le dépôt :

1. **Les seuils du repli ne sont sourcés nulle part** — 30° de pente, 8 °C et
   1400 mm pour le climat, 50 par défaut pour une essence inconnue.
2. **L'exposition sature** : mesuré sur le projet Fordead, 93 % du voisinage de
   500 m est combustible et R1 tombe entre 98,7 et 100 sur les 30 unités.
   L'indicateur ne classe plus rien. La pondération actuelle est un correctif
   empirique.
3. **Aucune calibration** contre des surfaces réellement brûlées.

`pobsteta/firexpovulnR` (v0.32.0, GPL-3, même auteur) traite précisément ce
problème : FWI calibré en percentiles régionaux, exposition de Beverly et al.
avec rayons sourcés, validation contre surfaces brûlées, provenance YAML
systématique.

## Décision

**Adopter `firexpovulnR` comme source principale du calcul de R1, en `Suggests`,
pour ses briques de calcul seulement.**

Trois frontières, qui font l'essentiel de cette décision :

1. **Calcul oui, acquisition non.** `nemeton` continue d'acquérir (DEM, BD
   Forêt, LiDAR HD, SUFOSAT) ; `firexpovulnR` calcule. Ses `fev_fetch_*` ne
   sont pas appelés. Deux chaînes d'acquisition parallèles divergeraient sur les
   CRS et les millésimes — la famille de bugs que `safe_rasterize()` et
   `.normalize_crs()` existent déjà pour rattraper.
2. **Exposition et danger oui, `fev_risk()` non.** `fev_risk()` croise le danger
   avec une vulnérabilité d'enjeux (population, bâti, habitats). C'est du risque
   **sociétal** ; ces enjeux sont déjà S1, S2, S3 et la famille N. R1 reste une
   propriété de l'unité forestière.
3. **`Suggests`, jamais `Imports`.** Le chemin de repli actuel est conservé tel
   quel. Sans le paquet, R1 se comporte comme aujourd'hui.

Le **FWI est conditionnel à la source**, comme SUFOSAT pour T3 (spec 030) et
FORDEAD pour R5 (spec 008) : présent si le CDS est configuré, proxy WorldClim
sinon.

## Conséquences

**Positives**

- Les seuils de R1 deviennent sourcés et surchargeables au lieu d'être des
  conventions.
- R1 devient **calibrable**, et le sera : `fev_validate()` contre les surfaces
  brûlées est un critère d'acceptation, pas une option.
- La méthode retenue devient lisible dans le résultat, pas seulement dans les
  logs — défaut corrigé au passage.
- Le NDP 0 est préservé : `fev_exposure()` part d'un raster de combustible, sans
  météo.

**Négatives, assumées**

- Une dépendance de plus, en `lifecycle: experimental` et v0.32.0 : l'API peut
  bouger. Mitigé par le plancher de version strict et le maintien du repli.
- Deux paquets couvrent désormais l'incendie (`fireexposuR` reste en `Suggests`
  de `firexpovulnR`). Le recouvrement doit être surveillé à chaque montée de
  version.
- Le facteur de bus ne s'améliore pas : même auteur que `nemeton`.

**Neutres**

- Aucun changement du contrat de sortie de R1 : 0-100, haut = plus de risque,
  inversé à la normalisation, `NA` si non calculable.

## Alternatives écartées

| Alternative | Raison du rejet |
|---|---|
| **Statu quo** | Les trois défauts sont constatés, dont une saturation mesurée qui rend l'indicateur inopérant sur massif continu |
| **Sourcer les seuils à la main dans `nemeton`** | Refait ce que `firexpovulnR` fait déjà mieux, sans la validation ni la provenance ; et il faudrait maintenir la bibliographie |
| **Adopter `fev_risk()` en entier** | Doublonnerait S1/S2/S3 et N, et changerait le sens de R1 |
| **Passer `firexpovulnR` en `Imports`** | Rendrait R1 indisponible sans lui, alors que le repli fonctionne et que le paquet est expérimental |
| **Rendre le FWI obligatoire** | La friction CDS est connue — c'est elle qui a bloqué E-OBS pendant des semaines. R1 deviendrait fragile |

## Réserve explicite sur l'état de la revue

Cette décision s'appuie sur une revue **documentaire** : signatures, roxygen,
README, sources citées. **Aucune exécution.** La spec 047 impose donc une étape
de comparaison à l'aveugle (Fordead et les Maures) **avant** tout câblage, et
cette étape peut invalider la décision : si `fev_exposure()` sature comme
l'actuel, le gain se réduit aux seuils sourcés et à la provenance, ce qui ne
justifierait pas le même effort.
