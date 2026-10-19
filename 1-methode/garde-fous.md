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
cp harnais-matrice/1-methode/hooks/pre-push        <projet>/harnais/hooks/pre-push
cp harnais-matrice/1-methode/hooks/lint-harnais.sh <projet>/harnais/hooks/lint-harnais.sh
chmod +x <projet>/harnais/hooks/pre-push <projet>/harnais/hooks/lint-harnais.sh
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

## Ce que le hook vérifie

Deux choses, dans l'ordre. La première ne s'adapte pas, la seconde si.

| # | Vérification | Ce qu'elle attrape |
|---|---|---|
| 1 | **Harnais** : la forme des fichiers du harnais, par le script [`hooks/lint-harnais.sh`](hooks/lint-harnais.sh) | Voir le tableau ci-dessous |
| 2 | **Code** : la commande `CHECK_CMD` (compilation, tests…) | Un build de production qui casserait |

### `lint-harnais.sh` : la couche 5 appliquée au harnais lui-même

Toutes les autres couches sont des fichiers texte que personne ne compile. Ce script les
vérifie **sur la forme**, sans rien modifier : déterministe, zéro jeton, relançable à la
main (`harnais/hooks/lint-harnais.sh` depuis la racine) jusqu'à « Tout est OK ». **Tant
qu'il n'a pas dit OK, l'agent n'annonce pas un harnais en ordre** : c'est son verdict qui
fait foi, pas l'impression de celui qui vient d'écrire les fichiers.

| Ce qu'il attrape | Comment ça se manifestait sans lui |
|---|---|
| Un `AGENTS.md` sans `CLAUDE.md` à côté (symlink cassé compris) | Consigne locale **ignorée par Claude Code sans erreur** (cf. [`les-5-couches.md`](les-5-couches.md#consignes-locales--un-agentsmd-par-sous-dossier)) |
| Un `{{PLACEHOLDER}}` ou un `<!-- GABARIT` oublié dans `AGENTS.md`, `init.md`, `roadmap.md`, `harnais/` | L'agent lit un gabarit à la place d'une règle et le traite comme approximatif |
| L'index `MEMORY.md` au-delà de 40 entrées, ou une ligne qui n'est pas de la forme `- [Titre](fichier.md) — accroche` | Contexte **tronqué au démarrage, sans signal** (cf. [`memoire.md`](memoire.md#pièges)) |
| Un `SKILL.md` à l'en-tête YAML absent, non fermé, sans `name`/`description`, ou dont une valeur contient `: ` sans guillemets | **Le skill disparaît de la liste de Claude Code, sans erreur** |
| Un fichier suivi par git qui ressemble à un secret (`.env`, `*.pem`, `*.key`, compte de service…) ou qui dépasse 5 Mo | Il part en ligne au push ; un secret poussé reste dans l'historique et doit être **révoqué**, pas seulement supprimé. Le gabarit [`gitignore.template`](../3-matrice/gitignore.template) prévient, le contrôle attrape |

Il ne juge pas le fond : un `AGENTS.md` bien formé mais faux passe sans bruit.

Pourquoi dans le hook `pre-push` et pas dans un hook Claude Code (script lancé après
chaque écriture de fichier) : un hook Claude Code ne voit que les fichiers écrits par ses
propres outils. Un fichier créé par une commande shell, par Cursor ou à la main lui échappe.
Le push, lui, est le passage obligé de tout ce qui a été créé, quel que soit l'outil.
*Origine : prompt 5 d'installation d'un espace de cours (hook Claude Code lancé par `uv`,
emplacement changé) et skill `validateur` du même auteur (programme déterministe qui
constate sans corriger, convention et dépendance PyYAML écartées), examinés le 2026-10-19.*

## Tester le garde-fou à la pose

Un garde-fou qu'on n'a jamais vu se déclencher n'est pas posé, il est supposé. Juste après
l'installation, **provoquer l'erreur qu'il doit attraper**, voir le refus, puis remettre en
ordre. Le script se lance tel quel, sans pousser :

```bash
mkdir -p tmp-test-hook && echo "test" > tmp-test-hook/AGENTS.md   # orphelin volontaire
harnais/hooks/pre-push          # attendu : !! …AGENTS.md sans CLAUDE.md… et code de sortie 1
rm -r tmp-test-hook
harnais/hooks/pre-push          # attendu : ✅ Tout est OK, puis la compilation
```

**Comment ça se manifeste si on ne teste pas** : le hook est dans le dépôt, `core.hooksPath`
semble bon, et le premier vrai refus arrive des semaines plus tard — ou n'arrive jamais,
parce que le script n'avait pas le droit d'exécution (`chmod +x` oublié) et que git l'a
sauté en silence.
*Origine : prompt 5 ci-dessus, qui testait son hook avec un dossier temporaire supprimé
ensuite — la seule de ses idées reprise telle quelle.*

## Adapter le hook

La vérification 2 du hook fourni lance `npx tsc --noEmit`. Selon le projet, remplacer par
la vérification la plus rapide qui attrape le plus d'erreurs :

| Projet | Commande |
|---|---|
| TypeScript | `npx tsc --noEmit` |
| JS + tests | `npm test` |
| TypeScript + tests minimaux | `npx tsc --noEmit && npm test` |
| Python | `uv run ruff check . && uv run mypy .` (Python passe par uv, cf. [`consignes.md`](../0-moi/consignes.md#dépendances)) |
| Rien de tout ça | ne pas installer de hook plutôt qu'un hook creux — la vérification 1 seule ne justifie pas un hook sur un projet dont le push ne déploie rien |

> **La compilation ne vérifie que la forme.** Elle répond à « est-ce bien un nombre ? »,
> jamais à « est-ce le bon ? ». Sur un projet où un calcul faux atterrit dans un bulletin
> sans provoquer la moindre erreur visible, elle ne suffit pas : voir
> [`tests-minimaux.md`](tests-minimaux.md).

Un hook qui ne vérifie rien de sérieux est pire que pas de hook : il donne l'illusion
d'une barrière.

## Évolution souhaitable (non faite)

Sur les projets Firebase, l'artefact le plus risqué est `firestore.rules` — il porte les
permissions sur des données personnelles, et c'est le seul qui soit **testable sans
production**, via l'émulateur Firebase. C'est le prochain garde-fou à ajouter.
