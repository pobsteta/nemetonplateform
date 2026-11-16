# nemetonplateforme — spec

> **Statut : validée par Pascal le 2026-11-16, toutes propositions retenues.**
> Proposée par Claude le même jour. Écrite à partir du brief
> validé par Pascal le 2026-11-16 (`docs/brief.md`), de la carte
> (`docs/carte-dependances.md`) et de ce qui existe déjà sur le PC de Pascal. Chaque
> décision marquée **proposé** attend que Pascal la retienne, la corrige ou la rejette ;
> elle devient la règle à son « oui » sur cette spec (porte n° 1, seconde moitié).
> Les quatre préalables bloquants du brief ne sont pas levés ici : ils le seront par ADR.

## 1. Le parcours, du côté de Pascal

Pascal est le seul humain du parcours. Il ouvre une session Claude Code dans
`~/dev/nemetonplateforme` et lance un cycle.

1. **Observer.** L'orchestrateur relit chaque projet de la carte (clone local, puis
   GitHub) et le compare à l'état du dernier cycle (§ 3) : nouveaux tags et releases,
   rubrique « Ruptures » de `NEWS.md` ou `CHANGELOG.md`, contrat public modifié, briefs en
   attente, PR ouvertes. Il relève la carte de nouveau et vérifie que les dépendances de
   code ne forment pas de cycle.
2. **S'orienter.** Pour chaque changement, il suit la carte vers l'aval et dépose un
   brief par projet impacté (§ 4).
3. **Décider.** Il propose à Pascal les missions du cycle, dans la limite du plafond
   global (3 PR qui attendent la relecture de Pascal, tous dépôts confondus). Pascal
   retient, corrige ou rejette.
4. **Agir.** Il confie les missions retenues, en série le long d'une chaîne, en parallèle
   entre chaînes. **Bloqué** tant que les ADR des préalables ne sont pas tranchées.
5. **Dire tout de suite.** Toute rupture de contrat est dite à Pascal en quatre temps
   (§ 6), sans attendre la fin du cycle.

Le cycle finit par une ligne au kanban (« Livraisons ») et au journal, et par l'état du
cycle mis à jour.

## 2. Ce qui déclenche un cycle

**Proposé : à la demande de Pascal, et seulement ainsi**, par `/imperatrice:boucle`
dans une session ouverte ici.

- Pourquoi : Pascal veut être sollicité le moins possible, mais chaque cycle peut finir
  par une question à lui poser ; un cycle qui tourne sans lui ne fait qu'empiler ces
  questions. Pas de secret à garder ni de CI à maintenir dans treize dépôts (test du
  successeur).
- Écarté pour l'instant : un rythme fixe (tâche planifiée) et un déclenchement par
  `repository_dispatch` à chaque release. On y revient si les cycles à la demande
  laissent passer des ruptures.

## 3. L'état du dernier cycle

**Proposé : un fichier `pilotage/etat-cycle.yaml`, versionné ici**, réécrit à la fin de
chaque cycle (l'historique est dans git et dans le journal). Pour chaque projet :

```yaml
nemeton:
  dernier_tag_vu: v2026.11.35
  main_lu: <sha du dernier commit lu sur main>
  lu_le: 2026-11-16
```

Le cycle suivant ne regarde que ce qui a changé depuis ces valeurs.

## 4. Où se déposent les briefs

Ce qui existe : trois conventions dans les dépôts (`nemetonshiny/briefs/`,
`nemeton/specs/`, rien ailleurs) et **une boîte commune hors dépôt**, `~/dev/briefs/`,
déjà en usage entre les sessions (son `README.md` : `vers-<cible>/`, nom
`AAAA-MM-JJ-sujet.md`, rangement dans `traites/` par la session qui l'a traité ; 222
briefs traités à ce jour).

**Proposé : on garde la boîte commune `~/dev/briefs/`, et sa règle telle qu'elle est.**

- L'orchestrateur dépose ses briefs dans `~/dev/briefs/vers-<projet>/`. Écrire hors des
  dépôts ne touche aucun arbre de travail ni le WIP d'une autre session.
- La copie de référence d'un brief qui traverse plusieurs projets est la fiche de
  mission `pilotage/missions/NNN-titre.md` ; le brief en est la notification (même
  partage que le `README.md` de la boîte).
- À l'étape « Observer », les briefs en attente dans `vers-*` comptent comme des
  changements, y compris ceux qu'écrit `aigora-nemeton`.
- Les conventions internes (`nemetonshiny/briefs/traites/`, `nemeton/specs/`) restent
  celles des projets ; l'orchestrateur ne les modifie pas.
- Le nom `vers-nemetonplateform/` est renommé `vers-nemetonplateforme/` (cap du
  2026-11-16). Il contient 4 briefs en attente, à traiter dans un cycle.
- Limite à dire : cette boîte n'est ni versionnée ni sauvegardée par git. Elle vit sur
  le seul PC de Pascal.

## 5. Qui publie une release

**Proposé : Pascal, toujours.** L'orchestrateur prépare la release (numéro, rubrique
« Ruptures », contrôle des dépendances inverses vert) et la propose ; Pascal pousse le
tag ou valide la PR de release, et la CI du projet publie là où elle publie déjà.

- Pourquoi : une release peut casser l'aval, c'est un contrat entre projets, que Pascal
  garde (brief, « Décision humaine »).
- L'orchestrateur ne crée jamais de tag ni de release.

## 6. Une alerte de rupture de contrat

**Proposé :** les quatre temps de la fiche n° 8, adressés à **Pascal**, le seul à
décider :

1. **Décidé, et par qui** : le changement en amont (version, commit, auteur) ;
2. **Ouvert** : ce qui n'est pas encore tranché ;
3. **Ce que ça change** : les projets en aval touchés, d'après la carte, et le test de
   contrat qui l'a vu (ou « aucun test ne l'a vu ») ;
4. **Qui fait quoi d'ici quand** : la mission proposée, son dépôt, ce qu'elle attend.

L'alerte est dite dans la session dès qu'elle est vue, inscrite au journal (ligne
marquée `rupture`) et, si Pascal retient la mission, déposée en brief dans le projet en
aval. Le dépôt en amont n'est pas prévenu par l'orchestrateur : c'est Pascal qui décide
s'il recule.

## 7. Les accès aux treize dépôts, et le repli

**Proposé :**

- **Lecture** : le clone local de chaque projet dans `~/dev/` (ou son chemin propre :
  `~/dev/victor/victor`, `~/dev/aigora/aigora`, `~/dev/aigora/aigora-nemeton`), puis
  GitHub par `gh` sous le compte de Pascal, déjà connecté.
- `sylvostation` n'a pas de clone local et pas de branche `main` : l'orchestrateur le
  lit sur GitHub ; le clone et la branche `main` sont à proposer à Pascal avant toute
  mission.
- **Repli si GitHub ne répond pas** : le cycle observe sur les clones locaux, le dit, et
  s'arrête avant « Agir » (pas de PR possible).
- **Repli si JitPack ne répond pas** : aucune montée de version de `terrain` dans le
  cycle ; on le note au journal et on reprend au cycle suivant.

## 8. Une carte lisible par une machine

**Proposé : `docs/carte.yaml`, source unique des liens**, lue par l'orchestrateur à
chaque cycle. La carte en prose (`docs/carte-dependances.md`) garde le schéma,
l'explication et les points ouverts ; ses tableaux de liens renvoient au YAML au lieu de
le recopier (« si une information existe à deux endroits, l'un des deux est faux »).

```yaml
projets:
  nemeton:
    chemin: ~/dev/nemeton
    depot: pobsteta/nemeton
    chaine: r
    methode: plugin
    briefs: ~/dev/briefs/vers-nemeton
liens:
  - aval: nemetonshiny
    amont: nemeton
    nature: code-r          # code-r | gradle | donnees | mcp
    par: "Imports: nemeton (>= 2026.11.30)"
    source: nemetonshiny/DESCRIPTION
    confirme: oui
```

YAML : format ouvert, lisible sans outil, que tout successeur relit.

## 9. Le multi-dépôts est gardé

**Proposé :** on le dit, et ce qu'il coûte.

- **Gardé parce que** : deux chaînes de langages distincts (R/Python, Kotlin/Android) ;
  des rythmes et des publications propres (CRAN-like, JitPack, Play) ; `aigora-nemeton`
  privé et sans GitHub ; sept projets ont déjà leur propre pilotage.
- **Ce qu'il coûte** : une mission qui traverse deux projets fait deux PR, fusionnées
  dans l'ordre de la carte ; il faut relever la carte à chaque cycle ; les hooks du
  plugin ne protègent que le dépôt de la session (préalables bloquants).
- Un monorepo n'est pas étudié plus avant : il obligerait à fusionner des historiques,
  des licences et des CI qui vivent bien séparés.

## 10. `aigora-nemeton` et la porte n° 3

`aigora-nemeton` n'a pas de dépôt GitHub et ne doit pas être publié : pas de PR possible.

**Proposé :** une mission y travaille sur une branche locale ; Pascal relit le diff
(`git diff main...<branche>`) dans une session ouverte dans `aigora-nemeton`, et fusionne
lui-même. Cette relecture compte dans le plafond global comme une PR. Sa première
mission, avec l'accord de Pascal, est d'installer la méthode, avec une
`.claude/test-command`.

## 11. Données manipulées

Aucune donnée de client, aucune donnée forestière : l'orchestrateur lit des métadonnées
de dépôts (tags, versions, `DESCRIPTION`, fichiers Gradle, `NEWS.md`, `CHANGELOG.md`,
contrats, PR) et écrit des briefs, des fiches de mission, le kanban, le journal,
`pilotage/etat-cycle.yaml` et `docs/carte.yaml`. Il ne lit jamais `aigora-nemeton/missions/`
(données de clients).

## 12. Besoins en référentiels

Aucun référentiel extérieur. Rien à confier à l'`acquereur`.

## 13. Hors périmètre

Celui du brief, sans ajout.

## 14. Critères d'acceptation

La spec est tenue quand :

1. un cycle lancé à la demande produit, pour les treize projets, l'état lu et la liste des
   changements depuis `pilotage/etat-cycle.yaml`, sans rien écrire dans un dépôt de
   projet ;
2. `docs/carte.yaml` existe, chaque lien y cite sa source, et l'orchestrateur y détecte
   un cycle de dépendances de code s'il en apparaît un ;
3. un changement de `nemeton` produit un brief dans `~/dev/briefs/vers-<projet>/` pour
   chaque projet en aval d'après la carte, et pour eux seuls ;
4. une rupture vue est dite en quatre temps dans la session et au journal ;
5. jamais plus de 3 PR (ou relectures de branche locale) n'attendent Pascal à la fois ;
6. aucune release ni aucun tag n'est créé par l'orchestrateur ;
7. avant toute mission « Agir » : les ADR sur les tests et les worktrees d'un dépôt à
   l'autre sont tranchées par Pascal, et l'inventaire des `.claude/test-command` des
   treize projets est fait.

## Les ADR qui suivent

À proposer au crible FRANCE, critiquées par le `contradicteur`, puis tranchées par Pascal :

1. Agir dans un autre dépôt : session ouverte dans le dépôt du projet, sur commande de
   l'orchestrateur, ou hooks et worktrees adaptés depuis ici (préalables 1 à 3).
2. La carte en YAML comme source unique des liens (§ 8).
3. La boîte commune `~/dev/briefs/` comme canal des briefs (§ 4).
