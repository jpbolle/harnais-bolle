# Harnais — matrice de démarrage pour mes projets

> Dépôt **privé**. Il contient ce qui ne doit jamais être réécrit deux fois : qui je suis,
> comment je travaille avec un agent IA, et le socle commun de mes applications scolaires.
>
> Créé le 2026-08-05, par extraction du harnais de KitSchool (mis en place le 2026-07-19).

---

## À quoi sert ce dépôt

Un agent IA démarre chaque session amnésique. Sur un projet long, il redécouvre tout à chaque
fois, ignore les gotchas déjà payés et peut casser la prod. Le **harnais** est l'ensemble des
fichiers, rituels et garde-fous qui transforment cette amnésie en continuité.

Ce dépôt-ci n'est pas le harnais d'un projet : c'est la **matrice** qui sert à en fabriquer un,
plus le socle réutilisable qu'on n'a pas envie de réécrire à chaque nouvelle app.

## Le principe : quatre tiers de durée de vie

Toute information utile à un agent appartient à l'un de ces quatre tiers. Les mélanger est
l'erreur qui rend un harnais inutilisable.

| Tier | Contenu | Durée de vie | Sort |
|---|---|---|---|
| **0 — Moi** | Qui je suis, comment je décide, mes consignes durables | Des années | **Se pull**, ne se copie jamais |
| **1 — Méthode** | Rituels, mémoire, garde-fous, structure du harnais | Stable | Se copie et s'adapte |
| **2 — École** | Domaine FWB, rôles, RGPD, Google Workspace, pièges données élèves | Stable | Se pioche selon le projet |
| **3 — Projet** | Noms de collections, champs, routes, ID Firebase | Change chaque semaine | **Se génère**, jamais ne se copie |

Un agent qui lit une règle non pertinente apprend que les règles sont décoratives. D'où la
règle centrale de ce dépôt : **la matrice livre des gabarits à remplir, pas du contenu à
importer**.

## Contenu

```
0-moi/        Profil, méthode de travail, consignes durables.   → à PULL dans chaque projet
1-methode/    Le squelette agnostique : 5 couches, mémoire,     → à COPIER puis adapter
              garde-fous, skills portables, hook, CI
2-ecole/      Le socle commun aux apps scolaires FWB            → à PIOCHER par blocs
3-matrice/    Les gabarits AGENTS.md / init.md / harnais-README → à REMPLIR
skills/       Le lanceur /nouveau-projet                        → à invoquer
```

## Démarrer une nouvelle app

Dans le dossier du nouveau projet, avec un agent :

```
/nouveau-projet
```

Le skill pose une dizaine de questions (stack, prod ou non, données personnelles, surfaces de
déploiement, taille du harnais), puis **génère** l'`AGENTS.md` et l'`init.md` du projet en
piochant uniquement les blocs des tiers 1 et 2 qui s'appliquent réellement.

À défaut d'agent, la procédure manuelle est dans [`3-matrice/README.md`](3-matrice/README.md).

## Trois tailles

Le harnais complet est calibré pour une app en production avec données réelles. L'appliquer
à un prototype produit une cérémonie que personne ne suit — et une règle non suivie dévalue
toutes les autres.

| Taille | Pour quoi | Ce qu'on installe |
|---|---|---|
| **S** | Prototype, script, expérience | `AGENTS.md` + mémoire |
| **M** | App réelle sans données sensibles ni prod critique | S + `init.md` + `roadmap.md` + skills + rituel de session |
| **L** | App en prod, données personnelles, déploiement automatique | M + plans validés + hook pre-push + CI + tests minimaux + rollups mémoire + skill de déploiement |

KitSchool est en **L**. La plupart des projets sont en **M**.

## Entretien

- **Une info, un seul foyer.** Avant d'écrire : est-ce moi (tier 0) ? ma méthode (tier 1) ?
  le domaine scolaire (tier 2) ? ce projet-ci (tier 3, donc pas ici) ?
- `0-moi/` ne forke jamais. S'il évolue dans un projet, la modification remonte ici.
- Un bloc n'entre dans `2-ecole/` que s'il est vrai pour **au moins deux** applications scolaires.
- `VERSION` est bumpé à chaque évolution de la matrice ; chaque projet note dans son
  `harnais/README.md` de quelle version il est né.
- **Jamais de secret, de clé ni de donnée d'élève ici.** Ce dépôt décrit des méthodes,
  pas des contenus.
