# Google Workspace for Education — intégration

La plupart des écoles FWB sont sous Google Workspace. L'application peut s'y adosser plutôt
que de redévelopper comptes, stockage et messagerie.

## Délégation à l'échelle du domaine (DWD)

Un compte de service peut **agir au nom** d'un utilisateur du domaine (impersonation), à
condition que l'administrateur Workspace ait autorisé explicitement chaque périmètre.

Périmètres typiquement nécessaires :

| Périmètre | Pour quoi |
|---|---|
| `admin.directory.user` | Créer / modifier les comptes élèves et personnel |
| `admin.directory.group`, `.member` | Gérer les groupes (listes de diffusion, classes) |
| `drive` | Créer les dossiers d'élèves, y déposer des documents |
| `documents`, `spreadsheets` | Générer des documents et des exports |
| `gmail.send` | Envoyer des emails depuis une adresse de l'école |
| `calendar` | Poser des événements |

**À savoir avant de commencer** :
- L'autorisation des périmètres est un acte de l'**administrateur Workspace** — une
  personne, pas une API. Prévoir le délai.
- Ajouter un périmètre après coup nécessite de repasser par lui. Réfléchir la liste au
  départ.
- L'impersonation se fait au nom d'un compte **super-administrateur** pour les opérations
  d'annuaire : c'est un secret à traiter comme tel.

## Envoi d'emails — une adresse par thème

Les emails d'une application scolaire partent d'adresses différentes selon le sujet :
inscriptions depuis l'accueil, suivi pédagogique depuis la cellule concernée, etc. Un
parent doit pouvoir répondre à un humain pertinent.

**Règle** : centraliser les adresses d'expédition dans **un seul fichier de constantes**,
avec un repli global. Toute nouvelle route qui envoie un email thématique y passe, au lieu
de retomber sur l'adresse par défaut — sinon les réponses des parents arrivent au mauvais
endroit, et personne ne s'en aperçoit avant une plainte.

Prévoir aussi de rendre les **modèles d'emails éditables depuis la base**, pas dans le
code : ce sont les secrétariats qui veulent en changer le texte, et ils ne feront pas de
`git commit`.

## Stockage

Utiliser Drive plutôt que le stockage de l'hébergeur applicatif présente un avantage
décisif : **les documents restent accessibles et gérables par le personnel** avec les
outils qu'il connaît, y compris si l'application disparaît.

Points d'attention :
- Un dossier par élève, dans une arborescence par année ; conserver l'identifiant du
  dossier sur la fiche.
- Les images ne peuvent pas être affichées directement depuis Drive dans une page web
  (authentification) : prévoir une **route de proxy** côté serveur.
- **Supprimer une fiche ne supprime pas son dossier Drive** — voir les orphelins dans
  [`donnees-eleves.md`](donnees-eleves.md).
- Les Drive partagés ont des règles de permissions différentes des Drive personnels.

## Synchronisation de l'annuaire

Créer un compte élève, c'est aussi le ranger dans la bonne **unité organisationnelle**
(souvent par année de rentrée). Ces unités structurent les politiques appliquées par
l'école (filtrage, applications autorisées) : s'y tromper a des effets visibles pour
l'élève.

⚠️ **Un indicateur « compte créé » stocké dans la base est peu fiable.** Il peut être faux
alors que le compte existe réellement (créé à la main hors application, ou indicateur
jamais mis à jour). **Ne jamais conditionner une opération sur cet indicateur** : laisser
l'API Google répondre « compte introuvable » le cas échéant. Symptôme sinon : impossible
de mettre à jour un compte qui existe pourtant, sans explication.
