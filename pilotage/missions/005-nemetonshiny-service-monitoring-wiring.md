# Mission 005 — `service_monitoring_wiring` vert quand il passe seul (`nemetonshiny`)

> Ouverte sur le « oui » de Pascal du 2026-11-17 (bilan du cycle 2, question 1). Dépôt :
> `nemetonshiny`. Exécutée par une session ouverte dans ce dépôt (`claude -p -w`, ADR 0001).

## Mission

**En une phrase (quoi, et pourquoi) :** Remplacer dans `nemetonshiny` l'appel déprécié `future::availableCores()` (`R/service_compute.R`, `.resolve_parallel_workers()`) par son équivalent non déprécié, pour que `test-service_monitoring_wiring.R` (l. 21, `expect_silent`) passe aussi quand il est lancé seul, puis le remettre dans le niveau rapide de `.claude/test-command`.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? | oui : un seul appel à changer (`parallelly::availableCores()`, que `future` réexporte et déprécie) ; le test qui le montre existe | |
| A-t-il les moyens ? | oui : R et paquets sur le PC, `.claude/test-command` versionnée (mission 004) | |

**Temps de la main :** appuyer.

## Ma réponse d'abord

_Rempli par Pascal seul._ (Pascal a délégué : sans objet.)

## L'Homme

- **Agent :** `dev`. **Modèle :** sonnet (`--model sonnet`).
- **Ce qui ne lui est pas demandé :** toucher aux autres usages de `future`, revoir le
  calcul du nombre de travailleurs, changer d'autres tests, toucher au `pilotage/` de
  `nemetonshiny`.

## Harnais

- **Peut :** modifier `R/service_compute.R` (l'appel seul) ; `DESCRIPTION` (ajouter
  `parallelly` aux `Imports` s'il le faut, et la version de développement selon le
  `CLAUDE.md` du projet) ; `NEWS.md` si le `CLAUDE.md` du projet le demande ; retirer
  `service_monitoring_wiring` de la liste d'exclusion de `.claude/test-command` (et la
  mention dans son commentaire) ; ouvrir une PR (conventions du `CLAUDE.md` du projet).
- **Ne doit pas :** toucher à `main` ni au clone principal (Pascal y travaille sur la
  branche `claude/cycle-2026.11q`) : partir de `origin/main` à jour ; passer en version
  stable ; changer la CI ; fusionner sa PR.
- **Sources autorisées :** le `CLAUDE.md` du projet, `R/`, `tests/`, `DESCRIPTION`,
  `NEWS.md`, l'aide de `future` et de `parallelly`.

## Valeur provisoire (chiffre, réglage)

- **Valeur provisoire :** le test échoue seul (avertissement de dépréciation émis une fois
  par session) ; il passe dans la suite complète.
- **Mesurée par :** l'agent, avant et après : le fichier lancé seul dans une session R
  neuve.

## Dépend de / rouge attendu jusqu'à

- **Dépend de :** rien (mission 004 fusionnée). **CI rouge attendue :** aucune.

## Tests

- Avant : `test-service_monitoring_wiring.R` seul, session neuve : rouge. Après : vert.
- `test-service_compute.R` reste vert.
- `.claude/test-command` sort en code 0 sur la branche, sous 600 s.

## Qui veille, qui tranche

- **Relecteur :** `relecteur`, puis l'orchestrateur (preuve du vert, ADR 0001) qui fusionne
  par délégation si les contrôles de la spec § 5 sont verts.
- **Budget de la session :** 3 $ ; limite 5400 s (leçon de la mission 004).
- **Qui tranche :** l'orchestrateur par délégation ; une question de sens remonte à Pascal.

## Comment saura-t-on que ça marche ?

`service_monitoring_wiring` n'est plus exclu du niveau rapide, et celui-ci reste vert.
