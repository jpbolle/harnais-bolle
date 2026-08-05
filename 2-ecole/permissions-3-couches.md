# Permissions — le modèle à trois couches

Dès qu'une application scolaire a des droits différenciés, l'autorisation existe à trois
endroits **indépendants**. Ils doivent rester cohérents, et ils divergent silencieusement.

| Couche | Où | Ce qu'elle fait |
|---|---|---|
| **1. Interface** | Composants (`usePermission`, `roles.includes`) | Montre ou masque l'action |
| **2. Route serveur** | API (SDK admin, **contourne les règles de la base**) | Autorise l'exécution |
| **3. Règles de la base** | Fichier de règles (SDK client uniquement) | Autorise la lecture/écriture directe |

**Invariant** : `rôles autorisés dans l'interface` ⊆ `rôles autorisés par la route` ⊆
`rôles autorisés par la règle`.

Un rôle exposé dans l'interface mais absent de la règle produit un refus au moment d'agir —
c'est-à-dire au pire moment, devant l'utilisateur.

## Diagnostiquer : trois symptômes distincts

Avant de corriger, **identifier la couche**. Les trois se ressemblent et ne se corrigent
pas au même endroit.

| Symptôme | Couche | Où corriger |
|---|---|---|
| `Missing or insufficient permissions` en console | 1 — règle de la base | Fichier de règles **+ déploiement** |
| **401 / 403** sur un appel `/api/...` (onglet réseau) | 2 — route serveur | La route |
| **Rien ne se passe, aucune erreur** | 3 — garde d'interface | Le composant / la matrice |

Deux réflexes qui font gagner des heures :
- Un **401 sur une route** ne vient jamais des règles de la base : les règles ne
  s'appliquent qu'au SDK client.
- « Rien ne se passe » peut aussi vouloir dire **l'écriture a réussi mais l'interface ne
  se rafraîchit pas**. Vérifier directement dans la base avant de conclure à un problème
  de droits (cas vécu : un ajout qui « ne marchait pas » était un simple bug d'affichage).

## Ne jamais coder de rôle en dur dans une route

Si les droits sont pilotés par une page d'administration, une route qui contient une liste
littérale de rôles rend cette page **sans effet** : on accorde un droit, il ne se passe
rien, et il n'y a aucun message d'erreur pour l'expliquer.

⇒ Toute route passe par un helper unique qui lit la matrice de droits depuis la base, avec
repli sur `admin`. Audit à relancer **à chaque ajout d'un nouveau rôle** :

```bash
grep -rn "AUTHORIZED_ROLES\s*=\|\.roles\.includes" src/app/api/
```

Chaque résultat est une route à migrer.

## Le piège des routes en cascade

**Un envoi de formulaire déclenche souvent plusieurs routes, pas une seule.** Exemple réel
d'une création d'élève :

1. la route principale (bloquante, dont l'erreur remonte à l'utilisateur) ;
2. création du dossier de stockage — appel **non bloquant** ;
3. création du compte utilisateur — chaîné au précédent ;
4. génération de documents, synchronisation de l'annuaire, notification par email…

**Trois pièges cumulés** :
- Corriger l'autorisation de la route principale ne dit **rien** des autres. Cas vécu : un
  rôle passait l'étape 1 et était bloqué en 403 sur les étapes 2 et 3, restées sur une
  liste de rôles littérale.
- Ces appels sont non bloquants et leurs erreurs sont avalées : l'utilisateur croit que
  tout a fonctionné.
- Une **notification métier** (email au secrétariat) vit souvent *à l'intérieur* d'une de
  ces routes : son échec supprime silencieusement un email attendu par un humain.

**Règles** :
- À chaque ajout d'une action qui déclenche des effets de bord, chercher tous les appels
  (`grep 'fetch("/api/'` autour du gestionnaire de soumission) et les lister.
- Toutes ces routes doivent autoriser la **même ressource logique** que la route
  principale.
- **Ne jamais laisser une erreur d'effet de bord silencieuse** : afficher un message
  explicite. Sinon personne ne saura jamais qu'une étape a échoué.

## Les représentations doivent rester synchrones

Un système de droits dynamique a typiquement trois représentations : la matrice éditée
dans l'interface, sa version dénormalisée lue par les règles et les routes, et les valeurs
par défaut dans le code. Éditer l'une à la main (via une console, un script) sans mettre
à jour l'autre produit un état qui **sera écrasé** au prochain enregistrement depuis
l'interface.

## Session périmée

Les droits sont généralement chargés côté client **à la connexion**. Après une
modification, l'utilisateur doit se **reconnecter** pour la voir. Avant de conclure à un
bug, comparer la date de dernière connexion à celle de la modification des droits.
