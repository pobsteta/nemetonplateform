# Mission 012 — combler les trous de mémoire relevés au bilan des cycles 5 à 7

> Ouverte au bilan du 2026-11-18 (cycles 5 à 7), pour le cycle 8. Rangement de la
> plateforme : dans la délégation élargie du 2026-11-16. Dépôt : `nemetonplateforme`.
> Aucun dépôt de projet n'est touché, sauf `~/dev/briefs/README.md` (hors dépôt git).

## Mission

**En une phrase (quoi, et pourquoi) :** Reporter dans les documents qui font foi ce qui ne vit aujourd'hui que dans le journal ou la mémoire de l'orchestrateur, et dater ce qui est périmé, pour qu'un successeur reprenne la plateforme demain et sache en une minute où en est le travail.

**Redite par l'agent :** Reporter dans les documents qui font foi (README, `CLAUDE.md`, brief, spec, carte, ADR 0001, équipe) ce qui ne vit que dans le journal, et dater ce qui est périmé, pour qu'un successeur sache en une minute où en est le travail, sans réécrire l'histoire. _(archiviste, 2026-11-18)_

## Ce qui est à faire (rapport de l'archiviste du 2026-11-18)

1. `README.md` : une quinzaine de lignes (rôle, liens vers `CLAUDE.md`, `pilotage/kanban.md`, `pilotage/journal.md` ; où regarder ce qui attend), sans recopier l'état.
2. Les sections « à trancher par ADR » périmées (`CLAUDE.md` « Ce qui ne marche pas encore d'un dépôt à l'autre », `docs/carte-dependances.md` même section, `docs/brief.md` « Préalables bloquants », `docs/spec.md` l. 9 et critère 7) : note datée « tranché par l'ADR 0001 (acceptée le 2026-11-16) », sans effacer l'historique de `brief.md` et `spec.md`.
3. Les traces de session (`~/.cache/nemetonplateforme/mNNN/` : flux, schéma, preuve ; jetables, le journal fait mémoire) : ajout daté à `docs/adr/0001-agir-dans-un-autre-depot.md`.
4. La convention de fusion : un champ `fusion: squash|merge` par projet de `docs/carte.yaml`, avec sa preuve (lignes du journal 45, 55, 56, 66, 68, 78, 88, 132).
5. Le statut « seulement observé » (`aigora`, `aigora-nemeton`) dans `CLAUDE.md` (renvoi à `carte.yaml`) et note datée en `docs/spec.md` § 7 et § 10 ; `sylvostation` piloté (spec l. 143-145) ; question close en `carte-dependances.md` (porte n° 3 d'aigora-nemeton).
6. La règle « un lien suit la dépendance technique » (Pascal, 2026-11-17) datée dans l'en-tête de `docs/carte.yaml`, dont le compte « quatre à `non` » devient « un ».
7. Comptes « treize projets » : note datée (quatorze) dans `docs/spec.md` et `docs/brief.md`.
8. Le tableau des missions de `pilotage/equipe.md` complété de 004 à 013.
9. `~/dev/briefs/README.md` : les 15 boîtes `vers-*`.

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? | oui : chaque point cite son fichier et sa ligne ; vérifier chacun avant d'écrire | |
| A-t-il les moyens ? | oui : écriture dans ce dépôt, en worktree | |

**Temps de la main :** appuyer.

## L'Homme

- **Agent :** `archiviste`. **Modèle :** sonnet.
- **Ce qui ne lui est pas demandé :** réécrire l'histoire (le journal reste en ajout seul) ; trancher les ADR 2 et 3 de la spec (carte YAML, boîte `~/dev/briefs/`) : il dit seulement si le journal les clôt.

## Dépend de / rouge attendu jusqu'à

Rien.
