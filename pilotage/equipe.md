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
- **Élargie le 2026-11-18 (Pascal, « oui et code ce qu'il reste à faire partout sans me
  demander, va jusqu'au bout ») :** ouvrir, valider (porte n° 2) et fusionner sans lui
  demander les missions qui réalisent les briefs en attente dans les projets pilotés
  (inventaire du 2026-11-18 au journal), les tests de contrat 014 à 016 compris, quand les
  six contrôles sont verts ; trancher par la valeur la plus prudente et la plus réversible
  les questions de détail qu'un brief laisse ouvertes, chacune inscrite au journal. Restent
  réservés : une rupture déclarée, ce qui touche l'extérieur sans retour possible ; une
  montée de version de `terrain` dans l'aval est faite seulement si le brief la demande,
  et dite au bilan.
- **Inscrite au journal le :** 2026-11-16.
- **Élargissement du 2026-11-18 inscrit au journal le :** 2026-11-18.

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
| [004](missions/004-nemetonshiny-commande-de-tests.md) commande de tests versionnée | `nemetonshiny` | `testeur` | sonnet | appuyer | 3 oui | 2 |
| [005](missions/005-nemetonshiny-service-monitoring-wiring.md) `service_monitoring_wiring` vert seul | `nemetonshiny` | `dev` | sonnet | appuyer | 3 oui | 3 |
| [006](missions/006-victor-tests-et-ci.md) tests, commande de tests et CI | `victor` | `dev` | sonnet | appuyer | 3 oui | 3 |
| [007](missions/007-carte-yaml.md) `docs/carte.yaml` | `nemetonplateforme` | `archiviste` | sonnet | appuyer | 3 oui | 4 |
| [008](missions/008-etat-cycle-yaml.md) `pilotage/etat-cycle.yaml` | `nemetonplateforme` | `archiviste` | sonnet | appuyer | 3 oui | 4 |
| [009](missions/009-nemetonshiny-availablecores-tests.md) `availableCores()` dans les tests | `nemetonshiny` | `dev` | sonnet | appuyer | 3 oui | 5 |
| [010](missions/010-confirmer-liens-carte.md) confirmer les liens de la carte | `nemetonplateforme` | `archiviste` | sonnet | appuyer | 3 oui | 5 |
| [011](missions/011-sommier-demarrer.md) installer la méthode | `sommieR` | session de `/demarrer` | sonnet | appuyer | 3 oui | 6 |
| [012](missions/012-rangement-memoire.md) rangement de la mémoire | `nemetonplateforme` | `archiviste` | sonnet | appuyer | 3 oui | 8 |
| [013](missions/013-sommier-ci-dependances.md) dépendances R de la CI | `sommieR` | `dev` | sonnet | appuyer | 2 oui, 1 à vérifier | 8 |
| [014](missions/014-contrat-nemeton-sommier.md) contrat avec nemeton | `sommieR` | `testeur` | sonnet | appuyer | 3 oui | 9 |
| [015](missions/015-contrat-nemeton-nemetonshiny.md) contrat avec nemeton | `nemetonshiny` | `testeur` | sonnet | appuyer | 3 oui | 9 |
| [016](missions/016-contrat-nemeton-nemetonmcp.md) contrat avec nemeton | `nemetonmcp` | `testeur` | sonnet | appuyer | 3 oui | 9 |
| [017](missions/017-nemetonmcp-suivre-nemeton.md) suivre nemeton 2026.11.32-34 | `nemetonmcp` | `dev` | sonnet | appuyer | 3 oui | 9 |
| [018](missions/018-marculus-tarifs-et-style.md) tarifs IFN et style commun | `marculus` | `dev` | sonnet | appuyer | 3 oui | 9 |
| [019](missions/019-groma-texte-et-heure-utc.md) styles de texte et heure UTC | `groma` | `dev` | sonnet | appuyer | 3 oui | 9 |
| [020](missions/020-groma-modules-terrain.md) modules repris de terrain | `groma` | `dev` | sonnet | appuyer | 3 oui | 9 |
| [021](missions/021-sommier-actions-realisees.md) réalisé vers nemetonshiny | `sommieR` | `dev` | sonnet | appuyer | 3 oui | 9 |
| [022](missions/022-sommier-niveaux-concurrence.md) niveaux de concurrence | `sommieR` | `dev` | sonnet | appuyer | 3 oui | 9 |
| [023](missions/023-sommier-symbologie-travaux.md) symbologie des travaux | `sommieR` | `dev` | sonnet | appuyer | 3 oui | 9 |
| [024](missions/024-sommier-demo-marsannay.md) démo Marsannay | `sommieR` | `dev` | sonnet | appuyer | 3 oui | 9 |
| [025](missions/025-sommier-ortho-tuilee.md) ortho tuilée et métadonnées | `sommieR` | `dev` | sonnet | appuyer | 3 oui | 9 |
| [026](missions/026-sommier-photos-terrain.md) photos de terrain | `sommieR` | `dev` | sonnet | appuyer | 3 oui | 9 |
| [027](missions/027-sommier-import-sans-blocage.md) import de terrain sans blocage | `sommieR` | `dev` | sonnet | appuyer | 3 oui | 9 |
| [028](missions/028-sommier-import-comptages.md) import des comptages de plants | `sommieR` | `dev` | sonnet | appuyer | 3 oui | 10 |
| [029](missions/029-sommier-version-calendaire.md) version calendaire | `sommieR` | `dev` | sonnet | appuyer | 3 oui | 10 |
| [030](missions/030-terrain-fix-horodate-lecteur-nmea.md) heure UTC du fix, lecteur NMEA | `terrain` | `dev` | sonnet | appuyer | 3 oui | 10 |
| [031](missions/031-nemetonshiny-hebergeur-hostinger.md) note Hostinger | `nemetonshiny` | `dev` | sonnet | appuyer | 3 oui | 10 |
| [032](missions/032-plateforme-outils-execution.md) outils d'exécution versés | `nemetonplateforme` | `archiviste` | sonnet | appuyer | 3 oui | 10 |

Chaque mission est exécutée par une session ouverte dans le dépôt du projet (ADR 0001),
relue par le `relecteur`, puis prouvée et fusionnée par l'orchestrateur (spec § 5).
Les missions 001 à 003 étaient indépendantes : elles sont parties en parallèle, dans le plafond
de 3 PR. Pour les missions 004 à 013, la validation est inscrite au journal le jour où chacune a
été ouverte (sous la délégation, ou sur le « oui » de Pascal). Missions 014 à 026 : délégation élargie du 2026-11-18 ; 027 : cap de Pascal du 2026-11-19 ; 028 et 029 : caps de Pascal au bilan du 2026-11-20 ; 030 à 032 : délégation élargie (journal). Tableau complété le 2026-11-18 (mission 012), puis au bilan du 2026-11-20 ; la
colonne « Cycle » donne le cycle où la mission a été lancée.
