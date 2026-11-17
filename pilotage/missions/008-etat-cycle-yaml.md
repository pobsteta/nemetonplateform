# Mission 008 — l'état du dernier cycle (`pilotage/etat-cycle.yaml`)

> Inscrite pour le cycle 4 sur le « oui » de Pascal du 2026-11-17. Rangement de la
> plateforme : dans la délégation élargie du 2026-11-16 (`pilotage/equipe.md`). Dépôt :
> `nemetonplateforme`. Aucun dépôt de projet n'est touché.

## Mission

**En une phrase (quoi, et pourquoi) :** Écrire `pilotage/etat-cycle.yaml` au format de `docs/spec.md` § 3, avec pour chacun des treize projets le dernier tag vu, le SHA lu sur sa branche par défaut et la date de lecture, pour que le cycle suivant ne regarde que ce qui a changé depuis (critère d'acceptation n° 1 de la spec).

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? | oui : `git ls-remote --tags` et `git ls-remote` (ou `gh api`) en lecture seule ; le format est dans la spec § 3 | |
| A-t-il les moyens ? | oui : `gh` authentifié, clones dans `~/dev/` ; `aigora-nemeton` se lit dans son clone local | |

**Temps de la main :** appuyer.

## Ma réponse d'abord

_Rempli par Pascal seul._ (Pascal a délégué : sans objet.)

## L'Homme

- **Agent :** `archiviste`. **Modèle :** sonnet.
- **Ce qui ne lui est pas demandé :** décrire les changements depuis le dernier cycle ;
  écrire des briefs ; écrire un script qui régénère le fichier.

## Harnais

- **Peut :** créer `pilotage/etat-cycle.yaml` ; ouvrir une PR vers `main` de ce dépôt.
- **Ne doit pas :** écrire dans un dépôt de projet, ni y faire `git fetch` dans le clone
  principal (lire le distant par `git ls-remote` ou `gh`) ; lire `aigora-nemeton/missions/` ;
  toucher aux autres fichiers de `pilotage/` ; fusionner sa PR.
- **Sources autorisées :** `docs/spec.md` (§ 3), `docs/carte.yaml` (mission 007), GitHub
  en lecture seule, les clones de `~/dev/` en lecture seule.

## Contenu attendu

Pour chaque projet de `docs/carte.yaml` : `dernier_tag_vu` (ou `null`), `main_lu` (SHA
complet de la branche par défaut, nommée dans `branche` si ce n'est pas `main`),
`lu_le` (2026-MM-JJ), et `lu_sur` (`github` ou `clone local`).

## Valeur provisoire (chiffre, réglage)

- **Valeur provisoire :** treize projets, aucun sans `main_lu`.
- **Mesurée par :** l'agent, puis l'orchestrateur, qui recoupe trois SHA au hasard.

## Dépend de / rouge attendu jusqu'à

- **Dépend de :** mission 007 fusionnée (la liste des projets et leurs dépôts viennent de
  `docs/carte.yaml`). **CI rouge attendue :** aucune.

## Tests

- Le YAML se lit sans erreur ; ses clés sont exactement les projets de `docs/carte.yaml`.
- Chaque `main_lu` est un SHA de 40 caractères qui existe sur le distant (ou le clone
  local pour `aigora-nemeton`).

## Qui veille, qui tranche

- **Relecteur :** `relecteur`, puis l'orchestrateur, qui fusionne par délégation (PR de
  pilotage de ce dépôt).
- **Qui tranche :** l'orchestrateur.

## Comment saura-t-on que ça marche ?

Le cycle 4 s'ouvre en lisant ce fichier et ne liste que les projets dont le tag ou la
branche par défaut ont bougé.
