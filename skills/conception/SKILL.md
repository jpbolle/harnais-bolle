---
name: conception
description: Concevoir une application ou un petit outil à partir d'une idée, AVANT d'écrire la moindre ligne de code — interview une question à la fois, options de stack proposées par l'agent, puis un plan d'exécution écrit dans conception.md à la racine. À utiliser dès qu'un utilisateur décrit une app qu'il voudrait construire, dans un dossier vide ou sans code. Ne génère ni code ni harnais (ça, c'est /nouveau-projet, ensuite).
user_invocable: true
trigger: "j'ai une idée d'app", "je voudrais une application qui", "un petit outil pour", "concevoir", "avant de coder", "/conception <pitch>"
---

# Concevoir une app avant de la coder

> **Pour rendre ce skill disponible partout** (il vit dans le dépôt `harnais`, pas dans le
> projet cible) :
> ```bash
> ln -s ~/Documents/harnais/skills/conception ~/.claude/skills/conception
> ```
> À faire une fois par machine. Vérifier : `ls ~/.claude/skills/` doit lister `conception`.
> Fait sur le **MacBook Pro le 2026-10-19** ; **Mac Studio : à faire**.

`MATRICE = ~/Documents/harnais` — si ce chemin n'existe pas sur ce poste, **demander où est
le clone** au lieu de deviner.

## Le symptôme que ce skill évite

Une app vibe-codée sans conception change de forme à chaque session : le périmètre grossit
au fil des « et si on ajoutait… », la stack a été choisie par l'agent sans que l'utilisateur
sache ce qu'il perdait, et personne ne sait dire quand c'est fini. Ce skill produit **un
seul fichier**, `conception.md`, qui fixe ces trois choses avant le premier fichier de code.

Il **ne produit ni code, ni harnais, ni dépendance**. La suite, c'est `/nouveau-projet`.

## Entrée : le pitch

S'invoque avec le pitch : `/conception un petit site pour partager mes ressources de cours`.
Sans pitch, **poser une seule question** : « Décris-moi l'app en deux ou trois phrases : ce
qu'elle fait, pour qui. » Attendre la réponse avant tout le reste.

Puis une seule question logistique : le **nom court** du projet (minuscules, tirets, sans
accents). Il sert de titre et, plus tard, de nom de dossier.

## Phase 1 — Comprendre (une question à la fois)

Poser **une question par message**, dans cet ordre, en sautant celles que le pitch a déjà
réglées. Si l'utilisateur répond « passe » ou « pas important » : écrire `(non précisé)` et
ne pas y revenir.

| # | Question | Pourquoi elle compte |
|---|---|---|
| 1 | **Ce que ça fait, et ce que ça ne fait pas** | La deuxième moitié est la plus utile : c'est elle qui tient le périmètre |
| 2 | **Pour qui, combien, sur quel matériel** | Des élèves ⇒ navigateur sous ChromeOS, écran et clavier d'entrée de gamme (cf. [`0-moi/profil.md`](../../0-moi/profil.md)). Des utilisateurs réels ⇒ taille L au moment du harnais |
| 3 | **À quoi ça ressemble**, écran par écran : ce qu'on voit, ce qu'on peut faire, où ça mène | C'est la description la plus concrète qu'on puisse obtenir sans maquette, et celle que l'agent transforme le mieux en code |
| 4 | **Une contrainte réelle** : temps disponible, hébergement, matériel, compétence | Une contrainte non dite devient un blocage découvert en cours de route |
| 5 | **Comment on saura que c'est réussi**, en termes d'usage réel | Sans ce critère, l'app n'est jamais finie |

Quand la matière suffit : **résumer en trois à cinq puces** et demander « quelque chose à
ajuster avant qu'on parle de la technique, ou je continue ? ». Attendre le go. **Aucun
fichier écrit à ce stade.**

## Phase 2 — Choisir la stack (l'agent propose, l'utilisateur tranche)

Ne **pas** demander à l'utilisateur quelle stack il veut : le choix technique, c'est l'agent
qui le prépare, avec des options et ce qu'elles impliquent, et l'utilisateur qui tranche
(règle de [`0-moi/methode.md`](../../0-moi/methode.md#périmètre-de-décision)).

Présenter **deux ou trois options**, pas plus, dans un tableau : ce que ça implique, coût
et risque, en langage courant, chaque terme technique expliqué entre parenthèses. Partir de
l'infrastructure que l'utilisateur a déjà (base de données, hébergement, nom de domaine :
voir [`0-moi/profil.md`](../../0-moi/profil.md#identité-et-contexte)) et de la réponse à la
question 2 : une app pour élèves tourne dans le navigateur, point. Recommander une option
et dire pourquoi. **Aucune nouvelle question de fond** : si une réponse de la phase 1
manque, écrire `(non précisé)`.

Attendre la décision. Si l'utilisateur hésite, c'est le moment de le dire : une app
jetable ne mérite pas la même stack qu'une app pour 1300 personnes.

## Phase 3 — Écrire `conception.md`

Un seul fichier, à la racine, depuis le gabarit :

```bash
cp -n ~/Documents/harnais/3-matrice/conception.template.md ./conception.md   # n'écrase jamais
```

Si `conception.md` existe déjà : **s'arrêter**, le montrer, et demander (compléter,
remplacer, ou renommer l'ancien avec sa date).

Remplir **toutes** les sections du gabarit avec les réponses des phases 1 et 2, puis :
- **Étapes** : dans l'ordre, chacune terminée « quand on voit… » à l'écran. Première
  étape : ce qui est visible le plus tôt (une page qui s'affiche avec de vraies données),
  pas l'infrastructure.
- **Stack** : garder toutes les options présentées, pas seulement la retenue.
- **Points ouverts** : tout ce qui a été laissé `(non précisé)` et qui bloquera une étape.
- Supprimer le commentaire de gabarit, remplacer `{{VERSION_HARNAIS}}` par le contenu de
  `$MATRICE/VERSION`.

**Rien d'autre n'est créé** : pas de dossier, pas de `README`, pas de code, pas de
`package.json`. Le fichier apparaît dans l'IDE, l'utilisateur le relit là.

## Phase 4 — Rendre compte et passer la main

Afficher, en une phrase chacune : le périmètre, la stack retenue et pourquoi, le nombre
d'étapes. Puis **la suite, une étape à la fois** :

1. Relire `conception.md` et corriger ce qui ne va pas, avant toute autre chose.
2. Lancer `/nouveau-projet` : il lit `conception.md` (ses questions 1 à 3 sont déjà
   répondues), choisit la taille du harnais et pose `AGENTS.md`, `init.md`, `roadmap.md`.
   En taille L, il range `conception.md` dans `harnais/plans/` comme premier plan.
3. Coder **une étape de `conception.md` à la fois**, en montrant le résultat à l'écran à
   chaque fois.

Ne pas proposer de commencer à coder dans la même session sans passer par l'étape 2 : un
projet qui a des utilisateurs réels a besoin de son harnais avant son premier push.

## Règles transverses

- Une question par message, le récap de fin de phase excepté.
- Aucun fichier avant la phase 3 ; un seul fichier à la phase 3.
- `(non précisé)` plutôt qu'une supposition : rien n'est inventé sur l'app ni sur
  l'utilisateur.
- Les options de stack sont **présentées**, jamais imposées ; aucune bibliothèque n'est
  installée ici.
- Français partout ; les termes techniques expliqués entre parenthèses à la première
  occurrence.

---

*Origine : adapté le 2026-10-19 du skill `conception_numerique` d'un collègue (cascade
IDEA.md → PLAN.md → AGENTS.md). Ce qui change chez nous, et pourquoi : la stack est
proposée en options par l'agent au lieu d'être demandée à l'utilisateur (règle de
`methode.md`) ; les alternatives écartées sont conservées (doctrine des plans) ; un seul
fichier `conception.md` au lieu de trois, parce que l'état vit dans `init.md` et les règles
dans `AGENTS.md`, posés ensuite par `/nouveau-projet` ; pas de journal (remplacé par la
mémoire et les rollups).*
