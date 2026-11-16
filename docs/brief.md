# nemetonplateforme — brief

> Rédigé par Claude avec `/imperatrice:brief` : à chaque question, une proposition de
> Claude que Pascal retient, corrige ou rejette ; relu par Pascal, puis critiqué par le
> `contradicteur`. Dans l'ordre : 1. ma réponse d'abord, dans les mots de Pascal ;
> 2. les questions et leurs propositions, ajustées aux réponses, puis le brief rédigé ;
> 3. la relecture de Pascal ; 4. la critique du contradicteur, puis les arbitrages de Pascal.

> **Statut : validé par Pascal le 2026-11-16**, avec `docs/spec.md` validée le même
> jour (porte n° 1 franchie).

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
- **Bénéficiaires** : Pascal, seul à décider et à relire les PR (réponse d'abord). Les
  utilisateurs finaux de la plateforme (forestiers, gestionnaires) ne sont pas
  bénéficiaires de l'orchestrateur : ils le sont des projets qu'il fait avancer (critique du contradicteur, retenue par Pascal le 2026-11-16).
- **Coût complet aujourd'hui** : inconnu. Pascal a laissé cette part de sa réponse
  entre crochets.

## Ce que fait nemetonplateforme

- **En une phrase** : il vérifie tous les projets de la plateforme Néméton, repère ceux
  qu'un changement impacte et fait avancer leurs missions, en série le long des
  dépendances, en parallèle quand c'est possible (réponse d'abord, `CLAUDE.md`).
- **Les gestes sur le terrain** : le cycle de `CLAUDE.md`, d'un projet à l'autre :
  1. **Observer** ce qui a changé dans chaque projet depuis le dernier cycle : tags et
     releases, `NEWS.md` ou `CHANGELOG.md`, contrat public, briefs déposés, PR ouvertes.
     Avant toute release d'un projet en amont, les tests des projets en aval sont lancés
     contre sa branche `main` (contrôle des dépendances inverses, à la manière de
     `revdepcheck` pour R) ; la carte est relevée de nouveau à chaque cycle (critique du contradicteur, retenue par Pascal le 2026-11-16).
  2. **S'orienter** : trouver les projets en aval d'après la carte, en partant du projet
     qui a changé (`nemeton` le plus souvent, d'après la réponse d'abord), et déposer un brief dans chaque projet impacté
     (`brief-<projet>-<sujet>.md`, rangé dans `briefs/traites/` une fois traité).
  3. **Décider** : proposer les missions du cycle dans la limite du plafond global.
  4. **Agir** : en série le long d'une chaîne, une mission en aval attendant la release
     en amont dont elle dépend ; en parallèle entre missions indépendantes (`nemeton`
     et `foretaccess`, tests d'aval écrits pendant que l'amont avance, d'après la carte).
  5. **Dire tout de suite** toute rupture de contrat entre deux projets.

  Ce qu'est un « impact » dépend du lien (critique du contradicteur, retenue par Pascal le 2026-11-16) :
  - **dépendance de code R** (`Imports`, `Remotes: …@*release`) : l'aval suit la dernière
    release de l'amont ; il peut casser à la prochaine release, sans PR de sa part ;
  - **dépendance Gradle** (`terrain`, version épinglée) : l'aval ne change que si l'on monte
    de version ; à chaque release de `terrain`, l'orchestrateur propose la montée, que
    Pascal décide (c'est un contrat entre projets) ;
  - **échange de données ou de format** (`deperis.gpkg`, plan d'action gpkg) : un contrat
    sans ordre de release, protégé par un test de contrat.

  Seules les dépendances de code fixent l'ordre des releases ; elles ne doivent jamais
  former de cycle, et l'orchestrateur le vérifie à chaque cycle. La plateforme a deux
  chaînes : R/Python (`nemeton`, `foretaccess` en tête) et Kotlin/Android (`terrain` en
  tête).
- **Ce qu'il produit** : les briefs déposés dans les projets impactés ; les fiches de
  mission qui traversent plusieurs projets (`pilotage/missions/`) ; une PR par mission,
  dans le dépôt du projet ; le kanban commun et le journal ; les alertes de rupture de
  contrat (`CLAUDE.md`). Aucun code produit dans ce dépôt.
- **Ce qu'il demande aux projets** (critique du contradicteur, retenue par Pascal le 2026-11-16) : chaque projet en amont tient une rubrique
  « Ruptures » dans son `NEWS.md` ou `CHANGELOG.md`, que l'orchestrateur lit (le schéma de
  version reste le choix de chaque projet) ; chaque lien de la carte a son contrat écrit
  et son test de contrat, sur le modèle de `nemetonshiny/CONTRAT.md` et
  `test-contrat_nemetonmcp.R`.

## Ce qu'il ne fait pas (hors périmètre)

D'après `CLAUDE.md` :

- il ne contient ni n'écrit de code produit dans ce dépôt ;
- il ne tranche aucune question de sens, de périmètre, de valeur ou de contrat entre
  projets : il la prépare et la pose à Pascal (réponse d'abord) ;
- il ne tient pas le pilotage propre d'un projet qui a son `pilotage/` (`nemetonshiny`,
  `terrain`, `marculus`, `surculus`, `ramulus`, `groma`, `sylvostation`) : il y renvoie sans
  recopier ;
- il ne confie aucune mission de développement à un projet sans la méthode : l'installer
  est la première mission, avec l'accord de Pascal.

Il ne touche à aucun dépôt hors des projets de la carte, en particulier aux dépôts au
nom voisin qu'elle relève : `opencanopy`, `maestronemeton`, `treesatnemeton`,
`flairhubnemeton`, `alphaearthnemeton`, `forptnemeton`, `tarif-nemeton`, tant que Pascal ne les ajoute pas à la carte (proposition retenue par Pascal le
2026-11-16).

Les projets auxquels il touche sont les six de la réponse d'abord, plus `marculus`,
`surculus`, `terrain`, `groma`, `ramulus`, `sylvostation` et `aigora-nemeton`, que
Pascal a ajoutés le 2026-11-16.

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
- **Points de la carte**, tranchés par Pascal le 2026-11-16 : la liste des projets est
  complète (les dépôts au nom voisin sont hors périmètre) ; le lien d'`aigora` passe par
  son adaptation privée `aigora-nemeton`, ajoutée aux projets pilotés (treize) ; le nom
  de ce dépôt est `nemetonplateforme`. Reste ouvert : `aigora-nemeton` n'a pas de dépôt
  GitHub et ne doit pas être publié, comment une mission y passe-t-elle la porte n° 3 ?
- **Plafond global contre plafonds locaux** (contradicteur, point 5) : tranché par
  Pascal le 2026-11-16. Le plafond global de 3 PR, tous projets confondus, l'emporte
  toujours ; le plafond local d'un projet n'est qu'une limite de plus à l'intérieur de
  ce projet. Le plafond global compte toutes les PR qui attendent la relecture de
  Pascal, quel que soit le dépôt.

## Préalables bloquants (critique du contradicteur, retenue par Pascal le 2026-11-16)

Rien de ce qui suit n'est levé ; tant qu'ils ne le sont pas, l'orchestrateur ne peut
faire aucun geste « Agir » dans un autre dépôt. À trancher par ADR au crible FRANCE.

- Le hook de tests du plugin `imperatrice` ne lit que le `.claude/test-command` du dépôt
  de la session (`hooks/tests_obligatoires.py`) : une session ouverte ici ne teste aucun
  projet.
- `/boucle` isole les agents dans un worktree du dépôt de la session, pas de celui où ils
  écrivent (carte). Piste à étudier : une session ouverte dans le dépôt du projet, sur
  commande de l'orchestrateur.
- Non vérifié : ce que protègent `garde_main` et `journal_intact` quand la commande vise
  un autre dépôt.
- `.claude/test-command` manque au moins dans `nemeton` et `victor` : le premier cycle en
  fait l'inventaire pour les treize projets.

## Ce que la spec devra trancher (critique du contradicteur, retenue par Pascal le 2026-11-16)

- Ce qui déclenche un cycle (à la demande, à un rythme, sur release par
  `repository_dispatch`), et où est gardé l'état du dernier cycle (derniers tags vus).
- Qui publie une release : l'orchestrateur, Pascal ou la CI.
- Où se déposent les briefs : la convention `brief-<projet>-<sujet>.md` et
  `briefs/traites/` n'existe que dans `nemetonshiny` ; `aigora-nemeton` écrit les siens
  hors dépôt, dans `~/dev/briefs/vers-<dépôt>/` ; `nemeton` range les siens dans
  `specs/`.
- Ce que sont les « quatre temps » d'une alerte de rupture (fiche n° 8 : décidé et par
  qui ; ouvert ; ce que ça change ; qui fait quoi d'ici quand), et à qui elle s'adresse.
- Les accès aux treize dépôts, et le repli si GitHub ou JitPack ne répond pas.
- Une carte lisible par une machine (un fichier YAML, par exemple) à côté de sa version
  en prose, pour le test du successeur.
- Le multi-dépôts est gardé : le dire, et ce qu'il coûte face à un monorepo.
