# ADR-015 — Passage à GPL-3 (supersède la clause licence d'ADR-006)

- **Statut** : Accepté
- **Date** : 2026-07-01
- **Supersède** : la clause *licence* d'ADR-006 (EUPL v1.2 plateforme + MIT packages R + CC-BY 4.0 données)
- **Contexte** : spec 028 (diversité spectrale B4/L3 via biodivMapR)

## Contexte

L'ADR-006 fixait un modèle de licences mixtes :

- **EUPL v1.2** pour la plateforme (application) ;
- **MIT** pour les packages R ;
- **CC-BY 4.0** pour les données.

L'intégration de la **diversité spectrale** (indicateurs B4 α-Shannon et
L3 β-Bray-Curtis, spec 028) s'appuie sur le package **biodivMapR**, publié
sous **GPL-3** (copyleft fort). Le package cœur `nemeton` l'ayant ajouté en
`Imports` (v0.110.0), `nemeton` devient une œuvre dérivée GPL-3.

Le copyleft se propage alors à tout composant qui **importe** (lie) le code
de `nemeton`.

## Décision

1. **`nemeton` (cœur)** → **GPL-3** (v0.110.0). Obligation : import direct de
   biodivMapR (GPL-3).

2. **`nemetonshiny` (application)** → **GPL-3** (v0.97.0). Obligation : importe
   `nemeton` (GPL-3). L'EUPL v1.2 antérieure autorisait explicitement cette
   relicence (clause de compatibilité, Article 5, qui liste la GPL).

3. **`treesatnemeton`** (v0.2.0) et **`maestronemeton`** (v0.3.0) → **GPL-3**
   **par choix d'uniformité de plateforme**, *sans obligation juridique* : ces
   deux classifieurs d'essences sont **autonomes** et **n'importent pas** le
   package cœur `nemeton` (leurs sorties raster sont consommées par `nemeton`
   comme **données**, pas comme code lié). Le copyleft ne s'y propageait donc
   pas ; la décision de les aligner sur GPL-3 est délibérée.

4. **Données** → inchangé : **CC-BY 4.0** (ADR-006 conservé sur ce point ; une
   licence de données n'est pas affectée par le copyleft logiciel).

## Conséquences

- Toute la chaîne logicielle Néméton est désormais **GPL-3** homogène :
  `nemeton`, `nemetonshiny`, `treesatnemeton`, `maestronemeton`.
- Les contributions et redistributions doivent respecter le copyleft GPL-3.
- La relicence MIT→GPL-3 est **irréversible** (choix assumé, cf. §3).
- Les fichiers `LICENSE`/`DESCRIPTION` de chaque dépôt portent la GPL-3 et une
  note de relicence datée.
- ADR-006 reste la référence pour les volets **non-licence** (souveraineté,
  hébergement, etc.) ; seule sa clause licence est superséée par le présent ADR.

## Notes

- `opencanopynemeton` (CHM Open-Canopy, spec 005) : à évaluer séparément selon
  qu'il importe ou non `nemeton` et selon la licence d'Open-Canopy amont.
