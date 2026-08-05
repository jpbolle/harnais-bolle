# Rôles et résolution d'identité

## La grille de rôles d'un établissement

Point de départ éprouvé, à ajuster par établissement :

`admin`, `direction`, `secrétariat`, `professeur`, `éducateur`, `membre du personnel`,
`stagiaire`, plus les **cellules** transversales (cellule pédagogique, PMS, aménagements
raisonnables, remédiation, ateliers…), plus les rôles **dérivés de l'authentification** :
`élève` et `parent`.

### Trois principes

**1. Le titulariat n'est pas un rôle.**
Un titulaire est un professeur portant un **attribut** « classe dont il est titulaire ».
En faire un rôle produit immédiatement des incohérences : un titulaire est aussi
professeur, et il perd le titulariat en changeant d'attribution — sans devoir changer de
rôle. Même raisonnement pour « coordinateur » ou « chef d'atelier ».

**2. Certains rôles n'ont pas de repli administrateur.**
La plupart des rôles tolèrent un fallback `admin` (l'administrateur voit tout). Ce n'est
**pas** acceptable pour les rôles qui donnent accès à des données sensibles restreintes à
quelques personnes nommées : santé, aménagements raisonnables, suivi social. Ces rôles
doivent être **stricts**, sans exception admin, et il faut le documenter explicitement —
sinon quelqu'un rétablira le fallback en croyant corriger un bug.

**3. Les rôles se cumulent.**
Un professeur peut être parent d'élève dans le même établissement. La résolution d'identité
doit **additionner** les casquettes, jamais s'arrêter à la première trouvée. C'est le
piège n°1 de ce domaine : un professeur-parent qui ne voit pas ses enfants, ou un parent
qui obtient par erreur des droits de professeur.

## Résolution d'identité — la cascade

À la connexion, on cherche qui est cette adresse email, **dans cet ordre**, en cumulant :

1. Personnel (collection du staff) → rôles déclarés
2. Élève (champ email de l'élève) → rôle `élève`
3. Responsable légal 1 d'un ou plusieurs élèves → rôle `parent`
4. Responsable légal 2 d'un ou plusieurs élèves → rôle `parent`

Une adresse peut satisfaire plusieurs étapes : on garde **l'union** des rôles.

### Où lire les rôles — règle absolue

Une fois la résolution faite, écrire les rôles dans un document **indexé par l'identifiant
d'authentification** (`users/{uid}`), et faire de ce document la **source unique** lue par
les règles de sécurité et les routes serveur.

⚠️ **Ne jamais résoudre les rôles en cherchant le document du personnel par son email**
(`staff.doc(email)`). L'identifiant d'un document de personnel n'est **pas** garanti égal à
l'adresse email du compte : une personne peut avoir un document créé sous une ancienne
adresse, ou une adresse de service. Symptôme observé : erreur 401 sur une route serveur
pour un utilisateur parfaitement valide, impossible à reproduire pour les autres comptes.

Deux méthodes fiables : requête `where("email", "==", emailEnMinuscules")`, ou — mieux —
lecture directe de `users/{uid}`.

### Cas « aucun rôle »

La cascade peut ne rien trouver (adresse personnelle inconnue, parent pas encore encodé).
Prévoir un écran « accès non reconnu » explicite, avec un **contact direct** (lien mailto
vers le secrétariat). Sans ça, l'utilisateur voit une page vide et appelle l'école.

## Authentification — deux publics, deux mécanismes

| Public | Mécanisme | Pourquoi |
|---|---|---|
| Personnel, élèves | OAuth Google (compte de l'établissement) | Comptes Workspace existants, sécurité gérée par l'école |
| Parents | Lien magique par email (passwordless) | Aucun compte à créer ni mot de passe à gérer pour des centaines de familles |

Points d'attention sur le lien magique :
- Compléter la connexion automatiquement au montage de l'application (détection du lien
  entrant dans l'URL).
- L'adresse est stockée localement entre l'envoi et le retour ; prévoir le cas où le lien
  est ouvert **sur un autre appareil** (le stockage local est vide) : redemander l'adresse
  plutôt que d'échouer.

## Conventions d'affichage

- **Toujours `Nom Prénom`** (et non l'inverse) : c'est la convention administrative
  scolaire, et les listes se trient correctement.
- **Tutoiement des élèves**, **vouvoiement des parents**. Un composant partagé entre les
  deux vues prend une propriété `audience: "eleve" | "parent"` et adapte les textes. Côté
  personnel : tutoiement collégial.
