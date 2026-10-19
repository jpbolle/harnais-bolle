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
> À faire une fois par machine. Vérifier : `ls ~/.claude/skills/` doit lister
> `nouveau-projet`. Fait sur le **MacBook Pro le 2026-10-19** ; **Mac Studio : à faire**
> (liste des éléments hors dépôt à rejouer : [`1-methode/skills-externes.md`](../../1-methode/skills-externes.md)).

`MATRICE = ~/Documents/harnais` — le clone local du dépôt `jpbolle/harnais` ; si ce
chemin n'existe pas sur ce poste, **demander où est le clone** au lieu de deviner. Faire un
`git pull` avant de commencer.

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

**D'abord, regarder si `conception.md` existe à la racine** (produit par
[`/conception`](../conception/SKILL.md)). S'il existe, le lire : il répond aux questions 1
à 3 (nom, stack retenue, pas encore de code) et souvent à la 4 (pour qui, combien). Ne pas
les reposer ; les confirmer en une ligne.

Poser les autres questions **par groupes**, pas toutes d'un coup. Écrire les réponses au fur
et à mesure dans un brouillon.

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
| **M** | Application réelle, pas de donnée sensible ni de déploiement automatique | S + `init.md` + `roadmap.md` + skills + rituel |
| **L** | Utilisateurs réels **ou** données personnelles **ou** déploiement automatique | M + `harnais/plans/` + hook + CI + tests minimaux + rollups + skill de déploiement |

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

## Étape 4 — Inventorier, puis écrire

**Règle : n'écraser aucun fichier existant, et ne rien créer d'autre que la liste
ci-dessous.** Sur une app qui a déjà du code (question 3), un `AGENTS.md`, des skills ou un
`settings.json` peuvent déjà exister — et porter des gotchas payés cher.
**Comment ça se manifeste si on l'oublie** : `cp` remplace le fichier sans un mot ;
l'`AGENTS.md` du projet devient le gabarit vierge, et les règles perdues ne réapparaissent
que dans `git diff` — ou nulle part si le fichier n'était pas commité. Même effet discret
pour `git config core.hooksPath` : il débranche un hook existant (husky…) sans erreur.

**4a. Inventaire** — avant toute écriture :

Si le dossier n'a pas de `.git` (cas d'un projet sorti de `/conception`) : **proposer**
`git init -b main`, sans le lancer d'office. Sans dépôt, ni le hook ni la mémoire versionnée
n'ont de sens, et le premier commit reste à l'utilisateur.

```bash
MATRICE=~/Documents/harnais
PROJET=$(pwd)

for f in AGENTS.md CLAUDE.md init.md roadmap.md harnais .claude/skills .claude/settings.json \
         .github/workflows/ci.yml; do
  [ -e "$PROJET/$f" ] && echo "EXISTE DÉJÀ : $f"
done
git config core.hooksPath   # vide attendu ; sinon un hook est déjà branché
```

Si une ligne s'affiche : **s'arrêter**, montrer la liste, et faire trancher l'utilisateur
fichier par fichier (fusionner à la main, garder l'existant, ou renommer l'ancien). Ne
jamais fusionner « logiquement » sans demander.

**4b. Écriture** — `cp -n` (*no-clobber* : ne remplace jamais un fichier existant), en
filet de sécurité même après l'inventaire :

```bash
cp -n $MATRICE/3-matrice/gitignore.template  $PROJET/.gitignore  # toutes tailles ; s'il existe, voir ci-dessous
cp -n $MATRICE/3-matrice/AGENTS.template.md  $PROJET/AGENTS.md
cp -n $MATRICE/3-matrice/init.template.md    $PROJET/init.md      # taille M et plus
cp -n $MATRICE/3-matrice/roadmap.template.md $PROJET/roadmap.md   # taille M et plus
ln -s AGENTS.md $PROJET/CLAUDE.md          # échoue (« File exists ») plutôt qu'écraser

mkdir -p $PROJET/harnais/memoire/archive
cp -n $MATRICE/3-matrice/harnais-README.template.md $PROJET/harnais/README.md

# Taille M et plus
mkdir -p $PROJET/.claude/skills
cp -Rn $MATRICE/1-methode/skills/*           $PROJET/.claude/skills/
cp -n  $MATRICE/1-methode/settings.json.example $PROJET/.claude/settings.json

# Taille L uniquement
mkdir -p $PROJET/harnais/hooks $PROJET/harnais/plans $PROJET/.github/workflows
cp -n $MATRICE/3-matrice/plan.template.md $PROJET/harnais/plans/_gabarit.md
# conception.md devient le premier plan du projet (taille L) ; en S et M il reste à la racine
[ -f $PROJET/conception.md ] && mv $PROJET/conception.md $PROJET/harnais/plans/$(date +%F)-conception.md
cp -n $MATRICE/1-methode/hooks/pre-push        $PROJET/harnais/hooks/pre-push
cp -n $MATRICE/1-methode/hooks/lint-harnais.sh $PROJET/harnais/hooks/lint-harnais.sh
chmod +x $PROJET/harnais/hooks/pre-push $PROJET/harnais/hooks/lint-harnais.sh
git config core.hooksPath harnais/hooks    # seulement si 4a l'a montré vide
cp -n $MATRICE/1-methode/ci/ci-node-ts.yml $PROJET/.github/workflows/ci.yml
```

Puis, **fichier par fichier** :
0. si un `.gitignore` existait déjà, y **ajouter seulement les lignes manquantes** du gabarit
   (secrets, données réelles) et vérifier avec `git ls-files` qu'aucun secret n'est déjà suivi ;
1. remplacer chaque `{{PLACEHOLDER}}` par la réponse correspondante ;
2. **supprimer toute section non retenue à l'étape 3** ;
3. supprimer les commentaires de gabarit ;
4. adapter les deux `SKILL.md` copiés (noms, commandes, surfaces réelles) — un rituel qui
   mentionne une étape inexistante se fait ignorer en entier ;
5. adapter la commande du hook à celle de la question 6 ;
6. créer `harnais/memoire/MEMORY.md` avec un en-tête et l'index vide ;
7. remplir `roadmap.md` avec les réponses à la question 1 — **et demander à l'utilisateur
   ce qu'il a déjà écarté**. C'est le seul moment où il y pense ; après, cette information
   ne s'écrit jamais. Si `conception.md` existe : ses « Étapes » alimentent « Ensuite »,
   son « Ce que ça ne fait pas » alimente « Écarté ».

Noter dans `harnais/README.md` la **version de la matrice** (lire `$MATRICE/VERSION`) et
la date.

---

## Étape 5 — Vérifier

- [ ] `CLAUDE.md` est bien un **symlink** vers `AGENTS.md` (`ls -l CLAUDE.md`)
- [ ] Aucun `{{PLACEHOLDER}}` ni `<!-- GABARIT` ne subsiste — taille L :
      `harnais/hooks/lint-harnais.sh` doit dire « Tout est OK » ; sinon
      `grep -rn '{{' . --exclude-dir=.git`
- [ ] Taille L : `git config core.hooksPath` renvoie `harnais/hooks`
- [ ] Taille L : le hook **refuse** quand il doit (test à la pose : un `AGENTS.md` orphelin
      temporaire, cf. [`garde-fous.md`](../../1-methode/garde-fous.md#tester-le-garde-fou-à-la-pose)),
      puis passe une fois le dossier de test supprimé
- [ ] `AGENTS.md` ne contient **aucune** règle sans objet dans ce projet — relire avec
      cette seule question en tête
- [ ] La mémoire ne contient aucune donnée personnelle

---

## Étape 6 — Rendre compte

Afficher **ce qui a réellement changé** — `git status --short --untracked-files=all` (le
projet est sous git ; sinon, l'arborescence des fichiers listés à l'étape 4b) — et
**confirmer que rien d'autre n'a été créé, et qu'aucune ligne `M` (fichier modifié)
n'apparaît** : c'est la preuve que la règle de l'étape 4 a tenu, pas une affirmation.

Annoncer ensuite : la taille retenue et pourquoi, les fichiers créés, les blocs du socle
**écartés** (et pourquoi — c'est l'information la plus utile pour la suite), et ce qui
reste à faire à la main (valeurs d'environnement, activation du hook sur les autres
machines).

**Ne pas commiter ni pousser sans accord explicite.**
