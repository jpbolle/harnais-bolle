# Domaine — enseignement secondaire en Fédération Wallonie-Bruxelles

Le vocabulaire et les règles du métier. Se tromper ici produit des bugs qu'aucun test ne
détecte, parce que le code est correct : c'est le modèle mental qui est faux.

## Année scolaire

- **Format** : `2025-2026` (année civile de septembre - année civile de juin).
- **Seuil de bascule** : **le 25 août**. Une fonction `getCurrentSchoolYear()` renvoie
  `2026-2027` à partir du 25 août 2026.

  Le choix du 25 août plutôt que du 1er septembre est délibéré : la rentrée administrative
  (inscriptions, constitution des classes, horaires) précède la rentrée des élèves de
  plusieurs semaines. Avec un seuil au 1er septembre, tout le travail de préparation
  s'enregistrerait sur l'année précédente.

- ⚠️ **Une application scolaire manipule presque toujours deux années à la fois** —
  l'année en cours et l'année suivante en préparation. Tout écran qui affiche des données
  annualisées doit avoir un **sélecteur d'année explicite**, et jamais supposer
  « l'année courante ». C'est l'une des principales sources de confusion utilisateur.

## Périodes et bulletins

- **5 périodes + juin** :
  1. Septembre - Octobre
  2. Novembre - Décembre (« Noël »)
  3. Janvier - Mars
  4. Avril - Mai
  5. Juin
- Les évaluations et les conseils de classe s'articulent sur ce découpage.

## Décisions de fin d'année

| Sigle | Signification |
|---|---|
| **AOA** | Réussite |
| **AOB** | Réussite conditionnelle (restriction sur le choix de forme/section/orientation) |
| **AOC** | Échec (redoublement) |

## Structure des études

- **Niveaux** : 1 à 7 (la 7e existe en qualification/professionnel).
- **Degrés** : D1 (1e-2e), D2 (3e-4e), D3 (5e-6e).
- **Sections / filières** : générale (« commune »), différenciée, immersion, technique,
  professionnelle, DASPA (élèves primo-arrivants), CEFA (alternance).
- Un même établissement combine généralement plusieurs de ces filières, avec des règles
  différentes pour chacune. Ne jamais coder de logique qui suppose une filière unique.

## Choix d'options

Les élèves choisissent des options à des **moments de transition** du cursus, pas chaque
année :

- entrée en 1re (fiche d'inscription),
- passage en 2e,
- passage au 2e degré (3e),
- passage au 3e degré (5e).

Conséquences pour la modélisation :
- Un élève entré en 3e n'a **jamais** rempli le formulaire de passage en 2e. L'interface
  doit **masquer** ces transitions, pas les griser : un formulaire grisé suggère un oubli.
- Le niveau d'entrée réel se déduit de la plus ancienne trace annualisée de l'élève.
- Les options sont **annualisées** : elles se stockent par année scolaire, jamais en
  champ plat sur l'élève.

## Groupes et regroupements

Règle métier critique, source de bugs subtils :

> Un élève peut appartenir à **plusieurs matières de regroupement** (langue moderne 2,
> latin, activité complémentaire…), mais à **un seul groupe par matière** (anglais **ou**
> néerlandais, jamais les deux).

Toute interface d'affectation à un groupe doit donc **retirer automatiquement** l'élève
des autres groupes de la même matière au moment de l'affectation. Sans ça, on obtient des
élèves inscrits dans deux groupes concurrents, et le symptôme n'apparaît qu'au comptage
des effectifs, des semaines plus tard.

## Horaires

Modèle courant (à vérifier pour chaque établissement) :

- **Période** de 45 minutes ; **créneau usuel** de 90 minutes (2 périodes consécutives).
- Lundi, mardi, jeudi, vendredi : 8 périodes, environ 8h30 → 16h00, avec deux récréations
  et une pause de midi.
- **Mercredi** : demi-journée (5 périodes, ~8h30 → 12h30).
- Créneaux particuliers en fin de journée pour les ateliers ou l'alternance.

Le calcul de charge des professeurs se fait en **périodes**, pas en heures — une confusion
fréquente qui fausse tous les totaux.

## Repères administratifs

- Une école a souvent **plusieurs implantations** (sites géographiques) ; élèves et
  personnel y sont rattachés, et certaines règles en dépendent.
- Le **titulariat** (professeur responsable d'une classe) est un **attribut** d'un
  professeur, pas un rôle en soi — voir [`roles-et-identite.md`](roles-et-identite.md).
- Les règles internes (autorisation de sortie sur le temps de midi, par exemple) peuvent
  dépendre du **code postal** du domicile et du degré. Ce sont des règles d'établissement :
  les rendre paramétrables plutôt que codées en dur.
