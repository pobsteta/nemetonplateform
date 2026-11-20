# Mission 028 — sommier-import-comptages

> Ouverte le 2026-11-20 sur décision de Pascal au bilan (question 1 sur 3 : « oui »).
> Dépôt : `sommieR` (session ouverte dans le projet, ADR 0001). Fusion par l'orchestrateur quand les contrôles sont verts.

## Mission

**En une phrase (quoi, et pourquoi) :** Faire lire à l'import de tournée QField les deux comptages de plants (`nb_plants_vivants`, `nb_plants_concurrences`) d'un contrôle, pour que le niveau de concurrence soit déduit ou signalé à l'import comme il l'est déjà par l'API R.

**Redite par l'agent :** _à compléter par l'agent avant d'agir — s'il n'y arrive pas, il s'arrête._

## Les sources à lire avant d'agir

- La spec de Surculus, en lecture seule : `/home/pascal/dev/surculus/docs/spec.md` (couche des contrôles : noms des colonnes de comptage, l. 95 « un lecteur ignore les champs en plus », et le tableau des règles de sommieR vers la l. 520-550).
- Les réponses déjà envoyées : `/home/pascal/dev/briefs/vers-surculus/2026-11-18-niveaux-de-concurrence-reponse.md` et `2026-11-19-reponse-sommier-import-souple.md` (point 3 : « l'import QField ne lit pas encore ces comptages »).
- Dans sommieR : `R/registre6.R` (`registre6_controle()`, `sommier_niveau_concurrence()`, le cas 0/0 de la mission 027), `R/travaux_qfield.R` (lecture des contrôles, l. 355 et 511-516 à la fusion de 027), le journal (missions 022 et 027).

## Contrat aval lu

- Les noms des colonnes sont ceux que **Surculus écrit** (sa spec fait foi). Si la spec ne les nomme pas, prendre `nb_plants_vivants` et `nb_plants_concurrences` (noms de l'API R) et le dire dans la réponse.
- Cas limites, chacun testé : colonnes absentes (tournée d'un ancien format : rien ne change) ; une seule des deux colonnes ; valeurs NA ; 0/0 (aucun niveau, mission 027) ; `concurrences > vivants` (règle existante de `registre6_controle()` : la reprendre, ne pas en inventer) ; niveau saisi qui contredit les comptages (accepté, signalé, `concurrence_calculee`).
- Règle du bilan du 2026-11-19 : accepter et signaler, refuser seulement l'illisible.

## Ce qui est attendu

1. L'import lit les deux colonnes quand elles existent et les passe à `registre6_controle()` ; le bilan d'import porte les avertissements comme pour `photos_terrain`.
2. Le projet QField des travaux (`sommier_projet_qfield_travaux()`) porte ces deux champs dans la couche des contrôles, si la spec de Surculus les y met ; sinon ne rien ajouter et le dire.
3. Tests pour chaque cas limite ; `.claude/test-command` verte ; CI verte ; version suivante au format calendaire de la mission 029 : `main` est à 2026.11.1 (release posée le 2026-11-20, sans passage en `.9000`), la version de cette mission est donc **2026.11.2** (si le mois a changé à la fusion, `AAAA.M.1`) ; NEWS ; journal en ajout seul.
4. Un mot à Surculus : `~/dev/briefs/vers-surculus/2026-11-20-reponse-sommier-import-comptages.md` (ce qui est lu, sous quels noms, ce qui est signalé).

Aucune rupture : une tournée sans ces colonnes s'importe comme avant.

## L'Homme

- **Agent :** `dev`, dans une session ouverte dans `sommieR`. **Modèle :** sonnet. Relu par le `relecteur`.
- **Moyens :** budget 3 $ ; worktree depuis `origin/main`.
- **Ce qui ne lui est pas demandé :** toucher un autre dépôt (sauf la boîte `vers-surculus`) ; fusionner ; changer les seuils 20 % et 50 %.
- **Dépend de / rouge attendu jusqu'à :** la fusion de la mission 029 (mêmes fichiers de version) : faite le 2026-11-20 (df94a39, v2026.11.1).
- **Base de test :** celle de `R_ENVIRON_USER` posé par le lanceur (`sommier_test_m028`) ; ne pas écrire d'autre fichier d'environnement ni viser une autre base (écart de la mission 029).
