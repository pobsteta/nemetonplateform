# Mission 009 — plus d'appel déprécié à `future::availableCores()` dans les tests (`nemetonshiny`)

> Ouverte sur le « oui » de Pascal du 2026-11-17 (bilan des cycles 3 et 4, question 1),
> pour le cycle 5. Suite de la mission 005. Dépôt : `nemetonshiny`. Exécutée par une
> session ouverte dans ce dépôt (`claude -p -w`, ADR 0001).

## Mission

**En une phrase (quoi, et pourquoi) :** Remplacer, dans `tests/testthat/test-service_compute.R` de `nemetonshiny`, les deux appels restants à `future::availableCores()` (l. 5381 et 5398 sur `origin/main` au 2026-11-17) par `parallelly::availableCores()`, pour que ces tests comparent au même plafond que celui que calcule `.resolve_parallel_workers()` depuis la mission 005, sans avertissement de dépréciation.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? | oui : deux appels à changer, même remplacement que la mission 005 ; `parallelly` est déjà dans les `Imports` | |
| A-t-il les moyens ? | oui : R et paquets sur le PC, `.claude/test-command` versionnée | |

**Temps de la main :** appuyer.

## Ma réponse d'abord

_Rempli par Pascal seul._ (Pascal a délégué : sans objet.)

## L'Homme

- **Agent :** `dev`. **Modèle :** sonnet (`--model sonnet`).
- **Ce qui ne lui est pas demandé :** toucher à `R/` ; changer d'autres tests ou d'autres
  usages de `future` ; changer `.claude/test-command` ; toucher au `pilotage/` de
  `nemetonshiny`.

## Harnais

- **Peut :** modifier les deux appels dans `tests/testthat/test-service_compute.R` (et un
  `skip_if_not_installed("future")` qui ne garderait que ces appels, s'il y en a un) ;
  `DESCRIPTION` (version de développement selon le `CLAUDE.md` du projet) ; `NEWS.md` si
  le `CLAUDE.md` du projet le demande ; ouvrir une PR (conventions du projet).
- **Ne doit pas :** toucher à `main` ni au clone principal (Pascal y travaille) : partir
  de `origin/main` à jour ; passer en version stable ; changer la CI ; fusionner sa PR.
- **Sources autorisées :** le `CLAUDE.md` du projet, `tests/`, `R/service_compute.R` (en
  lecture), `DESCRIPTION`, `NEWS.md`, l'aide de `future` et de `parallelly`.

## Valeur provisoire (chiffre, réglage)

- **Valeur provisoire :** 2 appels à `future::availableCores()` restants dans `tests/`.
- **Mesurée par :** l'agent, avant et après (`grep -rn "future::availableCores" R/ tests/`) :
  0 attendu.

## Dépend de / rouge attendu jusqu'à

- **Dépend de :** mission 005 fusionnée (3a00990). **CI rouge attendue :** aucune.

## Tests

- `test-service_compute.R` vert, sans avertissement de dépréciation de `future`.
- `.claude/test-command` sort en code 0 sur la branche, sous 600 s.

## Qui veille, qui tranche

- **Relecteur :** `relecteur`, puis l'orchestrateur (preuve du vert, ADR 0001) qui fusionne
  par délégation si les contrôles de la spec § 5 sont verts.
- **Budget de la session :** 3 $ ; limite 5400 s.
- **Qui tranche :** l'orchestrateur par délégation ; une question de sens remonte à Pascal.

## Comment saura-t-on que ça marche ?

`grep -rn "future::availableCores" R/ tests/` ne trouve plus rien dans `nemetonshiny`.
