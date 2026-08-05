---
name: nouveau-projet
description: Installer le harnais dans un nouveau projet — interroge, choisit la taille, génère AGENTS.md et init.md depuis la matrice
user_invocable: true
trigger: "nouveau projet", "installer le harnais", "démarrer une app", "harnais"
---

# Installer le harnais dans un nouveau projet

> **Pour rendre ce skill disponible partout** (il vit dans le dépôt `harnais`, pas dans le
> projet cible) :
> ```bash
> ln -s ~/Documents/harnais/skills/nouveau-projet ~/.claude/skills/nouveau-projet
> ```
> À faire une fois par machine.

`MATRICE = ~/Documents/harnais` (faire un `git pull` avant de commencer).

---

## Principe directeur

**Générer, pas copier.** Les blocs des tiers 1 et 2 sont une *source* dans laquelle on
pioche, pas un contenu à importer en bloc. Une règle hors sujet dans l'`AGENTS.md` d'un
projet apprend à l'agent que ce fichier est approximatif — et il traitera de la même façon
les règles qui protègent la production.

En cas de doute sur un bloc : **ne pas l'inclure**. Il est trivial de l'ajouter plus tard,
et coûteux de retirer une règle à laquelle on a commencé à croire.

---

## Étape 1 — Interroger

Poser ces questions **par groupes**, pas toutes d'un coup. Écrire les réponses au fur et
à mesure dans un brouillon.

**Le projet**
1. Nom du projet, et en une phrase : qu'est-ce qu'il fait, pour qui ?
2. Stack : langage, framework, base de données, hébergeur ?
3. Y a-t-il déjà du code, ou est-ce un démarrage à vide ?

**Le risque** — *c'est ce qui détermine la taille du harnais*
4. Y aura-t-il des utilisateurs réels, et combien ?
5. `git push` déclenche-t-il un déploiement automatique ?
6. Y a-t-il une suite de tests ? Sinon, quelle commande de vérification est la plus rapide
   à attraper le plus d'erreurs (compilation, linter typé) ?

**Les données**
7. Le projet stocke-t-il des données personnelles ? Lesquelles ? Des mineurs ?
8. Y a-t-il des droits différenciés entre utilisateurs ?
9. Est-ce une application **scolaire** (élèves, classes, années scolaires) ?

**Le déploiement**
10. Combien de **surfaces** de déploiement indépendantes ? (application, règles de base
    de données, extension, tâches planifiées, migrations…) — la question qui évite le
    plus de production incohérente.
11. Y a-t-il des réglages qui ne voyagent pas avec le code (variables d'environnement,
    contenu piloté par la base) ?

---

## Étape 2 — Choisir la taille

| Taille | Critère | Contenu |
|---|---|---|
| **S** | Prototype, script, pas d'utilisateur réel | `AGENTS.md` + mémoire |
| **M** | Application réelle, pas de donnée sensible ni de déploiement automatique | S + `init.md` + skills + rituel |
| **L** | Utilisateurs réels **ou** données personnelles **ou** déploiement automatique | M + hook + CI + rollups + skill de déploiement |

Une seule réponse « oui » aux questions 4, 5 ou 7 suffit à imposer **L**.

Annoncer la taille retenue et **pourquoi**, puis demander confirmation avant d'écrire.

---

## Étape 3 — Sélectionner les blocs

Cocher ce qui s'applique réellement :

| Bloc de la matrice | À inclure si |
|---|---|
| `2-ecole/domaine-fwb.md` | Application scolaire FWB (Q9) |
| `2-ecole/roles-et-identite.md` | Comptes utilisateurs (Q8) |
| `2-ecole/donnees-eleves.md` | Le projet stocke des élèves |
| `2-ecole/rgpd-chiffrement.md` | Données personnelles (Q7) |
| `2-ecole/permissions-3-couches.md` | Droits différenciés (Q8) |
| `2-ecole/google-workspace.md` | Intégration Google Workspace |
| `2-ecole/stack-firebase-next.md` | Stack Next.js + Firebase (Q2) |
| `1-methode/garde-fous.md` | Taille L |
| `1-methode/skills/deploiement/` | Plus d'une surface (Q10) |

**Les blocs de `2-ecole/` ne se copient pas dans le projet.** On en tire :
- les **règles impératives** → résumées dans `AGENTS.md` ;
- le **contexte** → résumé dans `init.md` §9 ;
- le reste → **un lien vers le dépôt `harnais`**, pas une copie. Une copie divergera.

---

## Étape 4 — Écrire

```bash
MATRICE=~/Documents/harnais
PROJET=$(pwd)

cp $MATRICE/3-matrice/AGENTS.template.md $PROJET/AGENTS.md
cp $MATRICE/3-matrice/init.template.md   $PROJET/init.md    # taille M et plus
ln -s AGENTS.md $PROJET/CLAUDE.md

mkdir -p $PROJET/harnais/memoire/archive
cp $MATRICE/3-matrice/harnais-README.template.md $PROJET/harnais/README.md

# Taille M et plus
mkdir -p $PROJET/.claude/skills
cp -r $MATRICE/1-methode/skills/*           $PROJET/.claude/skills/
cp $MATRICE/1-methode/settings.json.example $PROJET/.claude/settings.json

# Taille L uniquement
mkdir -p $PROJET/harnais/hooks $PROJET/.github/workflows
cp $MATRICE/1-methode/hooks/pre-push $PROJET/harnais/hooks/pre-push
chmod +x $PROJET/harnais/hooks/pre-push
git config core.hooksPath harnais/hooks
cp $MATRICE/1-methode/ci/ci-node-ts.yml $PROJET/.github/workflows/ci.yml
```

Puis, **fichier par fichier** :
1. remplacer chaque `{{PLACEHOLDER}}` par la réponse correspondante ;
2. **supprimer toute section non retenue à l'étape 3** ;
3. supprimer les commentaires de gabarit ;
4. adapter les deux `SKILL.md` copiés (noms, commandes, surfaces réelles) — un rituel qui
   mentionne une étape inexistante se fait ignorer en entier ;
5. adapter la commande du hook à celle de la question 6 ;
6. créer `harnais/memoire/MEMORY.md` avec un en-tête et l'index vide.

Noter dans `harnais/README.md` la **version de la matrice** (lire `$MATRICE/VERSION`) et
la date.

---

## Étape 5 — Vérifier

- [ ] `CLAUDE.md` est bien un **symlink** vers `AGENTS.md` (`ls -l CLAUDE.md`)
- [ ] Aucun `{{PLACEHOLDER}}` ne subsiste (`grep -rn '{{' . --exclude-dir=.git`)
- [ ] Aucun commentaire `<!-- GABARIT` ne subsiste
- [ ] Taille L : `git config core.hooksPath` renvoie `harnais/hooks`
- [ ] Taille L : le hook s'exécute (`sh harnais/hooks/pre-push`)
- [ ] `AGENTS.md` ne contient **aucune** règle sans objet dans ce projet — relire avec
      cette seule question en tête
- [ ] La mémoire ne contient aucune donnée personnelle

---

## Étape 6 — Rendre compte

Annoncer : la taille retenue et pourquoi, les fichiers créés, les blocs du socle
**écartés** (et pourquoi — c'est l'information la plus utile pour la suite), et ce qui
reste à faire à la main (valeurs d'environnement, activation du hook sur les autres
machines).

**Ne pas commiter ni pousser sans accord explicite.**
