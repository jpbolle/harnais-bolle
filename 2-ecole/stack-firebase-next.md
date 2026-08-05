# Stack Next.js + Firebase — gotchas

Pièges de la stack elle-même, indépendants du domaine scolaire. Tous ont été rencontrés
en production.

## Les règles de sécurité sont découplées du code

**C'est le piège le plus coûteux de cette stack.**

- `git push` déploie l'**application**, automatiquement.
- `firebase deploy --only firestore:rules` déploie les **règles**, **manuellement**.

⇒ Livrer du code qui utilise une nouvelle collection **sans redéployer les règles** donne
un refus de permission en production, alors que tout fonctionne en local (l'émulateur ou
un déploiement plus ancien masque le problème).

De plus, un fichier de règles se termine par un refus global :

```
match /{document=**} { allow read, write: if false; }
```

⇒ **Toute collection sans règle explicite est refusée par défaut**, y compris pour un
administrateur. Symptôme : `Missing or insufficient permissions`.

**Procédure obligatoire, à chaque ajout de collection lue ou écrite côté client** :
1. écrire la règle ;
2. valider la syntaxe ;
3. **déployer** ;
4. vérifier dans l'application ;
5. **commiter** le fichier — il doit toujours refléter ce qui est réellement déployé.

Une modification de règle n'est jamais « terminée » tant qu'elle n'est pas **déployée ET
commitée**.

**Audit** — détecter une collection utilisée côté client sans règle :

```bash
grep -oE "match /[a-zA-Z0-9_]+" firestore.rules | sed 's#match /##' | sort -u > /tmp/regles.txt
grep -rhE "(collection|collectionGroup|doc)\(db" src | grep -v "/api/" \
  | grep -oE '"[a-zA-Z][a-zA-Z0-9_]*"' | tr -d '"' | sort -u > /tmp/client.txt
comm -23 /tmp/client.txt /tmp/regles.txt
```

⚠️ Ce grep rate les **sous-collections imbriquées** : les vérifier à la main. Filtrer aussi
le bruit (noms de champs, valeurs de filtres).

## Client ou serveur : deux régimes d'autorisation

- Les **routes serveur** utilisent le SDK admin et **contournent les règles**. Une
  collection écrite uniquement par route n'a pas besoin de règle d'écriture permissive.
- Les **composants client** sont soumis aux règles. Toute lecture ou écriture directe
  depuis le navigateur a besoin de sa règle.

Confondre les deux fait chercher un bug de permission du mauvais côté pendant des heures.

## Le SDK admin refuse `undefined`

Toute écriture contenant un champ à `undefined` est rejetée
(`Cannot use "undefined" as a Firestore value`). Lors d'une fusion partielle, il faut
**omettre les clés** concernées, pas les inclure avec une valeur `undefined`.

L'option globale `ignoreUndefinedProperties` existe mais est à éviter : elle masque de
vrais bugs (un champ mal orthographié devient un silence au lieu d'une erreur).

## Lockfile et build de production

L'hébergeur exécute typiquement `npm ci`, qui s'appuie **strictement** sur
`package-lock.json`. Une dépendance ajoutée avec un autre gestionnaire de paquets ne met
pas ce fichier à jour → le build de production échoue alors que tout fonctionne en local.

⇒ **Toujours installer avec le gestionnaire attendu par l'hébergeur**, puis
resynchroniser l'autre si le projet en utilise deux.

## Tailwind 4 et classes dynamiques

Certaines classes de couleur ne sont pas compilées de manière fiable si elles ne sont pas
présentes littéralement dans le code source (composition dynamique, valeurs calculées).

⇒ Pour les couleurs **critiques** (alerte, statut), utiliser un style en ligne plutôt
qu'une classe. Symptôme sinon : l'élément s'affiche sans couleur, sans aucune erreur.

## Scripts d'administration ponctuels

Pour un diagnostic ou une réparation en base, le patron qui fonctionne :

- placer le script dans le dossier `scripts/` du projet (pour la résolution des modules) ;
- l'exécuter avec le fichier d'environnement du projet ;
- initialiser le SDK admin avec les identifiants du compte de service, en pensant à
  restaurer les retours à la ligne de la clé privée (`replace(/\\n/g, "\n")`) ;
- pour lire des champs chiffrés, réutiliser la fonction de déchiffrement de l'application
  plutôt que de la réécrire ;
- **supprimer le script après usage** — un script de réparation ponctuel laissé dans le
  dépôt finit par être relancé par erreur.

## Divers

- **Initialisation paresseuse du SDK client** (`getAuth()` / `getDb()` appelés à l'usage
  plutôt qu'au chargement du module) : sans ça, le build échoue quand les variables
  d'environnement sont absentes, ce qui est le cas en CI.
- **Politique COOP** : autoriser `same-origin-allow-popups` si l'authentification passe
  par une fenêtre surgissante.
- **iCloud Drive** : un dépôt situé dans un dossier synchronisé iCloud provoque des échecs
  de lecture intermittents (`EPERM`) et des conflits sur le dossier de build. Deux
  correctifs : sortir le dossier de build hors du dossier synchronisé, et — mieux — ne pas
  mettre de dépôt Git dans iCloud.
