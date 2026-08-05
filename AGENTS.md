# Harnais — instructions pour les agents IA

> Ce fichier est la source unique des règles de **ce dépôt-ci**.
> Lu nativement par Cursor, et par Claude Code via le symlink `CLAUDE.md` → `AGENTS.md`.
> Vue d'ensemble pour humains : [`README.md`](./README.md).

## Ce dépôt n'est pas une application

C'est la **matrice** qui sert à fabriquer le harnais d'une nouvelle app, plus le socle
réutilisable entre mes projets. Il n'y a pas de code à compiler, pas de prod à casser.
Le livrable ici, c'est de la **documentation exécutable par un agent**.

## `0-moi/` — la pièce la plus précieuse du dépôt

`0-moi/profil.md` et `0-moi/methode.md` ont été **remplis par interview le 2026-08-05**
(source : [`0-moi/interview.md`](0-moi/interview.md)). Ils décrivent l'utilisateur et priment
sur les habitudes par défaut de l'agent : les lire avant d'agir, sur ce dépôt comme ailleurs.

Règle absolue pour ces fichiers : **ne rien inventer sur l'utilisateur.** Tout ce qui est
déduit plutôt que déclaré doit porter la marque `(déduit — à valider)`. Une case vide vaut
mieux qu'une supposition plausible : la supposition sera traitée comme un fait par toutes
les sessions suivantes.

Pour les compléter plus tard (nouvelle question, règle nouvellement exprimée) : reprendre
l'interview par petits groupes de 3-4 questions et **écrire au fur et à mesure**.

## Les quatre tiers (règle structurante)

Avant d'écrire quoi que ce soit dans ce dépôt, identifier le tier :

| Tier | Dossier | Critère d'admission |
|---|---|---|
| 0 — Moi | `0-moi/` | Vrai quel que soit le projet **et** le domaine |
| 1 — Méthode | `1-methode/` | Vrai pour n'importe quelle app, même non scolaire |
| 2 — École | `2-ecole/` | Vrai pour **au moins deux** applications scolaires FWB |
| 3 — Projet | *(pas ici)* | Spécifique à une app → vit dans le dépôt de cette app |

Un contenu qui ne satisfait pas le critère d'admission de son dossier n'entre pas.
En cas de doute, il appartient au tier le plus spécifique.

## Règles d'écriture

- **Une info, un seul foyer.** Jamais la même règle dans deux fichiers : deux copies divergent
  toujours. Si un renvoi est nécessaire, faire un lien, pas une copie.
- **Des gabarits, pas du contenu.** `3-matrice/` ne doit contenir aucune valeur concrète
  (nom de projet, ID Firebase, nom de collection) : uniquement des `{{PLACEHOLDERS}}` et des
  instructions de remplissage.
- **Chaque gotcha porte sa cicatrice.** Un piège documenté sans le symptôme observable qu'il
  produit est inutilisable : toujours écrire *comment ça se manifeste*, pas seulement la règle.
- **Français** pour toute la documentation de ce dépôt.
- **Aucun secret, aucune clé, aucune donnée d'élève.** Jamais, même en exemple. Utiliser des
  valeurs fictives explicitement marquées comme telles.

## Entretien

- `VERSION` (semver) est bumpé quand la matrice évolue :
  - patch = correction ou précision ;
  - mineur = nouveau bloc, nouveau skill ;
  - majeur = changement de structure des tiers (les projets nés d'une version antérieure
    ne sont plus alignés).
- Toute modification de `0-moi/` faite depuis un autre projet doit **remonter ici**
  (ce dossier ne forke pas).
- Un bloc de `2-ecole/` promu depuis un projet doit être **dépouillé de tout nom propre**
  de ce projet avant d'entrer.

## Git

Dépôt privé (`jpbolle/harnais`). Pas de déploiement, pas de CI : un push n'a aucun effet
de bord. Commits en français ici (contrairement aux projets applicatifs, où ils sont en
anglais conventionnel) — c'est de la documentation personnelle, pas du code.
**Ne jamais pousser sans accord explicite de l'utilisateur** (règle générale, cf. `0-moi/`).
