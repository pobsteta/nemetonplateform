# Mission 031 — nemetonshiny-hebergeur-hostinger

> Ouverte le 2026-11-20 au cycle 10, sous la délégation du 2026-11-18, sur le brief `~/dev/briefs/vers-nemetonshiny/2026-11-19-hebergeur-connecteur-hostinger.md` (décision de Pascal du 2026-11-19).
> Dépôt : `nemetonshiny` (session ouverte dans le projet, ADR 0001). Fusion par l'orchestrateur quand les contrôles sont verts.

## Mission

**En une phrase (quoi, et pourquoi) :** Ajouter une note datée là où le brief et l'ADR 0003 de nemetonshiny nomment OVH comme hébergeur du connecteur distant, pour que la documentation du projet dise la décision de Pascal (Hostinger) sans réécrire l'histoire.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les sources à lire avant d'agir

- Le brief, en entier : `/home/pascal/dev/briefs/vers-nemetonshiny/2026-11-19-hebergeur-connecteur-hostinger.md`.
- La décision : `/home/pascal/dev/nemetonplateforme/docs/adr/0002-ia-ouverte-a-tous.md` (note datée du 2026-11-19) et `/home/pascal/dev/nemeton/docs/ARCHITECTURE-nemeton-llm.md` § « Déploiement sur VPS Hostinger » (lecture seule).
- Dans nemetonshiny : son `CLAUDE.md`, son brief « accès de l'IA ouvert à tous » et son ADR 0003 (les trouver par `git grep -n -i "ovh"` sur `origin/main`).

## Contrat aval lu

- Documentation seule : rien dans le code, aucun aval touché. Une ADR acceptée ne se réécrit pas : on ajoute une note datée qui renvoie à la décision.

## Ce qui est attendu

1. À chaque mention d'OVH (ou OVHcloud, Scaleway) comme hébergeur du déploiement dans le brief et l'ADR 0003 : une note datée « 2026-11-19, Pascal : hébergeur Hostinger » avec le lien vers l'ADR 0002 de la plateforme. Les autres mentions (comparaisons, historique) restent telles quelles.
2. Convention de version et de NEWS du projet pour un changement de documentation seule (si le projet n'en publie pas pour la doc, ne rien publier) ; journal en ajout seul ; CI verte.
3. Le brief rangé dans `~/dev/briefs/traites/`, ligne à `traites/INDEX.md`. Le brief voisin `vers-nemetonshiny/2026-11-18-reponse-sommier-actions-realisees.md` dit « à fusionner » alors que sommieR #80 est fusionnée (0.41.0) : le ranger aussi s'il a été lu et suivi par nemetonshiny (sinon le laisser et le dire).

## L'Homme

- **Agent :** `dev`, dans une session ouverte dans `nemetonshiny`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** budget 1 $ ; worktree depuis `origin/main` (le clone local est sur une autre branche de travail : ne pas y toucher).
- **Ce qui ne lui est pas demandé :** toucher au code ; réécrire une ADR ; fusionner.
- **Dépend de / rouge attendu jusqu'à :** rien.
