# Mission 010 — confirmer les six liens « à confirmer » de la carte

> Ouverte sur le « oui » de Pascal du 2026-11-17 (bilan des cycles 3 et 4, question 6),
> pour le cycle 5. Rangement de la plateforme : dans la délégation élargie du 2026-11-16.
> Dépôt : `nemetonplateforme`. Aucun dépôt de projet n'est touché.

## Mission

**En une phrase (quoi, et pourquoi) :** Vérifier, en lecture seule dans le code des deux projets de chaque lien, les six liens `confirme: non` de `docs/carte.yaml`, et pour chacun le passer à `confirme: oui` avec une source de chaque côté, ou le retirer s'il n'existe pas, ou le laisser à `non` avec la raison, pour que l'orchestrateur puisse se fier à la carte pour trouver l'aval d'un changement.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les six liens

1. `surculus` ← `nemetonshiny` : plan d'action (`export_action_plan_gpkg`).
2. `nemeton` ← `surculus` : bilan de gestion et indicateurs.
3. `nemeton` ← `ramulus` : format commun `deperis.gpkg`.
4. `groma` ← `nemeton` : briefs.
5. `groma` ← `nemetonshiny` : briefs.
6. `aigora-nemeton` ← `victor` : lancement à la voix, **sens à vérifier**.

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? | oui : un lien est confirmé quand le code de l'aval lit ce que l'amont écrit (fonction, fichier, format, outil MCP), sources citées des deux côtés | |
| A-t-il les moyens ? | oui : lecture seule des clones par `git show origin/main:<fichier>` (`aigora-nemeton` : sa branche `main` locale) | |

**Temps de la main :** appuyer.

## Ma réponse d'abord

_Rempli par Pascal seul._ (Pascal a délégué : sans objet.)

## L'Homme

- **Agent :** `archiviste`. **Modèle :** sonnet.
- **Ce qui ne lui est pas demandé :** chercher de nouveaux liens (il les signale sans les
  ajouter) ; corriger les autres liens ; écrire dans un projet.

## Harnais

- **Peut :** modifier les six liens de `docs/carte.yaml` (`confirme`, `source`, `par`,
  `nature`, sens si le code le prouve sans ambiguïté) ; mettre à jour en conséquence le
  schéma et les décomptes de `docs/carte-dependances.md` ; ouvrir une PR vers `main` de ce
  dépôt.
- **Ne doit pas :** écrire dans un dépôt de projet ni y faire `git fetch` ; lire
  `aigora-nemeton/missions/` ; trancher un lien dont le sens reste douteux après lecture
  (il reste à `confirme: non` avec la question) ; toucher à `pilotage/` ; fusionner sa PR.
- **Sources autorisées :** `docs/carte.yaml`, `docs/carte-dependances.md`, les clones de
  `~/dev/` en lecture seule, `~/dev/briefs/` (y compris `traites/`, pour les liens par
  briefs).

## Valeur provisoire (chiffre, réglage)

- **Valeur provisoire :** 6 liens `confirme: non` sur 20.
- **Mesurée par :** l'agent, puis le `relecteur` qui relit chaque nouvelle source.

## Dépend de / rouge attendu jusqu'à

- **Dépend de :** 007 et 008 (fusionnées). **CI rouge attendue :** aucune.

## Tests

- `docs/carte.yaml` se lit ; chaque `amont` et `aval` est un projet ; chaque lien a une
  `source`.
- Chaque lien passé à `confirme: oui` cite une source de chaque côté (amont et aval).
- Aucun cycle dans les liens de code.

## Qui veille, qui tranche

- **Relecteur :** `relecteur`, puis l'orchestrateur, qui fusionne par délégation.
- **Qui tranche :** l'orchestrateur pour ce que le code prouve ; un sens douteux remonte à
  Pascal au bilan.

## Comment saura-t-on que ça marche ?

Il ne reste dans `docs/carte.yaml` que des liens `confirme: non` accompagnés d'une
question précise pour Pascal.
