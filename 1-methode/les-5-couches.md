# Le modèle des 5 couches

Le harnais d'un projet s'organise en cinq couches, classées par **fréquence de changement**
de l'information qu'elles portent.

```
┌────────────────────────────────────────────────────────────────────┐
│ COUCHE 1 — RÈGLES IMPÉRATIVES          AGENTS.md (racine)          │
│   Ce qu'un agent ne doit JAMAIS violer. Lu automatiquement par     │
│   Cursor (nativement) et Claude Code (symlink CLAUDE.md).          │
│   Fréquence de changement : quasi nulle.                           │
├────────────────────────────────────────────────────────────────────┤
│ COUCHE 2 — BRIEFING STABLE             init.md (racine)            │
│   Architecture, conventions, modèle de permissions, état des       │
│   modules, gotchas. Change sur modification structurelle réelle.   │
│   Fréquence : mensuelle.                                           │
├────────────────────────────────────────────────────────────────────┤
│ COUCHE 3 — MÉMOIRE CROSS-SESSIONS      memoire/ (voir memoire.md)  │
│   Ce qui a changé récemment, TODOs, décisions. Index à 1 ligne     │
│   par entrée + rollups par module + archive.                       │
│   Fréquence : chaque session.                                      │
├────────────────────────────────────────────────────────────────────┤
│ COUCHE 4 — SAVOIR-FAIRE                .claude/skills/             │
│   Procédures répétables sous forme de checklists exécutables.      │
│   Fréquence : quand une procédure se stabilise.                    │
├────────────────────────────────────────────────────────────────────┤
│ COUCHE 5 — GARDE-FOUS MÉCANIQUES       hooks/ + CI                 │
│   Vérifications qui ne dépendent PAS de la bonne volonté de        │
│   l'agent. Fréquence : quasi nulle.                                │
└────────────────────────────────────────────────────────────────────┘
```

## Où écrire quoi — l'arbre de décision

Avant d'écrire une information dans un projet, se poser les questions **dans cet ordre** :

1. **Est-ce une règle qu'un agent ne doit jamais violer ?** → couche 1 (`AGENTS.md`).
   Critère strict : sa violation casse quelque chose de réel (prod, données, conformité).
   Un simple « c'est mieux comme ça » n'y a pas sa place.
2. **Est-ce vrai de l'architecture et stable au mois ?** → couche 2 (`init.md`).
3. **Est-ce une procédure qu'on a déjà exécutée au moins deux fois, avec des étapes
   faciles à oublier ?** → couche 4 (un skill).
4. **Sinon** → couche 3 (mémoire). C'est le défaut : l'actualité, les décisions, les TODOs.

La couche 5 ne se décide pas au cas par cas : elle s'installe une fois au démarrage du
projet.

## Pourquoi ces emplacements-là

La plupart ne sont pas négociables — ils sont imposés par les outils :

| Emplacement | Imposé par |
|---|---|
| `AGENTS.md` à la racine | Cursor le lit nativement |
| `CLAUDE.md` → symlink vers `AGENTS.md` | Claude Code charge `CLAUDE.md` automatiquement |
| `.claude/skills/`, `.claude/settings.json` | Claude Code |
| `.github/workflows/` | GitHub |

Le symlink `CLAUDE.md` → `AGENTS.md` est le détail qui compte : il garantit **zéro
divergence** entre ce que lit Cursor et ce que lit Claude Code. Deux fichiers de règles
maintenus en parallèle finissent toujours par se contredire, et c'est l'agent qui tranche
au hasard.

Ce qui n'est imposé par aucun outil (cette documentation, les hooks git) va dans un
dossier `harnais/` à la racine du projet, dont le `README.md` sert de **carte** vers tout
le reste. Un lecteur qui arrive sur le projet ne doit avoir qu'un seul endroit où aller.

## Règles d'entretien

- **`AGENTS.md` ne grossit que pour une règle non négociable nouvelle.** Les gotchas
  ponctuels vont dans `init.md` ou dans la mémoire. Un fichier de règles qui enfle perd
  son autorité : au-delà d'une certaine longueur, un agent le survole.
- **L'index de mémoire reste un index.** Si une entrée dépasse une ligne, son contenu
  appartient à un rollup.
- **Un nouveau skill se justifie à partir de la deuxième exécution** d'une procédure aux
  étapes oubliables. Avant, c'est de la documentation.
- **Le `README.md` du harnais est mis à jour quand une pièce change** (nouveau skill,
  nouveau garde-fou, changement de structure mémoire), pas au fil des sessions.
