# La mémoire cross-sessions (couche 3)

C'est la couche qui transforme une suite de sessions amnésiques en travail continu. C'est
aussi la plus fragile, parce qu'elle est la seule qui vit **hors du code** — donc la seule
que rien ne vérifie.

## Où la mettre — la décision à prendre au démarrage

### Option A — dans le dépôt du projet : `harnais/memoire/` ✅ recommandé

**Avantages** : survit au renommage du dossier, se synchronise entre plusieurs machines
par `git pull`, lisible par n'importe quel agent (Claude Code, Cursor, autre), versionnée
(on peut voir quand une décision a été prise).

**Prix à payer** : elle est dans le dépôt, donc **jamais de donnée personnelle dedans**.
On y écrit « 11 dossiers orphelins à nettoyer », pas le nom des élèves concernés. En
pratique cette contrainte est saine : une mémoire d'agent n'a aucune raison de contenir
des données réelles.

### Option B — mémoire automatique de l'outil : `~/.claude/projects/<chemin>/memory/`

**Avantage** : chargée automatiquement au début de chaque session, sans rien demander.

**Trois défauts, tous rencontrés sur KitSchool** :
1. Le chemin est **dérivé du nom du dossier de travail**. Renommer le dossier du projet
   orpheline silencieusement toute la mémoire — elle n'est pas perdue, mais plus jamais
   chargée. Symptôme : une session démarre en croyant le projet à un état vieux de
   plusieurs mois.
2. Elle est **par machine**. Rien ne se synchronise entre deux postes ; le travail de
   mémorisation fait d'un côté est invisible de l'autre.
3. Elle est **par outil**. Un agent Cursor ne la lit pas spontanément.

### Recommandation

**Option A**, avec éventuellement un pointeur d'une ligne dans la mémoire automatique de
l'outil renvoyant vers `harnais/memoire/`. On récupère le chargement automatique sans
subir la fragilité du chemin.

## Structure

```
harnais/memoire/
├── MEMORY.md                  ← l'index. 1 LIGNE par entrée. Jamais de contenu.
├── rollup_<module>.md         ← l'état consolidé d'un module
├── <sujet>.md                 ← fichiers topiques (un sujet = un fichier)
└── archive/                   ← journaux bruts des anciennes sessions
```

### `MEMORY.md` — l'index

Une ligne par entrée, format `- [Titre](fichier.md) — accroche`. **Règle stricte : jamais
de contenu.** C'est le fichier chargé à chaque démarrage ; s'il grossit, toutes les
sessions commencent avec un contexte tronqué et l'agent lit une mémoire amputée sans le
savoir. Si une entrée déborde d'une ligne, son contenu appartient à un rollup.

### `rollup_<module>.md` — l'état consolidé

Un par module fonctionnel (`rollup_eleves.md`, `rollup_horaires.md`…). Structure :

```markdown
# Rollup <module>

## État actuel
Ce qui est livré et fonctionne, en quelques lignes.

## Gotchas actifs
Les pièges de ce module, avec leur symptôme observable.

## TODOs
Ce qui reste, avec ce qui bloque.

## Historique
- 2026-08-05 — une ligne sur ce qui a été fait cette session.
```

**Le rollup remplace le journal de session.** L'ancien réflexe — un fichier `session_*.md`
par session — produit une mémoire qui grossit sans jamais se consolider : au bout de
trente sessions, plus personne ne la lit, agent compris. On met à jour le rollup du module
touché et on ajoute **une ligne** à son historique.

### Fichiers topiques

Un sujet, un fichier : un incident et sa réparation, une checklist, un gotcha d'API tierce.
Nom explicite en kebab-case. Ils sont liés depuis les rollups.

## Ce qu'on écrit et ce qu'on n'écrit pas

| On écrit | On n'écrit pas |
|---|---|
| Une décision et **son pourquoi** | Ce que `git log` dit déjà |
| Un piège et **son symptôme observable** | La structure du code (elle change) |
| Un TODO et **ce qui le bloque** | Un récapitulatif des commits passés |
| Une consigne durable de l'utilisateur | Des données personnelles réelles |

Un gotcha noté sans son symptôme est inutilisable : la prochaine session rencontrera le
symptôme sans faire le lien avec la règle. Toujours écrire *comment ça se manifeste*.

## Pièges

- **L'index qui enfle** — le plus fréquent, et invisible : rien ne signale que le contexte
  a été tronqué.
- **La mémoire orpheline** — après renommage du dossier (option B) ou changement de
  machine. Vérifier en début de session que la mémoire chargée parle bien de travaux
  récents ; si elle évoque un état vieux de plusieurs mois alors que le projet a avancé,
  c'est le symptôme.
- **La duplication avec `init.md`** — si une info est dans les deux, elles divergeront.
  L'architecture stable est dans `init.md` ; la mémoire ne contient que ce qui bouge.
