# Équipe de nemetonplateforme

> Produit par l'orchestrateur avec `/imperatrice:mission`, **validé par Pascal** avant
> tout démarrage. Règle de staffing : un agent par mission qui passe les trois
> questions, jamais un agent « par principe ».

- **Statut :** validée
- **Validée par :** Pascal, le 2026-11-16 (missions 001 à 003)

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

## Délégation

> Ce que Pascal demande à l'orchestrateur de trancher à sa place (skill `methode`,
> « La délégation », plugin `imperatrice` 1.0.0). Mise au format le 2026-11-16 : les
> décisions de Pascal sont celles du journal du même jour (lignes `cap`), inchangées.

- **Portée :** porte n° 3 : fusionner les PR vers `main` et publier les releases, dans
  tous les projets pilotés, quand les six contrôles de `docs/spec.md` § 5 sont verts ;
  et, sur demande expresse du 2026-11-16, les six PR alors ouvertes (`terrain` #33,
  `nemetonshiny` #301 et #302, `ramulus` #23, `groma` #111 et #112), CI verte.
- **Jusqu'à :** révocation.
- **Réservé à Pascal :** toute PR ou release qui déclare une rupture ou change un contrat
  écrit ; toute montée de version de `terrain` dans l'aval ; tout projet où un des six
  contrôles manque ; et toujours : sa réponse d'abord, rendre la main, ce qui touche
  l'extérieur et ne se défait pas.
- **Élargie le 2026-11-16 (Pascal, « fusionne et continue, ne me demande plus rien tant
  que tout n'est pas terminé ») :** fusionner les PR de pilotage et de documentation de
  `nemetonplateforme` (ni CI ni tests) ; et, jusqu'à la fin du travail en cours, valider à
  sa place les missions de même nature que 001 à 003 (plugin et `.claude/test-command`
  dans un projet piloté) et les tâches de rangement de la plateforme. Les questions
  réservées ci-dessus ne sont pas tranchées : elles sont mises de côté et posées au bilan.
- **Inscrite au journal le :** 2026-11-16.

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
