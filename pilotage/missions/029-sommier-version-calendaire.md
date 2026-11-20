# Mission 029 — sommier-version-calendaire

> Ouverte le 2026-11-20 sur décision de Pascal au bilan : « passe les tags, releases, et versionning de sommieR sous la forme yyyy.mm.xxx ». Forme retenue par délégation (journal du 2026-11-20) : celle de `nemeton`, `AAAA.M.N`.
> Dépôt : `sommieR` (session ouverte dans le projet, ADR 0001). Fusion par l'orchestrateur quand les contrôles sont verts.

## Mission

**En une phrase (quoi, et pourquoi) :** Faire passer les versions, tags et releases de sommieR au versionnage calendaire `AAAA.M.N` de `nemeton`, première version 2026.11.1, pour qu'une seule convention de version vaille sur la plateforme.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les sources à lire avant d'agir

- La convention à reprendre, en lecture seule : `/home/pascal/dev/nemeton/CLAUDE.md` § « Consignes de release pour ce projet » (vers la l. 327 à 375 : `AAAA.M.N`, mois sans zéro en tête, N repart à 1 chaque mois, cycle de dev `AAAA.M.N.9000`, entrée NEWS datée `# nemeton AAAA.M.N (AAAA-MM-JJ)` et garde-fou année/mois), et ses workflows `/home/pascal/dev/nemeton/.github/workflows/release.yml` et le job `version-consistency` de `r.yml`.
- Dans sommieR : `CLAUDE.md` (sa règle de version actuelle), `.github/workflows/release.yml` (n'accepte aujourd'hui que `X.Y.Z` stable), le job `version-consistency` de `.github/workflows/r.yml`, `DESCRIPTION`, `NEWS.md`, `CITATION.cff`.

## Contrat aval lu

- Aucun aval n'épingle une version de sommieR (vérifié le 2026-11-20 : `nemetonshiny`, `nemetonmcp`, `surculus`, `terrain`, `marculus` ; les specs de Surculus citent des versions de sommieR seulement comme mémoire, « sommieR 0.28.0 »). Ne pas toucher ces dépôts.
- L'ordre des versions doit rester croissant : `package_version("2026.11.1") > package_version("0.44.0")`. Un test le dit.
- Cas limites : mois à un chiffre (`2026.1.1`, jamais `2026.01.1`) ; changement de mois (N repart à 1) ; version de dev `AAAA.M.N.9000` ignorée par `release.yml`.

## Ce qui est attendu

1. `DESCRIPTION`, `CITATION.cff` (`version:` et `date-released:`) et `NEWS.md` passent à `2026.11.1`, avec une entrée NEWS datée `# sommieR 2026.11.1 (2026-11-20)` qui dit le changement de convention (les versions 0.x restent dans NEWS, rien n'est réécrit).
2. `release.yml` et `version-consistency` acceptent `AAAA.M.N` (et vérifient, comme `nemeton`, que année et mois de la version sont ceux de la date de l'entrée NEWS), en reprenant le code de `nemeton` plutôt qu'en le réinventant.
3. Le `CLAUDE.md` de sommieR décrit la nouvelle règle (renvoi à celle de `nemeton`, sans la recopier en entier si un lien suffit).
4. Tests : la cohérence de version (DESCRIPTION = NEWS = CITATION, année et mois) a un test qui échouerait sur `2026.01.1`, sur une date NEWS d'un autre mois, et passerait sur `2026.11.1`. `.claude/test-command` verte ; CI verte.
5. Journal du projet en ajout seul.

Aucune rupture : seul le format du numéro change, l'ordre est gardé.

## L'Homme

- **Agent :** `dev`, dans une session ouverte dans `sommieR`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** budget 3 $ ; worktree depuis `origin/main`.
- **Ce qui ne lui est pas demandé :** toucher un autre dépôt ; poser un tag ou une release à la main ; fusionner.
- **Dépend de / rouge attendu jusqu'à :** rien. La mission 028 attend la fusion de celle-ci (mêmes fichiers de version).
