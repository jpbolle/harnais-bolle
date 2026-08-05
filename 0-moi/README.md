# 0-moi — le tier qui ne forke jamais

Ce dossier décrit **l'utilisateur**, pas un projet. Il est vrai quel que soit le domaine,
quelle que soit la stack, quelle que soit l'année.

## Les trois fichiers

| Fichier | Contenu | Comment le remplir |
|---|---|---|
| [`profil.md`](profil.md) | Qui je suis, mon contexte, mon rapport au code | Interview |
| [`methode.md`](methode.md) | Comment on travaille ensemble : rythme, validation, format des réponses | Interview |
| [`consignes.md`](consignes.md) | Les consignes durables déjà données, valables partout | S'enrichit au fil des projets |

## Mécanisme de diffusion : pull, jamais copie

Les tiers 1 à 3 se **copient** dans un nouveau projet, puis divergent — c'est voulu, un
harnais de projet doit absorber les règles locales.

`0-moi/` est l'exception : il ne doit **jamais** forker. Deux versions de « qui je suis »
qui divergent, c'est un agent qui applique des consignes périmées.

Deux façons de le rendre disponible dans un projet, au choix :

1. **Recopier son contenu dans `~/.claude/CLAUDE.md`** (mémoire globale de la machine) —
   chargé automatiquement dans tous les projets de cette machine. À refaire sur chaque
   poste, et à re-synchroniser à chaque évolution.
2. **Renvoyer vers ce dépôt** depuis l'`AGENTS.md` du projet, et faire un `git pull` ici
   au début des sessions importantes.

La solution 1 est plus confortable au quotidien ; la 2 garantit qu'il n'existe qu'une
seule version. En pratique : 1 pour le confort, avec re-synchronisation depuis ce dépôt
dès que `consignes.md` change.

> ⚠️ Point de vigilance à deux machines : la mémoire automatique de Claude Code vit dans
> `~/.claude/projects/<chemin-du-dossier>/memory/` — un chemin **dérivé du nom du dossier
> de travail**. Renommer le dossier d'un projet orpheline toute sa mémoire, et rien ne se
> synchronise entre deux postes. C'est arrivé sur KitSchool (dossier renommé → mémoire de
> juin restée derrière). D'où la recommandation de [`../1-methode/memoire.md`](../1-methode/memoire.md) :
> mettre la mémoire **dans le dépôt du projet**.

## Règle pour l'agent

**Ne rien inventer ici.** Une déduction plausible sur quelqu'un est plus nuisible qu'une
case vide : elle sera traitée comme un fait par toutes les sessions suivantes. Tout ce
qui n'a pas été déclaré explicitement porte la mention `(déduit — à valider)` jusqu'à
confirmation.
