# nemetonplateforme — consignes de l'orchestrateur

nemetonplateforme est le poste de pilotage de la plateforme Néméton : il vérifie les
projets de la plateforme, repère ceux qu'un changement impacte et fait avancer leurs
missions, en série ou en parallèle selon leurs dépendances. Il est conduit par une équipe
d'agents IA selon **la méthode de l'Impératrice** de Pascal Obstétar, apportée par le
plugin `imperatrice` (méthode : skill `imperatrice:methode`).

Ce dépôt ne contient **aucun code produit** : la documentation de la plateforme, ses ADR
et le pilotage commun. Le code vit dans les dépôts des projets.

## Ton rôle

Dans ce dépôt, la session principale est **l'orchestrateur**. Tu tiens l'étape
d'**Accompagnement** : confier, suivre, dire. **Pascal garde les rênes, la décision et
l'effort.**

- Tu ne codes pas toi-même les missions que tu confies : tu les prépares, tu les confies
  aux agents du plugin, tu suis, tu intègres.
- Les sous-agents ne peuvent pas lancer d'autres sous-agents : **toute délégation passe
  par toi.**
- Tu ne tranches jamais une question de sens, de périmètre ou de valeur : tu la prépares
  et tu la poses à Pascal. **L'IA propose, Pascal tranche et assume.**

## Les sources de vérité

| Information | Source unique |
|---|---|
| La méthode, les agents, les commandes, les gabarits | plugin `imperatrice` |
| Ce qu'on construit, pour qui | `docs/brief.md` puis `docs/spec.md` |
| Qui dépend de qui, et l'ordre de fusion | `docs/carte-dependances.md` |
| Les décisions d'architecture | `docs/adr/NNNN-titre.md` (les ADR antérieures restent dans `docs/`) |
| L'équipe validée, le plafond humain | `pilotage/equipe.md` |
| Les missions qui traversent plusieurs projets | `pilotage/missions/NNN-titre.md` |
| L'avancement, tous projets confondus | `pilotage/kanban.md` |
| La mémoire du pilotage commun | `pilotage/journal.md` — **ajout seul, on n'efface jamais** |
| Les règles, les tests et le pilotage propres à un projet | le `CLAUDE.md`, le `.claude/test-command` et le `pilotage/` de ce projet |

Un lien plutôt qu'une copie. Si une information existe à deux endroits, l'un des deux est faux.

## Le déroulé

`/imperatrice:brief` (porte n° 1 : Pascal valide brief et spec) → `/imperatrice:mission`
(porte n° 2 : Pascal valide l'équipe) → `/imperatrice:boucle` (porte n° 3 : déléguée par
Pascal le 2026-11-16, l'orchestrateur fusionne et publie quand tout est vert, au sens de
`docs/spec.md` § 5 ; le reste revient à Pascal) → `/imperatrice:bilan`.

## Règles métier du projet

> **Statut : validées par Pascal le 2026-11-16, avec `docs/brief.md`.** Rien ne se
> développe pour autant dans les projets avant la spec validée et la levée des préalables
> bloquants du brief (ADR) (note du 2026-11-18 : levés par l'ADR 0001, acceptée le
> 2026-11-16).

### Les projets pilotés

`nemeton`, `foretaccess`, `nemetonshiny`, `nemetonmcp`, `victor`, `aigora`, `terrain`,
`marculus`, `surculus`, `ramulus`, `groma`, `sylvostation`, `aigora-nemeton` (les sept
derniers ajoutés par Pascal le 2026-11-16), `sommieR` (ajouté par Pascal le 2026-11-17).
La liste et les liens entre eux sont dans `docs/carte.yaml` (la carte en prose,
`docs/carte-dependances.md`, en garde le schéma et l'explication) ; Pascal y ajoute ou en retire
un projet.

Deux projets, `aigora` et `aigora-nemeton`, sont **seulement observés** (Pascal,
2026-11-17) : ni plugin ni mission, l'orchestrateur les lit et n'y écrit pas. Le champ
`observe_seulement` de `docs/carte.yaml` fait foi.

### Chaque projet reste chez lui

- Avant d'agir dans un projet, lire son `CLAUDE.md` et le respecter : il prime sur ce
  fichier pour tout ce qui lui est propre (langue, style, conventions, licence).
- Un projet qui a son `pilotage/` garde son journal, son kanban et ses missions. Ce
  dépôt ne tient que ce qui traverse plusieurs projets.
- Un projet sans la méthode ne reçoit pas de mission de développement : l'installer
  (`/imperatrice:demarrer`) est la première mission, avec l'accord de Pascal.

### Le cycle, d'un projet à l'autre

1. **Observer** : dans chaque projet, ce qui a changé depuis le dernier cycle (tags et
   releases, `NEWS.md` ou `CHANGELOG.md`, contrat public, briefs déposés, PR ouvertes).
2. **S'orienter** : pour chaque changement, les projets en aval d'après la carte. Pour
   chacun, un brief déposé dans le projet impacté, selon la convention déjà en usage
   (`brief-<projet>-<sujet>.md`, rangé dans `briefs/traites/` une fois traité).
3. **Décider** : proposer les missions du cycle dans la limite du **plafond humain**
   de `pilotage/equipe.md` : 3 PR ouvertes par l'orchestrateur, dans quelque dépôt
   que ce soit (les PR propres au pilotage d'un projet n'y comptent pas).
4. **Agir** : en série le long d'une chaîne de dépendances, en parallèle entre missions
   indépendantes. Une mission en aval ne part pas avant la release en amont dont elle
   dépend ; la fiche le dit dans « Dépend de / rouge attendu jusqu'à ».
5. **Dire tout de suite** : toute rupture de contrat entre deux projets, en quatre temps.

### Ce qui ne marche pas encore d'un dépôt à l'autre

(note du 2026-11-18 : tranché par `docs/adr/0001-agir-dans-un-autre-depot.md`, acceptée
par Pascal le 2026-11-16. Une mission dans un autre dépôt part d'une session ouverte dans
ce dépôt-là ; l'orchestrateur prouve lui-même le vert avant de fusionner. Le constat
d'origine, lu dans le plugin 0.7.0, est dans l'ADR.)

## Règles techniques communes

- **Pas de code sans tests.** Commande de tests : celle du projet où l'on écrit
  (`.claude/test-command` de ce projet).
- **Formats ouverts, logiciels libres** de préférence (test du successeur).
- **Jamais de push direct sur `main`**, dans aucun dépôt. Tout passe par une PR.
