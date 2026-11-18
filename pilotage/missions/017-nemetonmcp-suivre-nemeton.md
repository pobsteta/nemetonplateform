# Mission 017 — nemetonmcp-suivre-nemeton

> Ouverte le 2026-11-18 sous la délégation élargie de Pascal (« code ce qu'il reste à faire
> partout sans me demander, va jusqu'au bout »), d'après l'inventaire des briefs du même jour.
> Dépôt : `nemetonmcp` (session ouverte dans le projet, ADR 0001). Fusion par l'orchestrateur quand
> les six contrôles sont verts.

## Mission

**En une phrase (quoi, et pourquoi) :** Faire suivre à nemetonmcp les releases 2026.11.32 à 2026.11.34 de nemeton (régénération par le froid d'hiver avec regen_tmin_decennale() à la place du contournement à −15 °C, sources W1 avec spring_layer = "water_points", avertissement d_tmax du microclimat, plancher nemeton relevé), pour que l'assistant donne les réponses du cœur à jour.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les briefs à réaliser (à lire en entier avant d'agir)

- `/home/pascal/dev/briefs/vers-nemetonmcp/2026-11-16-reponse-nemeton-regen-froid-hiver.md`
- `/home/pascal/dev/briefs/vers-nemetonmcp/2026-11-16-reponse-nemeton-w1-sources.md`
- `/home/pascal/dev/briefs/vers-nemetonmcp/2026-11-16-reponse-nemeton-microclimf-surchauffe.md`

## Ce qui est attendu

1. Chaque demande du brief réalisée dans le code, avec ses tests ; ou, si une demande ne peut pas l'être, la raison écrite au journal du projet et dans la PR.
2. Une question de détail que le brief laisse ouverte se tranche par la valeur la plus prudente et la plus réversible, notée au journal du projet et dans la PR (délégation du 2026-11-18).
3. Le `NEWS.md` ou `CHANGELOG.md` du projet cite le brief, selon ses conventions ; la version suit le schéma du projet.
4. Aucune rupture d'un contrat public sans le dire en tête de la PR (rubrique « Ruptures ») : une rupture déclarée revient à Pascal.
5. `.claude/test-command` verte sur le dernier commit, CI de la PR verte.

## L'Homme

- **Agent :** `dev`, dans une session ouverte dans `nemetonmcp`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** budget 3 $ ; worktree depuis `origin/main`.
- **Ce qui ne lui est pas demandé :** toucher un autre dépôt ; fusionner.
