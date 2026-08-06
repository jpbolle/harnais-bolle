# Roadmap et plans — où vit l'intention

> Les [5 couches](les-5-couches.md) décrivent toutes **ce qui est** : les règles,
> l'architecture, l'actualité, les procédures. Aucune ne porte **ce qu'on va faire**.
> Ce fichier comble ce trou avec deux foyers, et deux seulement.

## Le symptôme, d'abord

Sans roadmap, l'agent optimise ce qu'il voit. Il propose de refactoriser un module que tu
comptais jeter le mois prochain, il te reproprose tous les trimestres une idée que tu as
déjà écartée, et il ne peut pas t'avertir qu'une décision d'aujourd'hui ferme une porte
prévue pour plus tard.

Sans plan écrit, le plan validé en début de session vit **dans la conversation** — donc il
meurt avec elle. Session suivante : ni l'agent ni toi ne savez plus pourquoi telle option
avait été écartée, et l'arbitrage se refait à l'identique, ou se refait à l'envers.

## Les deux foyers

| Fichier | Porte | Change | Qui l'écrit |
|---|---|---|---|
| `roadmap.md` (racine) | Où va l'app, dans quel ordre, **et ce qu'on ne fera pas** | au mois | l'utilisateur, l'agent tient à jour |
| `harnais/plans/<AAAA-MM-JJ>-<sujet>.md` | Le plan validé d'**une** tâche neuve ou structurelle | une fois, avant de coder | l'agent, l'utilisateur valide |

### `roadmap.md`

Trois sections, pas plus : **maintenant** (ce qui est en cours), **ensuite** (l'ordre prévu,
sans dates), **écarté** (ce qu'on ne fera pas, avec le motif).

La section « écarté » est la moitié utile du fichier. Une idée rejetée sans motif écrit
revient toujours — et la deuxième fois, personne ne se souvient pourquoi elle avait été
rejetée la première.

**Pas de dates.** Le travail se fait le soir et le week-end : une date posée est une date
ratée, et une roadmap visiblement fausse cesse d'être lue. L'ordre suffit.

### `harnais/plans/`

Un plan s'écrit quand la tâche est **neuve ou structurelle** — le critère de
[`../0-moi/methode.md`](../0-moi/methode.md#rythme). Pas pour un bug, pas pour un
ajustement d'affichage : un plan pour une petite tâche est une cérémonie, et une cérémonie
non suivie dévalue les règles voisines.

Ce qu'un plan contient obligatoirement : **les options envisagées et pourquoi celle-là**.
Un plan qui ne garde que la conclusion ne sert à rien six semaines plus tard — c'est
justement l'alternative écartée qu'on cherche à retrouver.

Une fois la tâche livrée : le plan reste. Il n'est ni supprimé ni mis à jour, c'est une
trace datée. Ce qui a réellement été construit se lit dans `init.md` et dans la mémoire.

## Ce qui ne va PAS là

| Contenu | Son vrai foyer |
|---|---|
| « Corriger le tri de la colonne Nom » | mémoire (TODO) — pas la roadmap : trop petit, trop court |
| « On utilise Firestore, pas Supabase » | `init.md` — c'est un état, pas une intention |
| « Ne jamais pousser sans accord » | `AGENTS.md` — c'est une règle |
| Le compte rendu de ce qui a été fait | mémoire — un plan dit l'avant, pas l'après |

Le test : **si c'est faisable en une session, ce n'est pas de la roadmap, c'est un TODO.**

## Par taille de harnais

| Taille | Ce qu'on installe |
|---|---|
| **S** | rien — les TODOs de la mémoire suffisent, l'horizon est trop court pour une roadmap |
| **M** | `roadmap.md` |
| **L** | `roadmap.md` + `harnais/plans/` |

## Entretien

- La roadmap se relit **au début d'une session qui ouvre un gros chantier**, pas à chaque
  session. Un fichier relu machinalement n'est plus lu.
- Quand une entrée de « ensuite » est livrée, elle **disparaît** de la roadmap : l'état de
  ce qui existe se lit dans `init.md`. Une roadmap qui accumule des lignes cochées devient
  un journal, et personne ne relit un journal.
- Quand une idée est écartée en conversation, l'agent **propose** de l'écrire dans la
  section « écarté ». C'est le seul moment où le motif est encore frais.
