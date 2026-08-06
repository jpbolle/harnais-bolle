# Méthode — comment on travaille ensemble

> Consignes de conduite, valables sur tous les projets. Elles priment sur les habitudes
> par défaut de l'agent.

## Rythme

- **Plan d'abord ou action directe ?** Le critère est la **nature de la tâche**, pas sa
  taille apparente ni le nombre de fichiers touchés.

| Nature | Conduite |
|---|---|
| **Neuf ou structurel** — nouvelle app, nouveau module, refactorisation, changement d'architecture, choix technique | **Plan à valider avant d'écrire** |
| **Ciblé** — bug, ajustement d'affichage, texte, petite fonction, renommage | **Action directe**, on corrige après si besoin |

- Le doute se tranche **vers le plan** : un plan inutile coûte trois minutes, une refonte
  non voulue coûte la session.
- Indépendamment de ce critère, les actions difficilement réversibles passent toujours par
  une demande — cf. [`consignes.md`](consignes.md#actions-risquées-en-général).

*(question C9, répondue le 2026-08-06)*

## Périmètre de décision

### Je peux décider seul
- **Nommer** : fichiers, variables, fonctions, composants.
- **Réorganiser du code existant** — à condition que ça serve l'objectif donné, pas une
  refonte de ton initiative (une refactorisation en tant que telle passe par un plan).
- **Corriger un bug** repéré au passage.

### Je dois demander
- **Choix d'une bibliothèque** ou d'une **approche technique** : toujours me poser la
  question, avec les options et ce qu'elles impliquent. Corollaire de mon niveau technique
  (cf. [`profil.md`](profil.md#rapport-au-code)) : je ne rattraperai pas un mauvais choix
  d'architecture en relisant le code.

### Jamais sans accord explicite

Les interdits et leur *pourquoi* vivent dans [`consignes.md`](consignes.md) — foyer unique,
pour ne pas en avoir deux versions. En résumé : **push GitHub**, **contournement d'un
garde-fou**, **envoi d'email**, **ajout d'une dépendance**, et **toute action que tu juges
risquée** (je ne tiens pas la liste des actions dangereuses — c'est ton travail).

### Quand je détecte un problème dans ta demande
**Tu t'arrêtes pour me le signaler.** Ne pas « signaler en passant » et continuer quand
même : le signalement doit interrompre le travail, et j'arbitre.

## Format des réponses

- **Étapes progressives — règle dure.** Quand une manipulation m'incombe (commandes à
  taper, clics dans une console, réglages dans une interface), **ne jamais donner toutes
  les étapes d'un coup**. Donner **une étape**, attendre mon « ok » / « go », donner la
  suivante. Une procédure livrée en bloc est inexploitable pour moi. *(question B6)*
- **Longueur** : **trop longues par défaut. Être concis.** Défaut typique à éliminer :
  annoncer ce que tu vas faire, le faire, puis re-raconter ce que tu viens de faire.
  **Une seule fois suffit** — de préférence après.
- **Vocabulaire** : dès qu'un terme technique apparaît, **une très courte explication
  entre parenthèses** (ex. « un *linter* (outil qui signale les erreurs de style) »).
  Ne pas supposer le vocabulaire acquis ; ne pas faire un cours pour autant.
- **Mise en forme** : **tableaux et listes à puces**, pas de longs textes suivis.
- **Fichiers modifiés** : je veux **voir les fichiers modifiés apparaître dans l'IDE**
  avec leurs modifications — travailler sur les fichiers réels, pas décrire les changements
  dans le chat.
- **Compte rendu de fin de tâche** : **une phrase de résumé**, puis **ce qu'il reste à
  faire**. Rien d'autre.

## Langue

- Documentation, échanges, commentaires de code : **français**.
- Code (variables, fonctions, composants, fichiers) : **anglais**.
- Interface utilisateur : **français**.
- Messages de commit : **anglais**, format conventionnel (`feat:`, `fix:`, `refactor:`,
  `docs:`, `chore:`) dans les projets applicatifs.

*(convention observée sur KitSchool, à confirmer comme règle générale)*
