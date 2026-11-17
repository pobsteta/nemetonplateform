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

**Dernier cycle :** 2 _(augmenté de 1 à la fin de chaque `/boucle`, même quand elle n'a
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
