# 2-ecole — le socle commun aux applications scolaires

Ce qui sera vrai dans **n'importe quelle application** destinée à un établissement
secondaire de la Fédération Wallonie-Bruxelles. Extrait de KitSchool, dépouillé de tout ce
qui lui est propre (noms de collections, identifiants, routes).

C'est le tier qui a le plus de valeur après `0-moi/` : chaque bloc a été payé en bugs.

## Contenu

| Fichier | Quand le lire |
|---|---|
| [`domaine-fwb.md`](domaine-fwb.md) | Toujours — année scolaire, périodes, décisions, niveaux, horaires |
| [`roles-et-identite.md`](roles-et-identite.md) | Dès qu'il y a des comptes utilisateurs |
| [`donnees-eleves.md`](donnees-eleves.md) | Dès qu'on stocke des élèves |
| [`rgpd-chiffrement.md`](rgpd-chiffrement.md) | Dès qu'on stocke une donnée personnelle |
| [`permissions-3-couches.md`](permissions-3-couches.md) | Dès qu'il y a des droits différenciés |
| [`google-workspace.md`](google-workspace.md) | Si l'école est sous Google Workspace |
| [`stack-firebase-next.md`](stack-firebase-next.md) | Si la stack est Next.js + Firebase |

## Comment s'en servir

Ces blocs ne se copient pas en entier dans un nouveau projet : le skill
[`/nouveau-projet`](../skills/nouveau-projet/SKILL.md) demande ce que fait l'application,
puis n'injecte dans son `AGENTS.md` / `init.md` que les blocs pertinents.

Un projet qui ne gère pas d'élèves n'a rien à faire de `donnees-eleves.md`. L'y coller
« au cas où » est exactement l'erreur que ce dépôt cherche à éviter.

## Critère d'admission

Un contenu n'entre ici que s'il est vrai pour **au moins deux** applications scolaires.
S'il n'est vrai que pour une, il appartient à l'`AGENTS.md` ou à l'`init.md` de cette
application.

Quand un bloc est promu depuis un projet, le dépouiller de tout nom propre : pas de nom
de collection réelle, pas d'identifiant de projet, pas de chemin de fichier spécifique.
Ce qui reste doit être la **règle**, pas son instance.
