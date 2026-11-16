# Équipe de nemetonplateforme

> Produit par l'orchestrateur avec `/imperatrice:mission`, **validé par Pascal** avant
> tout démarrage. Règle de staffing : un agent par mission qui passe les trois
> questions, jamais un agent « par principe ».

- **Statut :** proposée
- **Validée par :** _…_

## Plafond humain

> **Ce qu'il compte** (cap de Pascal du 2026-11-16, qui remplace « toutes les PR de tous
> les projets ») : les PR ouvertes par l'orchestrateur de `nemetonplateforme`, dans quelque dépôt que ce soit ; les PR que chaque projet ouvre dans son propre pilotage relèvent de son plafond local.

- **PR ouvertes en même temps par l'orchestrateur, au plus :** 3 _(d'abord confirmé par
  Pascal le 2026-11-16 : ce plafond global l'emporte toujours sur le plafond local d'un
  projet, qui n'est qu'une limite de plus dans ce projet ; il compte toutes les PR qui
  attendent la relecture de Pascal, quel que soit le dépôt ; revu le même jour : ne
  compte que les PR ouvertes par l'orchestrateur)_
- **Rythme de relecture de Pascal :** _… (pour mémoire, `nemetonshiny/pilotage/equipe.md`
  note 5 PR par jour ouvré, bilan du 2026-11-13, pour ce seul projet)_

## Le vivier (catalogue, pas une équipe)

| Agent | A / plan | Modèle | Écrit du code ? |
|---|---|---|---|
| `contradicteur` | Abstraction · Polos | opus | non |
| `acquereur` | Acquisition · Ponos | sonnet | non (référentiels et données) |
| `archiviste` | Archivage · Pontos | sonnet | non (docs) |
| `analyste` | Analyse · Ponos | sonnet | non |
| `afficheur` | Affichage · Ponos | sonnet | oui (interface) |
| `dev` | réalisation · Ponos | sonnet | oui |
| `testeur` | réalisation · Ponos | sonnet | oui (tests) |
| `relecteur` | contrôle · C3 | opus | non (lecture seule) |

## Missions

| Mission | Dépôt | Agent | Modèle | Temps de la main | Les 3 questions | Cycle |
|---|---|---|---|---|---|---|
| [001](missions/001-nemeton-commande-de-tests.md) commande de tests | `nemeton` | `testeur` | sonnet | appuyer | 3 oui | 1 |
| [002](missions/002-foretaccess-plugin-et-tests.md) plugin et commande de tests | `foretaccess` | `testeur` | sonnet | appuyer | 3 oui | 1 |
| [003](missions/003-nemetonmcp-plugin-et-tests.md) plugin et commande de tests | `nemetonmcp` | `testeur` | sonnet | appuyer | 3 oui | 1 |

Chaque mission est exécutée par une session ouverte dans le dépôt du projet (ADR 0001),
relue par le `relecteur`, puis prouvée et fusionnée par l'orchestrateur (spec § 5).
Les trois sont indépendantes : elles partent en parallèle, dans le plafond de 3 PR.
