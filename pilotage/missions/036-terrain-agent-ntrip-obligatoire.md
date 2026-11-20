# Mission 036 — terrain-agent-ntrip-obligatoire

> Ouverte le 2026-11-20 au cycle 13, sur la décision de Pascal (« oui, voie A, lance-la ») : le nom envoyé au caster NTRIP devient obligatoire dans `terrain-gnss`. Rupture d'API acceptée par Pascal. Origine : relecture de la mission 035 (Groma envoyait « NTRIP Marculus » par le défaut de terrain).
> Dépôt : `terrain` (session ouverte dans le projet, ADR 0001). Fusion par l'orchestrateur quand les contrôles sont verts. **Le tag `v2026.11.2` n'est pas posé par la mission** ; l'orchestrateur le pose après la fusion seulement sur consigne de Pascal.

## Mission

**En une phrase (quoi, et pourquoi) :** Retirer la valeur par défaut `agent = "Marculus"` de `Ntrip.requete` dans `terrain-gnss`, pour que chaque application de terrain dise elle-même son nom au caster NTRIP et qu'aucune ne se présente sous le nom d'une autre sans le savoir.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les sources à lire avant d'agir

- Dans `terrain` (vérifié le 2026-11-20 sur `origin/main` 39bba22) : `CLAUDE.md`, `pilotage/`, `README.md` (§ « Publier une version », notation calendaire), `terrain-gnss/src/main/kotlin/fr/nemeton/terrain/gnss/Ntrip.kt:22-36`, `terrain-gnss/src/test/kotlin/fr/nemeton/terrain/gnss/NtripTest.kt`, les ADR du projet.
- Journal de la plateforme du 2026-11-20, lignes « relecteur · 035 » (l'écart) et « Pascal · 036 » (la décision).

## Contrat aval lu

- **Marculus** (`app/src/main/kotlin/io/github/pobsteta/marculus/gnss/ClientNtrip.kt:44`, `:110`) appelle `Ntrip.requete` sans agent et compte sur le défaut « Marculus ». Il est épinglé en `v0.5.0` (`gradle/libs.versions.toml:18`) : rien ne casse tant qu'il ne monte pas ; à sa montée, la compilation échouera jusqu'à ce qu'il passe `agent = "Marculus"`. C'est la rupture voulue.
- **Groma** (v2026.11.9) passe déjà `agent = NtripGroma.AGENT` : non touché.
- **Surculus** garde sa propre copie (`core/.../gnss/Ntrip.kt:40`, défaut « Surculus ») : non touché ; s'il adopte `terrain-gnss`, la compilation l'obligera à se nommer.
- Cas limites : agent vide ou blanc refusé (`require`, message clair) ; agent avec espace ou caractère de contrôle (`\r`, `\n`) refusé, car il finirait dans une ligne d'en-tête HTTP.

## Ce qui est attendu

1. `Ntrip.requete` : paramètre `agent` sans valeur par défaut ; validation des cas limites ci-dessus. Aucune autre signature ne change.
2. Tests : les appels de `NtripTest` passent un agent ; un test par cas limite ; un test que la ligne `User-Agent: NTRIP <agent>` reprend exactement le nom passé.
3. Rupture déclarée : rubrique « Ruptures » en tête de la PR, titre de PR et commit avec `!` (`feat(gnss)!: …`) si le projet suit Conventional Commits ; note au `README.md` (ou à la doc de `terrain-gnss`) : « depuis v2026.11.2, `agent` est obligatoire » et l'appel à écrire.
4. Journal du projet en ajout seul ; ADR du projet seulement si le projet consigne ses API en ADR (note datée, sans réécriture).
5. Un mot aux avals : `~/dev/briefs/vers-marculus/2026-11-20-terrain-agent-ntrip-obligatoire.md` (à la prochaine montée de terrain, passer `agent = "Marculus"` aux deux appels de `ClientNtrip.kt`) et le même, pour information, dans `vers-surculus/`.
6. `.claude/test-command` (`./gradlew test`) verte ; CI verte.

## L'Homme

- **Agent :** `dev`, dans une session ouverte dans `terrain`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** budget 2 $ ; worktree depuis `origin/main`.
- **Ce qui ne lui est pas demandé :** poser un tag ou une release ; toucher Marculus, Surculus, Groma ou un autre dépôt (sauf les deux boîtes de briefs nommées) ; retaguer ; fusionner.
- **Dépend de / rouge attendu jusqu'à :** rien.
