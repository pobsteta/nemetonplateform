# Mission 013 — que la CI de sommieR ne perde plus trente minutes avant le premier test

> Ouverte sur le « oui » de Pascal au bilan du 2026-11-18 (cycles 5 à 7, question 1), pour
> le cycle 8. Dépôt : `sommieR` (session ouverte dans le projet, ADR 0001).

## Mission

**En une phrase (quoi, et pourquoi) :** Trouver pourquoi l'installation des dépendances R de la CI de sommieR prend vingt minutes et plus malgré le cache déjà en place, et la corriger, pour qu'une PR ne soit plus rouge sans qu'aucun test ait tourné.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les faits

- PR sommieR #71 (documentation seule, 2026-11-18) : job `tests` rouge deux fois. Premier essai : `Install R dependencies` arrêtée par le délai du job (30 min). Deuxième : `Setup R` 8 min (délai atteint, seconde tentative), installation 20 min (délai de l'étape), puis seconde tentative en échec sur `sudo` (apt). Troisième essai vert (27 min 57 s). `pkgdown` : même chose au premier essai.
- Le cache existe déjà : `r-lib/actions/setup-r-dependencies@v2`, `.github/workflows/r.yml:131-147` et `253-270`, avec seconde tentative. Un cache chaud tient en quatre minutes, selon le commentaire de `r.yml:127`.
- À lire avant d'agir (règle du bilan : vérifier chaque chemin dans le projet) : `r.yml` en entier, les journaux des jobs de la PR #71 (`gh run view`), et les clés de cache utilisées sur une branche de PR par rapport à `main`.

## Critères d'acceptation

1. La cause est écrite au journal de sommieR, avec sa preuve : clé de cache manquée, binaires compilés depuis les sources, miroir apt lent, ou autre.
2. La correction est dans `r.yml`. Sur une PR sans changement de dépendances, l'étape `Install R dependencies` tient sous 8 min, mesurée sur deux exécutions.
3. La suite complète des tests reste en CI, inchangée, et la `.claude/test-command` reste verte.

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? | à vérifier : diagnostic d'abord, correction ensuite | il s'arrête et dit ce qu'il a trouvé si la cause est hors de `r.yml` |
| A-t-il les moyens ? | oui : session `claude -p` ouverte dans sommieR, budget 3 $, `gh` en lecture des runs | |

**Temps de la main :** appuyer.

## L'Homme

- **Agent :** `dev`, dans une session ouverte dans `sommieR`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Ce qui ne lui est pas demandé :** toucher au code R ou aux tests ; retirer la seconde tentative sans preuve.

## Dépend de / rouge attendu jusqu'à

Rien.
