# nemetonplateform — brief

> Rédigé par Claude avec `/imperatrice:brief` : à chaque question, une proposition de
> Claude que Pascal retient, corrige ou rejette ; relu par Pascal, puis critiqué par le
> `contradicteur`. Dans l'ordre : 1. ma réponse d'abord, dans les mots de Pascal ;
> 2. les questions et leurs propositions, ajustées aux réponses, puis le brief rédigé ;
> 3. la relecture de Pascal ; 4. la critique du contradicteur, puis les arbitrages de Pascal.

## Ma réponse d'abord (fiche n° 15)

> « J'attends un orchestrateur qui vérifie tous les projets de la plateforme Néméton
> (nemeton, foretaccess, nemetonshiny, nemetonmcp, victor, aigora), repère ceux
> qu'un changement impacte et développe chaque projet impacté, au fur et à mesure,
> ou en parallèle quand c'est possible.
>
> Pourquoi : [ce que te coûte aujourd'hui le fait de porter à la main les briefs
> d'un dépôt à l'autre et de suivre l'ordre des releases].
>
> Le point de départ est nemeton : quand il change, ses dépendances suivent, dans
> l'ordre de la carte des dépendances.
>
> Je veux être sollicité le moins possible. Je retiens par défaut les propositions
> tirées du CLAUDE.md et de docs/carte-dependances.md. Je garde la décision sur ce
> qui touche au sens, au périmètre et aux contrats entre projets, et je relis au
> plus 3 PR ouvertes à la fois, tous projets confondus.
>
> Hors périmètre : [les dépôts ou sujets auxquels il ne doit pas toucher]. »
>
> — Pascal, le 16 novembre 2026, dit avant toute proposition de Claude, recopié mot pour mot.

> **Comment ce brief a été rempli.** Dans sa réponse d'abord, Pascal dit retenir par
> défaut les propositions tirées de `CLAUDE.md` et de `docs/carte-dependances.md`. Chaque
> ligne ci-dessous vient soit de sa réponse, soit de l'un de ces deux fichiers, et cite sa
> source. Ce qu'aucune des deux ne tranche s'écrit « à trancher par Pascal ».

## Le problème, et pour qui (Abstraction)

- **Problème** : aujourd'hui, Pascal porte les briefs à la main d'un dépôt à l'autre et
  suit lui-même l'ordre des releases (réponse d'abord). Les relais existent déjà mais
  restent manuels : `nemeton/specs/brief-nemetonshiny-*.md`, `brief-foretaccess-*.md`,
  `nemetonshiny/briefs/` ; l'aval installe la dernière release de l'amont, pas `main`
  (carte). Le plafond de relecture est écrit projet par projet, si bien que les PR à
  relire s'additionnent d'un projet à l'autre (carte).
- **Bénéficiaires** : d'abord Pascal, seul à décider et à relire les PR (réponse
  d'abord) ; ensuite : à trancher par Pascal.
- **Coût complet aujourd'hui** : inconnu. Pascal a laissé cette part de sa réponse
  entre crochets.

## Ce que fait nemetonplateform

- **En une phrase** : il vérifie tous les projets de la plateforme Néméton, repère ceux
  qu'un changement impacte et fait avancer leurs missions, en série le long des
  dépendances, en parallèle quand c'est possible (réponse d'abord, `CLAUDE.md`).
- **Les gestes sur le terrain** : le cycle de `CLAUDE.md`, d'un projet à l'autre :
  1. **Observer** ce qui a changé dans chaque projet depuis le dernier cycle : tags et
     releases, `NEWS.md` ou `CHANGELOG.md`, contrat public, briefs déposés, PR ouvertes.
  2. **S'orienter** : trouver les projets en aval d'après la carte, en partant de
     `nemeton` (réponse d'abord), et déposer un brief dans chaque projet impacté
     (`brief-<projet>-<sujet>.md`, rangé dans `briefs/traites/` une fois traité).
  3. **Décider** : proposer les missions du cycle dans la limite du plafond global.
  4. **Agir** : en série le long d'une chaîne, une mission en aval attendant la release
     en amont dont elle dépend ; en parallèle entre missions indépendantes (`nemeton`
     et `foretaccess`, tests d'aval écrits pendant que l'amont avance, d'après la carte).
  5. **Dire tout de suite** toute rupture de contrat entre deux projets.
- **Ce qu'il produit** : les briefs déposés dans les projets impactés ; les fiches de
  mission qui traversent plusieurs projets (`pilotage/missions/`) ; une PR par mission,
  dans le dépôt du projet ; le kanban commun et le journal ; les alertes de rupture de
  contrat (`CLAUDE.md`). Aucun code produit dans ce dépôt.

## Ce qu'il ne fait pas (hors périmètre)

D'après `CLAUDE.md` :

- il ne contient ni n'écrit de code produit dans ce dépôt ;
- il ne tranche aucune question de sens, de périmètre, de valeur ou de contrat entre
  projets : il la prépare et la pose à Pascal (réponse d'abord) ;
- il ne tient pas le pilotage propre d'un projet qui a son `pilotage/` (aujourd'hui
  `nemetonshiny`) : il y renvoie sans recopier ;
- il ne confie aucune mission de développement à un projet sans la méthode : l'installer
  est la première mission, avec l'accord de Pascal.

Il ne touche à aucun dépôt hors des projets de la carte, en particulier aux dépôts au
nom voisin qu'elle relève : `opencanopy`, `maestronemeton`, `treesatnemeton`,
`flairhubnemeton`, `alphaearthnemeton`, `forptnemeton`, `tarif-nemeton`, tant que Pascal ne les ajoute pas à la carte (proposition retenue par Pascal le
2026-11-16).

Les projets auxquels il touche sont les six de la réponse d'abord, plus `marculus`,
`surculus`, `terrain`, `groma`, `ramulus` et `sylvostation`, que Pascal a ajoutés le
2026-11-16.

## Contraintes connues

- **Décision humaine** : Pascal garde le sens, le périmètre et les contrats entre
  projets ; il veut être sollicité le moins possible (réponse d'abord).
- **Plafond humain global** : au plus 3 PR ouvertes à la fois, tous projets confondus
  (réponse d'abord, `pilotage/equipe.md`).
- **Ordre de fusion** : celui de la carte. Pas de mission en aval avant la release en
  amont dont elle dépend.
- **Chaque projet reste chez lui** : son `CLAUDE.md` prime pour ce qui lui est propre,
  et l'on écrit avec sa commande de tests (`.claude/test-command`).
- **Pas de code sans tests ; jamais de push direct sur `main`**, dans aucun dépôt
  (`CLAUDE.md`).
- **Formats ouverts, logiciels libres** ; licence de la plateforme GPL-3
  (`docs/ADR-015_Licence_GPL3.md`).
- **Deux limites du plugin `imperatrice` 0.7.0**, à trancher par ADR avant la première
  mission dans un autre dépôt : le hook de tests ne lit que le dépôt de la session, et
  `/boucle` isole les agents dans un worktree de ce dépôt-ci (carte).
- **Points ouverts de la carte** : la liste des projets est-elle complète ; par quoi
  passe le lien d'`aigora` ; le nom de ce dépôt. À trancher par Pascal.
