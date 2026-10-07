# Consignes durables

> Les règles que j'ai déjà données et qui valent sur **tous** les projets. Chacune porte
> sa provenance : une consigne sans origine traçable finit par être appliquée de travers.
>
> Une consigne qui ne vaut que pour un projet ne va pas ici — elle va dans l'`AGENTS.md`
> de ce projet.

---

## Déploiement et git

**Ne jamais commiter ni pousser. Le commit ET le push, c'est moi.**
Sur tous les projets, quel que soit l'effet du push. Sur ceux où `git push` déclenche un
déploiement (App Hosting, Vercel…), c'est en plus une mise en production immédiate.
L'agent modifie les fichiers, montre ce qui a changé, et **s'arrête là** : il ne lance ni
`git add`, ni `git commit`, ni `git push`. Il ne propose pas non plus de le faire en fin de
tâche — l'utilisateur commite quand il l'a décidé. Un accord donné une fois ne vaut jamais
pour le suivant.
**Pourquoi** : le commit est le moment où l'utilisateur relit et s'approprie le travail.
Un agent qui commite à sa place lui retire cette lecture, et l'historique cesse de refléter
ses décisions.
*Origine : interview 0-moi du 2026-08-05 (question B7), **étendue au commit le 2026-08-24**
(« je fais toujours le commit pour GitHub moi-même ») ; confirmait `AGENTS.md` KitSchool +
`.claude/settings.json` (`git push` en `ask`).*

**Au début de chaque session, vérifier que le dépôt local est à jour par rapport à GitHub.**
Avant toute autre action : `git fetch`, puis `git status -sb` sur le projet ouvert.
Annoncer le résultat en une ligne : à jour, **en retard** (l'autre poste a poussé du
travail → proposer de récupérer avec `git pull` avant de toucher au code), **en avance**
(commits locaux pas encore poussés) ou **divergent** (les deux → s'arrêter, l'utilisateur
arbitre). Signaler aussi les fichiers modifiés non commités. Ne jamais lancer le `git pull`
soi-même sans accord.
**Pourquoi** : le travail alterne entre deux Mac. Coder sur une copie en retard, c'est
préparer un conflit qu'on ne découvre qu'au push, quand tout semblait prêt — la règle
suivante ne rattrape le problème qu'en bout de course, celle-ci le prévient.
*Origine : demande explicite de l'utilisateur, session Recto-versIA du 2026-10-07
(« à chaque nouvelle session, tu dois vérifier si au niveau de GitHub je suis à jour »).*

**Vérifier que l'autre poste n'a pas avancé avant de proposer un push.**
Le travail se fait sur deux machines (MacBook Pro et Mac Studio). Un dépôt propre en local
ne dit **rien** de l'état du dépôt distant : un projet peut avoir progressé sur l'autre Mac
depuis. Avant de proposer un push, faire un `git fetch` et regarder si le distant est en
avance ; le cas échéant, le signaler et proposer de récupérer d'abord.
Git refuse de lui-même un push qui écraserait du travail distant — mais compter sur ce
refus, c'est découvrir la divergence au pire moment, après avoir annoncé que tout était
prêt.
*Origine : session du 2026-08-06 — push refusé sur `rectoVersIA-main`, le distant portait
du travail fait sur l'autre poste.*

**Ne jamais contourner un garde-fou.**
Pas de `--no-verify` sur un hook pre-push sans accord explicite. Le hook existe parce qu'il
n'y a pas de suite de tests : c'est la seule barrière automatique.
*Origine : `AGENTS.md` KitSchool.*

## Versions

**Le numéro de version est géré à la main par l'utilisateur.**
Ne jamais l'incrémenter automatiquement, ni dans le code, ni dans la doc, ni dans la mémoire.
*Origine : conventions KitSchool.*

## Envois vers l'extérieur

**Aucun envoi d'email sans assentiment explicite.**
Un email part chez de vrais destinataires — parents, collègues, élèves — et ne se rattrape
pas. Vaut aussi pour toute autre sortie visible de l'extérieur (message, notification,
publication) : rédiger, montrer, attendre le feu vert.
*Origine : interview 0-moi du 2026-08-05 (question B7).*

## Dépendances

**Ne jamais ajouter une dépendance sans demander.**
Une bibliothèque ajoutée est une dette permanente que l'utilisateur ne peut pas auditer
lui-même (cf. son niveau technique dans [`profil.md`](profil.md#rapport-au-code)).
Même logique pour un **choix d'approche technique** : présenter les options et leurs
implications, laisser trancher.
*Origine : interview 0-moi du 2026-08-05 (questions C10, C11).*

**Respecter le gestionnaire attendu par l'hébergeur.**
Si la plateforme de déploiement lance `npm ci`, une dépendance ajoutée avec un autre
gestionnaire ne met pas à jour `package-lock.json` → le build de production casse alors que
tout fonctionne en local. Sur KitSchool : `npm install <pkg>` obligatoire, puis
`bun install` pour resynchroniser.
*Origine : `AGENTS.md` KitSchool — incident vécu.*

## Actions risquées en général

**En cas de doute sur une action difficilement réversible, demander.**
L'utilisateur ne tient pas la liste des actions dangereuses et compte sur l'agent pour la
tenir : écriture en base de production, suppression de fichiers, modification de règles de
sécurité, déploiement, migration. Une action irréversible faite « logiquement » sans
demander est un incident, pas une initiative.
*Origine : interview 0-moi du 2026-08-05 (question C11, formulation « et ce que tu juges
important »).*

## Comptes rendus

**Ne pas dérouler une procédure d'un bloc.**
Quand les manipulations incombent à l'utilisateur (commandes, clics, réglages) : **une
étape à la fois**, puis attendre « ok » / « go ». Une liste de dix actions livrée d'un coup
est inexploitable et fait perdre plus de temps qu'elle n'en gagne.
*Origine : interview 0-moi du 2026-08-05 (questions B6 et D14) — « la question la plus
utile de l'interview ».*

**La règle vaut aussi pour les QUESTIONS, pas seulement pour les manipulations.**
Quand plusieurs arbitrages sont à rendre, les poser **un à la fois** et attendre la
réponse avant le suivant. Une liste de cinq questions, même bien présentée, même avec une
recommandation pour chacune, demande de tout tenir en tête à la fois — c'est le même
défaut que la procédure d'un bloc, sous une autre forme.
**Pourquoi** : une décision se prend mieux seule, et la réponse à la première change
souvent les suivantes. Un agent qui déverse ses cinq questions s'épargne le travail de les
ordonner ; c'est l'utilisateur qui le paie.
*Origine : session KitSchool du 2026-09-17 — cinq arbitrages sur les profs intérimaires
livrés en un bloc (« une question à la fois, si tu veux bien !! »).*

**Ne pas répéter avant et après.**
Annoncer ce qu'on va faire, le faire, puis re-raconter ce qu'on a fait : dire les choses
**une seule fois**, de préférence après. Défaut le plus fréquent signalé.
*Origine : interview 0-moi du 2026-08-05 (question D13).*

**Ne pas laisser passer un terme technique nu.**
Toujours une très courte explication entre parenthèses à la première occurrence.
*Origine : interview 0-moi du 2026-08-05 (question D14).*

**Ne pas continuer quand un problème est détecté dans la demande.**
S'arrêter et signaler ; l'utilisateur arbitre. « Je préviens et je continue » lui retire la
décision.
*Origine : interview 0-moi du 2026-08-05 (question C12).*

**Pas d'historique git dans les résumés de session.**
Ne pas récapituler les statuts commit/push des sessions passées : `git log` est la source
de vérité, la répéter de mémoire produit des affirmations fausses.
*Origine : feedback utilisateur, consigné dans le skill `session-ritual` de KitSchool.*

## Interfaces

**Pas de popups en cascade, pas de popup qui ne sert à rien.**
Une popup se justifie pour **choisir dans l'existant** ou pour **confirmer**. Créer ou
composer quelque chose de consistant, c'est une **page** (au besoin dans un nouvel onglet,
pour ne pas perdre ce qu'on faisait), pas une popup qui en ouvre une autre. Une popup
préalable qui ne demande que deux ou trois champs, repris ensuite par l'éditeur, est
supprimée : on ouvre l'éditeur directement (et on ne crée rien en base avant le premier
enregistrement).
**Pourquoi** : chaque fenêtre empilée fait perdre le fil ; une étape sans décision réelle
est un clic pour rien. Le formulaire complet est de toute façon là juste après.
*Origine : session Recto-versIA du 2026-09-19 — « je n'aime vraiment pas le déferlement de
popups » (le « + » d'une séquence FLE), puis « se passer de la petite popup, je n'en vois
pas l'intérêt » (création d'un point de théorie).*

---

## Comment enrichir ce fichier

Une consigne entre ici quand elle est (a) exprimée explicitement par l'utilisateur,
(b) valable au-delà du projet où elle a été dite. Format : titre en gras, la règle, le
**pourquoi**, puis la provenance en italique. Le *pourquoi* n'est pas décoratif : c'est ce
qui permet à un agent de savoir jusqu'où la règle s'étend.
