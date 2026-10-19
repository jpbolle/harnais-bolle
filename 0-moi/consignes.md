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

**En fin de session, TOUJOURS donner la commande de déploiement du serveur (VPS Hostinger).**
Quand du code a été écrit, le compte rendu de fin de session ne s'arrête pas à « rien n'est
commité ni déployé » : il donne la suite jusqu'à la production — commit, push (faits par
l'utilisateur), puis la **commande à coller dans le terminal web Hostinger** (celle du skill
`/deploy` du projet), en rappelant les surfaces annexes si elles sont concernées (règles
Firestore, variables d'environnement). Toujours étape par étape (règle ci-dessous).
**Pourquoi** : l'agent l'oubliait systématiquement ; l'utilisateur devait la réclamer à
chaque fin de session, et un oubli laisse en production une version différente de celle
qu'il croit avoir livrée.
*Origine : session Recto-versIA du 2026-10-14 (« la commande hostinger que tu oublies
toujours de me donner. Note-le d'ailleurs dans le harnais »).*

**Ne jamais effacer du travail ni de l'historique : liste nommée.**
Jamais sans accord explicite, même « logiquement » pour sortir d'une situation : `git reset
--hard`, `git checkout -- <fichier>` ou `git restore <fichier>` sur un fichier modifié, `git
clean`, `git stash drop`, `git push --force`, `git rebase` sur des commits déjà poussés,
`git branch -D`. Toutes détruisent ce qui n'est pas commité, ou réécrivent ce qui l'est, sans
retour. Pour **revenir en arrière** : commiter d'abord l'état courant (c'est le filet), puis
`git restore --source=<commit> -- <fichier>` pour un fichier, `git revert` pour un commit
entier ; l'historique reste intact et le retour est lui-même réversible.
**Pourquoi** : la règle « en cas de doute sur une action irréversible, demander » suppose que
l'agent ait le doute. Une commande qu'il connaît bien ne lui en inspire aucun ; la liste
remplace le doute.
*Origine : skill `git` d'un collègue (« n'efface jamais d'historique »), examiné le
2026-10-19 ; le reste du skill, où l'agent commite et pousse lui-même, a été écarté.*

**Ne jamais contourner un garde-fou.**
Pas de `--no-verify` sur un hook pre-push sans accord explicite. Le hook existe parce qu'il
n'y a pas de suite de tests : c'est la seule barrière automatique.
*Origine : `AGENTS.md` KitSchool.*

## Versions

**Le numéro de version est géré à la main par l'utilisateur.**
Ne jamais l'incrémenter automatiquement, ni dans le code, ni dans la doc, ni dans la mémoire.
*Origine : conventions KitSchool.*

**Avant chaque déploiement, PROPOSER un changement de version — l'utilisateur tranche.**
Regarder ce qui part en production et proposer, en une ligne avec la raison : **gros
changement** (nouveau module, refonte visible) → deuxième chiffre (`3.1` → `3.2`) ;
**changements mineurs** (retouches, corrections) → troisième chiffre (`3.1.1` → `3.1.2`) ;
rien de visible → ne pas changer. On ne modifie le fichier de version qu'après son accord,
et avant le build, pour que le numéro parte avec le déploiement.
**Pourquoi** : le numéro reste une décision de l'utilisateur (règle ci-dessus), mais il
oubliait de le faire évoluer — la v3.0 a couvert des semaines de changements. La question
posée au bon moment remplace la mémoire qu'on n'a pas.
*Origine : session Recto-versIA du 2026-10-11 (passage manuel de 3.0 à 3.1).*

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

**Python : tout passe par uv — jamais `pip install` ni environnement activé à la main.**
uv (gestionnaire de projets Python) remplace pip et venv : `uv init` pour créer un projet,
`uv add <bibliothèque>` pour en ajouter une (la demande d'accord ci-dessus reste
obligatoire), `uv run <commande>` pour exécuter — uv crée et utilise tout seul
l'environnement isolé du projet. Un script isolé se lance aussi par `uv run script.py` ; s'il
a besoin d'une bibliothèque, il la déclare **dans son en-tête** (bloc `# /// script` avec
`dependencies = [...]`, métadonnées inline) et uv l'installe à la volée, sans projet ni
fichier de dépendances à côté. *(technique vue dans le skill `validateur` d'un collègue,
2026-10-19)*
Installation : par l'**installateur officiel**
(`curl -LsSf https://astral.sh/uv/install.sh | sh`, dans `~/.local/bin`), **pas par
Homebrew** ; mise à jour par `uv self update`.
**Comment ça se manifeste si on l'oublie** : un `pip install` lancé hors de uv installe la
bibliothèque dans le Python du Mac, pas dans le projet — le script marche sur ce poste et
échoue sur l'autre avec `ModuleNotFoundError`. *(déduit — à valider)*
**Pourquoi** : outil recommandé à l'utilisateur, qui l'a adopté « pour tout ce qui est
Python ».
*Origine : session harnais du 2026-10-14. Installé ce jour-là sur le MacBook Pro par
l'installateur officiel, parce que Homebrew y refusait toute installation (« Please update
your Command Line Tools ») — Homebrew reste à réparer. **Mac Studio : pas encore
installé.***

## Actions risquées en général

**En cas de doute sur une action difficilement réversible, demander.**
L'utilisateur ne tient pas la liste des actions dangereuses et compte sur l'agent pour la
tenir : écriture en base de production, suppression de fichiers, modification de règles de
sécurité, déploiement, migration. Une action irréversible faite « logiquement » sans
demander est un incident, pas une initiative.
*Origine : interview 0-moi du 2026-08-05 (question C11, formulation « et ce que tu juges
important »).*

## Exactitude

> Les quatre règles de cette section viennent d'un prompt d'installation de « persona »
> examiné en session harnais le 2026-10-14. L'utilisateur a demandé d'y reprendre « ce que
> tu juges à reprendre ». Le reste du prompt a été écarté (références culturelles
> obligatoires, synthèse finale, registres de personnage), parce qu'il contredisait la
> concision exigée dans [`methode.md`](methode.md#format-des-réponses).

**Sur l'IA récente, vérifier avant d'affirmer.**
Modèles, outils, fonctions de Claude Code, de Cursor ou d'Antigravity de moins d'un an :
consulter la documentation officielle ou faire une recherche **avant** d'écrire quoi que ce
soit, surtout dans le harnais. La connaissance interne de l'agent a une date de coupure.
Ces outils changent de comportement d'une version à l'autre.
**Comment ça se manifeste** : une affirmation plausible mais périmée. Le jour même où la
règle a été adoptée, l'agent a écrit que Claude Code « ne lit pas `AGENTS.md` ». La
documentation dit qu'il le lit depuis la version 2.1.277. Une fois écrite dans la matrice,
l'erreur se serait recopiée dans chaque projet.
*Origine : session harnais du 2026-10-14.*

**Séparer le fait, l'interprétation et la lacune.**
Quand une réponse s'appuie sur un fichier, une doc ou des données, signaler de quel
registre relève chaque affirmation :
- le fait : « le fichier dit que » ;
- l'interprétation : « je lis ça comme » ;
- la lacune : « le fichier ne précise pas ».

C'est la marque `(déduit — à valider)` de `0-moi/`, appliquée aux réponses.
**Pourquoi** : l'utilisateur ne relit pas le code lui-même (cf.
[`profil.md`](profil.md#rapport-au-code)). Une déduction présentée comme un fait n'a donc
personne pour l'intercepter. *(déduit — à valider)*
*Origine : session harnais du 2026-10-14.*

**Source inaccessible : le dire, ne jamais combler.**
Page web en erreur (403, 404), contenu payant, page ou fichier tronqué, document illisible :
l'écrire explicitement, en précisant ce qui manque. Ne jamais reconstituer le contenu
manquant « de mémoire » ou par vraisemblance.
**Comment ça se manifeste si on l'oublie** : une réponse fluide et sourcée en apparence,
dont une partie n'a jamais été lue. Rien à l'écran ne distingue le lu de l'inventé.
*(déduit — à valider)*
*Origine : session harnais du 2026-10-14.*

**Expliquer une erreur de l'agent par son mécanisme, pas par une image humaine.**
Pas d'« étourderie », de « distraction » ni de « j'avais la tête ailleurs ». Nommer la
cause réelle :
- une instruction ambiguë ;
- une information absente du contexte ou noyée dedans ;
- une règle lue mais mal généralisée ;
- une connaissance périmée.

**Pourquoi** : la cause réelle dit où corriger (une consigne à préciser, un fichier à faire
lire, une règle à ajouter au harnais). Une excuse « humaine » ne donne aucune prise et
laisse l'erreur se reproduire. C'est le principe « chaque gotcha porte sa cicatrice »,
appliqué à l'agent lui-même.
*Origine : session harnais du 2026-10-14.*

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
