# ADR 0002 — le pilotage par IA ouvert à tous, derrière Keycloak, avec tout client MCP

- **Date :** 2026-11-18 (report d'une décision prise le 2026-11-15)
- **Statut :** acceptée par Pascal le 2026-11-15 (option A), dans l'ADR 0003 de
  `nemetonshiny` ; reportée ici à la demande de ce projet, sans changement de fond
- **Proposée par :** Claude (orchestrateur de `nemetonshiny`, le 2026-10-24)
- **Tranchée par :** Pascal, le 2026-11-15 (« A »)
- **Source de la décision :** `nemetonshiny/pilotage/adr/0003-acces-tous-souverainete.md`
  et le brief `nemetonshiny/briefs/vers-platform_nemeton/2026-11-15-adr-0003-acces-tous.md`
  (déposé le 2026-11-15). Cet ADR ne décide rien de neuf : il rend la décision lisible
  dans `docs/`.

## La décision en une phrase

Le pilotage par IA est ouvert à tous les utilisateurs par le connecteur distant de
`nemetonmcp`, derrière Keycloak (ADR-005), pour tout client MCP. On accepte que des
données de projet soient lues par le fournisseur du client IA de l'utilisateur, et c'est
dit à l'utilisateur ; `nemetonshiny` reste neutre vis-à-vis du fournisseur.

## Contexte

Arbitrage 3 de `nemetonshiny` : « pour tous les utilisateurs ». Le serveur MCP est
aujourd'hui local (stdio), sur le poste de Pascal. Le connecteur distant existe
(`nemetonmcp/r/R/distant.R` : JWT Keycloak, `127.0.0.1:8765`) mais n'est pas déployé : le
dernier essai de tunnel a renvoyé une 502 le 2026-10-12. L'ADR-004 retient Mistral par
souveraineté ; or Claude (Anthropic) est le client d'AIGORA et de VICTOR, et le brief
VICTOR déclarait les données de projet confidentielles.

### Options (telles que posées dans l'ADR 0003 de `nemetonshiny`)

- **A. Distant, tout client MCP, avertissement à l'utilisateur** : **retenue**.
- **B. Distant, réservé à un client souverain** (Mistral Le Chat s'il parle MCP, ou client
  auto-hébergé) : plus conforme à l'ADR-004, mais dépend d'un client qui reste à trouver.
- **C. Local seulement** : contredit l'arbitrage 3.

## Le crible FRANCE

Repris de l'ADR 0003 de `nemetonshiny` ; « prêts à payer » : Pascal, 2026-11-15.

| Lettre | Question | Réponse (une ligne) | Ce que ça coûte | Prêts à payer ? |
|---|---|---|---|---|
| **F**rugale | La plus simple qui tienne ? | A réutilise `distant.R` et Keycloak existants | un déploiement à faire | Oui |
| **R**esponsable | Qui fait quoi ? | `nemetonmcp` sert ; la plateforme déploie ; `nemetonshiny` garantit l'API et les gardes | trois dépôts | Oui |
| **A**nticiper | Et si l'imprévu arrive ? | fuite de données de projet vers un tiers ; fournisseur qui change ses conditions | réputation, RGPD | Oui |
| **N**ovateur | Toutes les idées écoutées ? | A, B, C ; B mérite une veille | — | — |
| **C**oût | Dépense inutile ? | hébergement et maintenance du connecteur distant | — | Oui |
| **É**cologique | Que réutilise-t-on ? | standard MCP : tout client compatible | — | Oui |

## Valeurs sacrifiées

- **La souveraineté** (ADR-004) et **la confidentialité des projets**, au profit de
  **l'accès pour tous** par les interfaces IA du marché. Le sacrifice est rendu visible à
  l'utilisateur.
- **Exception assumée à l'ADR-004** (Mistral, souveraineté numérique) : pour le client IA
  que l'utilisateur choisit, le fournisseur peut être non européen (Claude/Anthropic en
  est le cas connu). L'ADR-004 reste la règle pour le LLM que Néméton appelle lui-même
  (perspectives IA) ; l'exception ne vise que le client de l'utilisateur.
- **Condition de révision** : rouvrir la décision en faveur de l'**option B** si un client
  souverain parlant MCP apparaît. Veille à tenir ; qui la tient reste à nommer (voir
  « Trous »).

## Liens aux ADR plateforme cités

| ADR | Sujet | Où le lire |
|---|---|---|
| ADR-003 | Hébergement et infrastructure (OVHcloud + Scaleway GPU, Mars 2026) | `docs/ADR-001-010_Nemeton_i18n.odt` (et `.pdf`) ; pas de version Markdown |
| ADR-004 | Modèle LLM : Mistral, souveraineté (Mars 2026) | `docs/ADR-001-010_Nemeton_i18n.odt` (et `.pdf`) |
| ADR-005 | Authentification et droits : OAuth2/OIDC, Keycloak en phase européenne (Mars 2026) | `docs/ADR-001-010_Nemeton_i18n.odt` (et `.pdf`) |

Écart à connaître : `docs/ARCHITECTURE-nemeton-llm.md` (§ Déploiement sur VPS Hostinger)
écrit que le déploiement sur un VPS Hostinger en France, avec OAuth Keycloak, « remplace
l'ADR-003 (OVHcloud + Scaleway) ». Le brief de `nemetonshiny` et son ADR 0003 parlent
encore d'un déploiement OVH. **L'hébergeur du connecteur distant est donc à confirmer par
Pascal** ; cet ADR ne le tranche pas. Il n'existe pas d'ADR dédié à ce remplacement dans
`docs/`.

> **Tranché par Pascal le 2026-11-19 : Hostinger.** Le connecteur distant est hébergé sur un
> VPS Hostinger, comme le décrit `docs/ARCHITECTURE-nemeton-llm.md` ; l'ADR-003 (OVHcloud +
> Scaleway) est remplacée sur ce point. Brief déposé vers `nemetonshiny`, dont le brief et
> l'ADR 0003 parlent encore d'OVH.

## Le reste à faire, hors de ce dépôt (non fait ici)

- **`nemetonmcp`** : déployer le connecteur distant (`r/R/distant.R`) derrière Keycloak ;
  dernier essai de tunnel en 502 le 2026-10-12. Brief à émettre au moment du déploiement.
- **Avertissement à l'utilisateur** : avant le premier usage, dire que les données du
  projet lues par l'IA passent chez le fournisseur de son client IA. Où et comment il
  s'affiche reste à décider, avec `nemetonmcp`.
- **`nemetonshiny`** : rien à changer ; l'application garde ses gardes (confirmation des
  écritures, ADR 0002 de `nemetonshiny`).

## Trous de mémoire relevés

- ADR-003/004/005 n'existent qu'en `.odt`/`.pdf` (un seul fichier pour ADR-001 à 010) :
  pas de lien direct vers une section.
- Hébergeur du connecteur : OVH (brief) ou Hostinger (`ARCHITECTURE-nemeton-llm.md`). _(Tranché le 2026-11-19 : Hostinger.)_
- Propriétaire de la veille sur l'option B : non nommé dans la source.

## Sources

- `nemetonshiny/pilotage/adr/0003-acces-tous-souverainete.md` (lu dans le dépôt local
  `~/dev/nemetonshiny`) ; brief du 2026-11-15 cité plus haut.
- `docs/ADR-001-010_Nemeton_i18n.odt` (ADR-003, 004, 005) ; `docs/ARCHITECTURE-nemeton-llm.md`.

## Question de contrôle

Cette décision tient-elle nos six valeurs, et que sommes-nous prêts à payer pour cela ?
