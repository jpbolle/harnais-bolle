# Les garde-fous mécaniques (couche 5)

Toutes les autres couches dépendent de la bonne volonté de l'agent : il peut lire une
règle et ne pas l'appliquer. La couche 5 est la seule qui l'en empêche **mécaniquement**.

À installer sur tout projet de taille **L** — c'est-à-dire dès que `git push` a un effet
sur des utilisateurs réels.

## Le raisonnement

Sur une app déployée en continu, la question n'est pas « le code est-il bon ? » mais
« qu'est-ce qui empêche un mauvais code d'arriver en production ? ». S'il n'y a pas de
suite de tests — cas fréquent sur ces projets — **la compilation est la seule barrière
automatique disponible**. D'où son caractère non négociable : c'est tout ce qu'on a.

On l'applique deux fois, à deux endroits qui échouent différemment :

1. **Hook `pre-push`** (local, ~5 s) — bloque avant que le code parte. Fonctionne quel que
   soit l'outil qui pousse : Claude Code, Cursor, un IDE, ou l'utilisateur en ligne de
   commande. C'est le seul garde-fou qui protège d'un agent qui ignore les règles.
2. **CI sur machine neutre** (après push) — attrape le « ça marchait chez moi » : fichier
   non commité, dépendance absente du lockfile, variable d'environnement locale.

Le second ne remplace pas le premier : quand la CI échoue, le code est déjà en train d'être
déployé.

## Installation

```bash
cp harnais-matrice/1-methode/hooks/pre-push   <projet>/harnais/hooks/pre-push
chmod +x <projet>/harnais/hooks/pre-push
git config core.hooksPath harnais/hooks        # ⚠️ à refaire sur CHAQUE machine

mkdir -p <projet>/.github/workflows
cp harnais-matrice/1-methode/ci/ci-node-ts.yml <projet>/.github/workflows/ci.yml
```

> ⚠️ **`git config core.hooksPath` n'est pas versionnable.** Le fichier du hook est dans le
> dépôt, mais la configuration qui l'active est locale à la machine. Cloner le projet sur
> un second poste donne donc un harnais **silencieusement désarmé** : le hook est là, git
> ne le regarde pas, rien ne le signale.
>
> C'est arrivé sur KitSchool : le harnais était complet dans le dépôt et le hook inactif
> sur la seconde machine.
>
> **Vérification** (à faire au premier `git status` d'un projet sur une machine) :
> ```bash
> git config core.hooksPath     # doit renvoyer "harnais/hooks", pas du vide
> ```
> Cette vérification fait partie du rituel de début de session.

## Adapter le hook

Le hook fourni lance `npx tsc --noEmit`. Selon le projet, remplacer par la vérification
la plus rapide qui attrape le plus d'erreurs :

| Projet | Commande |
|---|---|
| TypeScript | `npx tsc --noEmit` |
| JS + tests | `npm test` |
| Python | `ruff check . && mypy .` |
| Rien de tout ça | ne pas installer de hook plutôt qu'un hook creux |

Un hook qui ne vérifie rien de sérieux est pire que pas de hook : il donne l'illusion
d'une barrière.

## Évolution souhaitable (non faite)

Sur les projets Firebase, l'artefact le plus risqué est `firestore.rules` — il porte les
permissions sur des données personnelles, et c'est le seul qui soit **testable sans
production**, via l'émulateur Firebase. C'est le prochain garde-fou à ajouter.
