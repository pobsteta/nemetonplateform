# Journal de nemetonplateform

> **Règle du sommier : on n'efface pas, on ajoute.**
> Chaque inscription est datée et signée (agent ou personne). Une correction est une
> nouvelle ligne qui renvoie à l'ancienne. Un hook refuse toute modification qui
> supprimerait ou réécrirait une inscription existante.
>
> Format : `AAAA-MM-JJ · auteur · mission · ce qui a été fait / décidé / bloqué`
>
> **Le carnet des écarts** (fiche n° 3), en une ligne marquée `écart` :
> `AAAA-MM-JJ · auteur · mission · écart · attendu : … · vu : … · vérifié : comment (ou « non ») · décision : …`
> La décision est l'une des trois : **garder** (vérifié : on adopte), **creuser** (prochain
> essai, daté), **abandonner** (vrai hasard : on le note).
> Règle : on ne sanctionne pas un écart signalé ; on regarde d'abord, on corrige ensuite,
> s'il le faut.
>
> **Les changements de cap** (fiche n° 13), en une ligne marquée `cap`, signée par qui l'a
> décidé : `AAAA-MM-JJ · auteur · mission · cap · ancien → nouveau · pourquoi : … · fait : …`

2026-11-16 · Claude (orchestrateur) · — · méthode installée à la demande de Pascal, par PR, hors session Claude Code : `.claude/settings.json` (plugin `imperatrice@pobsteta`), `CLAUDE.md`, `docs/brief.md`, `docs/carte-dependances.md`, `pilotage/` (équipe, kanban, journal, missions), `docs/adr/`. Reste à remplir : `docs/brief.md` en entier, à commencer par la réponse de Pascal (`/imperatrice:brief`) ; la validation des règles proposées dans `CLAUDE.md`, de la carte et du plafond global de `pilotage/equipe.md` ; les ADR sur le hook de tests et les worktrees d'un dépôt à l'autre. Pas de `.claude/test-command` : ce dépôt n'a pas de code.
2026-11-16 · Claude (orchestrateur) · — · écart · attendu : `.claude/rules` est un dossier de règles · vu : c'est un fichier, dont le contenu date d'avant l'extraction de nemetonshiny (il cite `shiny.i18n`) · vérifié : lecture du fichier ; non vérifié : si Claude Code le charge · décision : à trancher par Pascal (laissé tel quel)
2026-11-16 · Claude (orchestrateur) · brief · réponse d'abord de Pascal recopiée mot pour mot ; brief rédigé à partir de sa réponse, de `CLAUDE.md` et de la carte (propositions retenues par défaut, à sa demande) ; hors périmètre retenu ; `terrain`, `marculus`, `surculus`, `ramulus`, `groma` puis `sylvostation` ajoutés aux projets pilotés par Pascal ; brief relu et retenu par Pascal.
2026-11-16 · contradicteur · brief · brief critiqué : 7 objections (graphe cyclique et deux chaînes ; dépendance R flottante contre Gradle épinglée ; revdepcheck avant release ; signalement des ruptures ; plafond global contre plafonds locaux ; limites du plugin bloquantes ; déclencheur, état et release non définis).
2026-11-16 · Pascal · brief · retient toutes les propositions de l'orchestrateur sur la critique (points 1 à 4, 6 et 7), reportées dans `docs/brief.md` ; le point 5 (plafond global contre plafonds locaux) reste à trancher.
2026-11-16 · Pascal · — · cap · nom du dépôt : nemetonplateform → nemetonplateforme · pourquoi : en français on écrit « plateforme », et le suffixe se colle à nemeton comme pour nemetonshiny et nemetonmcp · fait : dépôt GitHub renommé, titres et carte mis à jour ; briefs à déposer dans nemeton et nemetonshiny (platform_nemeton) ; l'en-tête du journal garde l'ancien nom (ajout seul).
2026-11-16 · Pascal · brief · point 5 du contradicteur tranché : le plafond global de 3 PR, tous projets confondus, l'emporte toujours ; les plafonds locaux restent une limite de plus dans chaque projet ; le plafond global compte toutes les PR qui attendent la relecture de Pascal, quel que soit le dépôt. Reporté dans `docs/brief.md`.
2026-11-16 · Pascal · brief · cap · lien d'`aigora` → il passe par son adaptation privée `aigora-nemeton` · pourquoi : c'est elle qui consomme `nemetonmcp`, `nemetonshiny` et `nemeton` · fait : `aigora-nemeton` ajouté aux projets pilotés (treize) dans `CLAUDE.md`, la carte et le brief ; la liste des projets est close. Constaté à la lecture : pas de dépôt GitHub (origin = clone local d'`aigora`, ne jamais publier), pas de `.claude/test-command`, briefs écrits dans `~/dev/briefs/vers-<dépôt>/` ; reste ouvert : comment une mission y passe la porte n° 3 sans PR GitHub.
2026-11-16 · Pascal · — · écart du 2026-11-16 sur `.claude/rules` tranché : le fichier est déplacé dans `docs/convention-nmt.md`, sans réécriture, avec une mention de statut (écrit avant l'extraction de nemetonshiny ; partie « Stack » à confirmer dans chaque projet). `.claude/` ne garde que les réglages.
2026-11-16 · Pascal · brief · porte n° 1, première moitié : brief validé, avec la carte des dépendances et les règles métier de `CLAUDE.md`. Reste : `docs/spec.md`, puis les ADR des préalables bloquants ; rien ne se développe dans les projets d'ici là.
