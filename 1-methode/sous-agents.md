# Sous-agents — quand déléguer, et à quelles conditions

> Rien à installer : le mécanisme est natif dans Claude Code. Ce fichier dit **quand s'en
> servir** et **ce qu'il faut leur donner** — les deux points où ça rate.

## Ce que c'est

Un sous-agent est une **session séparée** que la session principale lance pour une tâche
précise. Il a sa propre fenêtre de contexte (la quantité de texte qu'un modèle garde sous
les yeux à un instant donné — grande, mais finie), ses propres outils, et il revient avec
**un rapport**, pas avec tout ce qu'il a lu.

| | Session principale | Sous-agent |
|---|---|---|
| Connaît la conversation en cours | oui | **non — il démarre amnésique** |
| Ce que l'utilisateur voit | tout | son rapport final seulement |
| Contexte consommé dans la session principale | tout ce qui est lu | le rapport seul |

## Le vrai bénéfice : protéger le contexte

Une fouille large — « quels fichiers de ce projet définissent des rôles ? » — fait lire dix
fichiers et autant de sorties de commandes. Dans la session principale, tout cela occupe la
place **définitivement**. Le même travail délégué revient en trois lignes.

Sur une session longue, c'est la différence entre rester net jusqu'au bout et devoir
recommencer à mi-parcours. Le parallélisme (plusieurs modules explorés en même temps) est
un bénéfice secondaire, pas le principal.

## La règle : lire ou écrire

La frontière utile n'est pas « tâche simple / tâche complexe » mais **lecture / écriture**.

| Type de délégation | Verdict |
|---|---|
| **Lire** — explorer, chercher, auditer, relire un changement, comparer | ✅ Gain net. Le sous-agent ne touche à rien ; le pire risque est un rapport inutile |
| **Écrire** — produire du code en parallèle | ⚠️ À encadrer. Trois agents qui écrivent en même temps produisent trois fois plus de code que personne n'a relu (cf. [`../0-moi/profil.md`](../0-moi/profil.md#rapport-au-code)). Et le critère de réussite — le rendu à l'écran — ne se vérifie pas en parallèle : il se vérifie une fois, à la fin |

Corollaire : une tâche d'écriture déléguée doit d'abord être passée par un **plan validé**
(cf. [`roadmap-et-plans.md`](roadmap-et-plans.md)). Un sous-agent qui écrit sans plan, c'est
la décision d'architecture prise par quelqu'un que l'utilisateur n'a jamais vu parler.

## Ce qui existe déjà — ne rien définir avant d'en avoir besoin

Claude Code fournit `Explore` (fouille en lecture seule), `Plan` (conception),
`general-purpose` (recherche multi-étapes) et la relecture de diff. Ils couvrent la majorité
des cas.

**Un sous-agent personnalisé se justifie à la deuxième fois qu'on réécrit le même briefing** —
même règle que pour un skill ou un pattern. Avant, c'est de l'outillage prématuré. Ils se
définissent dans `.claude/agents/` (projet) ou `~/.claude/agents/` (machine, donc **ne suit
pas d'un poste à l'autre** — cf. [`skills-externes.md`](skills-externes.md)).

## Briefer un sous-agent : le point où ça rate

Un sous-agent **n'a pas lu la conversation, ni le harnais**. Livré sans briefing, il produit
du travail générique : il réinvente une forme de code que le projet a déjà fixée, ignore les
interdits, propose une bibliothèque qu'on a écartée il y a six mois.

Tout briefing contient donc, systématiquement :

1. **Quoi lire d'abord** — `AGENTS.md`, `init.md`, et le rollup de mémoire du module concerné.
2. **Le livrable exact** — « la liste des fichiers qui font X, avec chemin et numéro de
   ligne », pas « regarde comment marche X ».
3. **La limite** — « lecture seule, ne modifie aucun fichier », quand c'en est une.

> ⚠️ **Gotcha — un rapport arrive sans ses sources, et il peut être faux avec aplomb.**
> Symptôme : un sous-agent affirme « cette fonction n'existe nulle part dans le projet » ;
> la session principale le croit, part sur une refonte inutile, et la fonction était là
> sous un autre nom. Il n'y a aucun moyen de distinguer un rapport vérifié d'un rapport
> plausible **sauf en exigeant les chemins de fichiers et les numéros de ligne** — ils se
> vérifient en trois secondes. Un rapport sans référence vérifiable se retraite comme une
> hypothèse, pas comme un fait.

## Ce que ça coûte

Un sous-agent est une session complète : il **consomme des jetons rapidement**. Déléguer une
question à laquelle on peut répondre en ouvrant un fichier est une dépense pure. Le calcul
est simple : déléguer si la recherche va lire **beaucoup** pour produire **peu**.

## Portabilité

Les sous-agents sont un mécanisme **propre à Claude Code**. Cursor et Antigravity n'ont pas
d'équivalent qui lise `.claude/agents/`. Conséquence pour le harnais : **aucune règle vitale
ne doit vivre uniquement dans une définition de sous-agent** — sa place est dans `AGENTS.md`,
que tous les outils lisent. Un sous-agent applique des règles ; il ne les héberge pas.

## Le lien avec le reste du harnais

Un sous-agent démarre amnésique : sa qualité dépend entièrement de ce qu'il peut lire en
arrivant. `AGENTS.md`, `init.md`, les patterns imposés, la mémoire — **le harnais est la
condition de possibilité des sous-agents**, pas un supplément.

Autrement dit : un projet sans harnais ne gagne rien à déléguer, il multiplie simplement le
nombre d'agents qui réinventent.
