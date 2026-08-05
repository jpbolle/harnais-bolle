# Données élèves — pièges éprouvés

Quatre pièges rencontrés en production sur une base de plus de 1 600 élèves. Chacun a le
même profil : **aucune erreur affichée**, un symptôme qui apparaît des semaines plus tard.

---

## 1. La liste de champs qui sert à la fois à lire et à écrire

**Le piège le plus coûteux, et le plus général.**

Un fichier déclare une liste de noms de champs, utilisée à la fois pour lire les documents
depuis la base **et** pour construire le corps de la requête d'enregistrement. Un champ
ajouté au modèle mais oublié dans cette liste est **silencieusement retiré** du corps de
la requête.

**Symptôme** : la saisie fonctionne, l'enregistrement ne renvoie aucune erreur, la valeur
s'affiche correctement… puis revient à sa valeur par défaut **au rechargement de la page**.
Aucun message, aucune trace dans les journaux.

**Règles** :
- Le test de recette d'un nouveau champ n'est pas « ça s'enregistre » mais
  **« ça survit à un rechargement »**.
- Toute liste de ce type doit porter en commentaire la mention de son **double usage**.
- Mieux : dériver la liste du type plutôt que de la maintenir à la main. Tant que ce n'est
  pas fait, un skill de checklist dédié est justifié (c'est le cas d'école du skill qui
  vaut la peine d'être écrit).

**Effet en cascade** : la même omission se produit dans les artefacts dérivés — génération
de PDF, exports, synchronisations. Un nouveau champ doit être ajouté à **tous** les
endroits qui énumèrent les champs, et ils sont rarement au même endroit dans le code.

---

## 2. Homonymes et unicité de l'adresse email

Les adresses d'élèves sont généralement générées depuis l'état civil
(`prenom.nom@ecole.be`). Deux homonymes produisent la même adresse.

**Symptôme vécu** : deux élèves réellement homonymes (même prénom, même nom, années
différentes) ont fini **fusionnés en une seule fiche**, l'inscription de la seconde ayant
écrasé la première. Découvert bien après, avec perte de données à reconstituer à la main.

**Garde-fous à mettre en place dès le départ** :
- Une fonction de **désambiguïsation** qui suffixe l'adresse (`prenom.nom2@`,
  `prenom.nom3@`…) si elle est déjà prise par un **autre** élève — en excluant la fiche en
  cours d'édition, sinon on suffixe à chaque modification.
- Un **filet côté serveur** qui revérifie l'unicité avant la création, indépendamment de
  l'interface. Une validation qui n'existe que dans le formulaire ne protège pas les
  imports et les scripts.
- Un **signalement visible** dans l'interface quand la désambiguïsation se déclenche : la
  personne qui inscrit doit savoir qu'il existe un homonyme.

**Attention à la portée** : ces garde-fous couvrent les créations par formulaire et par
API. Ils ne couvrent pas l'édition manuelle d'une fiche existante.

---

## 3. Inscriptions rejouées — l'idempotence

**Symptôme vécu** : six élèves possédant chacun plusieurs fiches, créées à quelques
secondes d'intervalle le même jour. Cause : un flux d'inscription qui **crée** un document
avec un identifiant automatique au lieu de **mettre à jour** l'existant, combiné à un
utilisateur qui reclique parce que rien ne semble se passer.

**Règles** :
- Toute création déclenchée par une action utilisateur doit être **idempotente** :
  rechercher d'abord un document existant sur une clé stable, et mettre à jour le cas
  échéant.
- Désactiver le bouton pendant le traitement et donner un retour visuel immédiat.
- Prévoir un **écran de détection de doublons** : sur une base de milliers d'élèves,
  ils finiront par exister, quelle qu'en soit la cause.

**Conséquence à ne pas oublier** : supprimer un document ne supprime ni ses
sous-collections (il n'y a pas de suppression en cascade), ni les ressources externes
créées avec lui (dossiers de stockage, documents générés, comptes). Une suppression depuis
l'interface laisse donc des **orphelins** — prévoir soit un nettoyage explicite, soit un
inventaire régulier.

---

## 4. « Année de rentrée » n'est pas « nouvel élève »

Distinction contre-intuitive, source d'erreurs de comptage :

| Champ | Ce que c'est | Ce que ce n'est pas |
|---|---|---|
| **année de rentrée** (`2026-2027`) | Année scolaire ciblée par la dernière (ré)inscription. **Bumpée pour toute la cohorte réinscrite.** | Un marqueur de première entrée dans l'école |
| **année d'inscription** (`1e`, `5GT`, `DASPA`…) | Le **niveau** d'entrée dans le cursus | Une année scolaire |
| **date d'inscription** (`04/02/2026`) | La date réelle | — |

⇒ Pour distinguer un **vrai** nouvel élève, c'est la **date d'inscription** qui fait foi,
pas l'année de rentrée. Un filtre « nouveaux élèves » basé sur la seule année de rentrée
remonte toute la cohorte réinscrite.

Attention aussi au nommage : « année d'inscription » désigne un **niveau**, pas une année.
Ce genre de nom trompeur mérite un commentaire explicite dans le modèle de données.

---

## Modélisation — deux réflexes

- **Annualiser ce qui change chaque année** (options, classe, groupes, résultats) dans une
  sous-collection indexée par année scolaire, et ne garder sur la fiche élève que l'état
  courant. Sans ça, préparer l'année suivante écrase l'année en cours.
- **Ne jamais écrire dans l'état courant pour préparer l'année suivante.** La constitution
  des classes de l'année N+1, faite dès juin, doit vivre dans une structure séparée. Elle
  ne sera reportée sur l'état courant qu'au basculement — décision explicite, jamais
  automatique.
