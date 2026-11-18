# Mission 018 — marculus-tarifs-et-style

> Ouverte le 2026-11-18 sous la délégation élargie de Pascal (« code ce qu'il reste à faire
> partout sans me demander, va jusqu'au bout »), d'après l'inventaire des briefs du même jour.
> Dépôt : `marculus` (session ouverte dans le projet, ADR 0001). Fusion par l'orchestrateur quand
> les six contrôles sont verts.

## Mission

**En une phrase (quoi, et pourquoi) :** Mettre à jour dans Marculus la table des tarifs IFN d'après nemeton 2026.11.31 (numéros négatifs publiés vides, part_houppier gardée sans numéro), prendre acte des formats 6 à 8 de nemetonshiny, et réadopter le style commun terrain-style v0.7.1 qui garde le vert de Marculus, pour que l'application de martelage soit à jour avec le cœur et le style commun.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les briefs à réaliser (à lire en entier avant d'agir)

- `/home/pascal/dev/briefs/vers-marculus/2026-11-15-reponse-nemeton-tarifs-ifn-numeros-negatifs.md`
- `/home/pascal/dev/briefs/vers-marculus/2026-11-15-reponse-nemetonshiny-formats-6-8-et-tarifs.md`
- `/home/pascal/dev/briefs/vers-marculus/2026-10-23-readme-terrain-et-style-commun.md`

## Ce qui est attendu

1. Chaque demande du brief réalisée dans le code, avec ses tests ; ou, si une demande ne peut pas l'être, la raison écrite au journal du projet et dans la PR.
2. Une question de détail que le brief laisse ouverte se tranche par la valeur la plus prudente et la plus réversible, notée au journal du projet et dans la PR (délégation du 2026-11-18).
3. Le `NEWS.md` ou `CHANGELOG.md` du projet cite le brief, selon ses conventions ; la version suit le schéma du projet.
4. Aucune rupture d'un contrat public sans le dire en tête de la PR (rubrique « Ruptures ») : une rupture déclarée revient à Pascal.
5. `.claude/test-command` verte sur le dernier commit, CI de la PR verte.

## L'Homme

- **Agent :** `dev`, dans une session ouverte dans `marculus`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** budget 3 $ ; worktree depuis `origin/main`.
- **Ce qui ne lui est pas demandé :** toucher un autre dépôt ; fusionner.
