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
