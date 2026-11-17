# Mission 007 — la carte des dépendances lisible par une machine (`docs/carte.yaml`)

> Inscrite pour le cycle 4 sur le « oui » de Pascal du 2026-11-17. Rangement de la
> plateforme : dans la délégation élargie du 2026-11-16 (`pilotage/equipe.md`). Dépôt :
> `nemetonplateforme`. Aucun dépôt de projet n'est touché.

## Mission

**En une phrase (quoi, et pourquoi) :** Écrire `docs/carte.yaml`, source unique des projets et des liens de la plateforme au format de `docs/spec.md` § 8, à partir de `docs/carte-dependances.md`, et faire renvoyer les tableaux de liens de la carte en prose vers ce fichier, pour que l'orchestrateur lise la carte à chaque cycle sans la recopier (critère d'acceptation n° 2 de la spec).

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les trois questions (règle de staffing)

| Question | Réponse | Conséquence |
|---|---|---|
| Peut-il redire la mission en une phrase, avec son but ? | oui | |
| Sait-il comment faire ? | oui : le format est donné par la spec § 8 ; les liens et leurs sources sont dans `docs/carte-dependances.md` | |
| A-t-il les moyens ? | oui : lecture de ce dépôt ; lecture seule des clones dans `~/dev/` pour vérifier une source | |

**Temps de la main :** appuyer.

## Ma réponse d'abord

_Rempli par Pascal seul._ (Pascal a délégué : sans objet.)

## L'Homme

- **Agent :** `archiviste`. **Modèle :** sonnet.
- **Ce qui ne lui est pas demandé :** relever de nouveaux liens dans les projets ;
  confirmer les liens « à confirmer » ; écrire un script de lecture ou de détection de
  cycles ; écrire `pilotage/etat-cycle.yaml` (mission 008).

## Harnais

- **Peut :** créer `docs/carte.yaml` ; dans `docs/carte-dependances.md`, remplacer les
  tableaux de liens par un renvoi au YAML, en gardant le schéma, l'explication, l'état des
  projets et les points ouverts ; ouvrir une PR vers `main` de ce dépôt.
- **Ne doit pas :** écrire dans un dépôt de projet ; inventer un lien ou une source (un
  lien sans source garde `source: à confirmer`) ; changer le sens d'un lien ; toucher à
  `pilotage/` ; fusionner sa PR.
- **Sources autorisées :** `docs/spec.md` (§ 8), `docs/carte-dependances.md`,
  `docs/brief.md` ; en lecture seule, les fichiers cités comme sources dans les clones de
  `~/dev/` (jamais `aigora-nemeton/missions/`).

## Contenu attendu

- `projets` : les treize projets de `CLAUDE.md`, chacun avec `chemin`, `depot` (`null`
  pour `aigora-nemeton`, sans GitHub), `chaine`, `methode`, `briefs`, et la branche par
  défaut quand ce n'est pas `main` (`sylvostation`).
- `liens` : un élément par lien de la carte en prose, avec `amont`, `aval`, la nature du
  lien (code, données, contrat…) et `source` (fichier et, si possible, ligne).

## Valeur provisoire (chiffre, réglage)

- **Valeur provisoire :** autant de liens dans le YAML que dans les tableaux de la carte
  en prose au 2026-11-17, aucun perdu ni ajouté.
- **Mesurée par :** l'agent (décompte dans la PR), puis le `relecteur`.

## Dépend de / rouge attendu jusqu'à

- **Dépend de :** rien. **CI rouge attendue :** aucune (ce dépôt n'a pas de CI).

## Tests

- Le YAML se lit sans erreur (`python3 -c 'import yaml; yaml.safe_load(open("docs/carte.yaml"))'`).
- Chaque `amont` et `aval` est un projet de `projets` ; chaque lien a une `source`.
- Le décompte des liens est égal à celui des tableaux remplacés.

## Qui veille, qui tranche

- **Relecteur :** `relecteur`, puis l'orchestrateur, qui fusionne par délégation (PR de
  documentation de ce dépôt).
- **Qui tranche :** l'orchestrateur ; un lien dont le sens est douteux est mis de côté
  pour le bilan de Pascal.

## Comment saura-t-on que ça marche ?

Au cycle 4, l'orchestrateur trouve les projets en aval d'un changement en lisant
`docs/carte.yaml`, et rien que lui.
