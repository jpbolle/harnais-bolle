<!--
GABARIT — AGENTS.md (couche 1 : règles impératives)
Né du harnais version {{VERSION_HARNAIS}}.

RÈGLES DE REMPLISSAGE
1. Remplacer tous les {{PLACEHOLDERS}}.
2. SUPPRIMER toute section qui ne s'applique pas au projet. C'est plus important que de
   remplir les autres : une règle hors sujet apprend à l'agent que ce fichier est
   approximatif, et il traitera les vraies règles avec la même désinvolture.
3. N'ajouter une règle ici que si sa violation casse quelque chose de réel (production,
   données, conformité). Tout le reste va dans init.md.
4. Supprimer ce commentaire une fois le remplissage terminé.
-->

# {{NOM_PROJET}} — Instructions pour les agents IA

> **Source unique des règles impératives du projet.**
> Lu par Cursor (nativement) et par Claude Code (via le symlink `CLAUDE.md` → `AGENTS.md`).
> Carte complète du harnais : [`harnais/README.md`](./harnais/README.md).

## Démarrage de session

Lire `init.md` à la racine : briefing dense — coordonnées techniques, conventions, modèle
de permissions, gotchas, état des modules.

L'**état cross-sessions** (ce qui a changé, TODOs, décisions récentes) vit dans
`harnais/memoire/` — pas dans `init.md`.

Profil de l'utilisateur et consignes durables : dépôt `harnais` (`0-moi/`).

<!-- ─────────────────────────────────────────────────────────────────────────────
     SECTION VÉRIFICATION — garder uniquement si le projet a un déploiement
     automatique et/ou des garde-fous installés (taille L).
     ───────────────────────────────────────────────────────────────────────────── -->
## Vérification avant commit / push (IMPORTANT)

`git push {{BRANCHE}}` = **déploiement en production immédiat** ({{HEBERGEUR}}){{PORTEE_REELLE}}.

- Avant tout commit substantiel : `{{COMMANDE_VERIF}}` doit passer.
- Un hook git `pre-push` (`harnais/hooks/`, activé par
  `git config core.hooksPath harnais/hooks`) bloque le push si la vérification échoue.
  **Ne jamais le contourner** (`--no-verify`) sans accord explicite de l'utilisateur.
- La CI ({{FICHIER_CI}}) revérifie après push sur machine neutre.
- {{ETAT_DES_TESTS}} — d'où le caractère non négociable de la vérification ci-dessus.
- **Ne jamais pousser sans accord explicite de l'utilisateur.**

<!-- ─────────────────────────────────────────────────────────────────────────────
     SECTION DONNÉES PERSONNELLES — garder si le projet stocke des données
     personnelles. Source : 2-ecole/rgpd-chiffrement.md
     ───────────────────────────────────────────────────────────────────────────── -->
## Chiffrement des données sensibles (RGPD)

Toute fonctionnalité qui stocke une donnée personnelle ou sensible (identité, adresse,
contacts, santé…) DOIT passer par le chiffrement applicatif :

- **Écriture** : via une route serveur qui chiffre avant l'enregistrement.
- **Lecture** : via une route serveur qui déchiffre avant l'envoi au client.
- **Jamais de donnée sensible en clair**, sauf champ utilisé dans un filtre — auquel cas
  l'exception doit être **écrite et justifiée**.
- Champs volontairement laissés en clair sur ce projet : {{CHAMPS_EN_CLAIR}}.

<!-- ─────────────────────────────────────────────────────────────────────────────
     SECTION RÈGLES DE BASE DE DONNÉES — garder si des règles de sécurité se
     déploient séparément du code. Source : 2-ecole/stack-firebase-next.md
     ───────────────────────────────────────────────────────────────────────────── -->
## Règles de sécurité — procédure IMPÉRATIVE

`{{FICHIER_REGLES}}` est maintenu **à la main** et **découplé du code**. Toute collection
accédée **côté client** doit avoir sa règle, sinon elle est refusée par défaut.

**Les deux déploiements sont indépendants** :
- `git push` → déploie l'application, automatiquement.
- `{{COMMANDE_DEPLOIEMENT_REGLES}}` → déploie les règles, **manuellement, jamais
  automatiquement**.

À chaque modification de règle ou ajout d'une collection lue/écrite côté client :
1. mettre à jour le fichier de règles ;
2. valider la syntaxe ;
3. **déployer** ;
4. vérifier dans l'application ;
5. **commiter** le fichier.

Une modification de règle n'est jamais terminée tant qu'elle n'est pas **déployée ET
commitée**.

**Concordance interface ↔ route ↔ règle** : tout rôle auquel l'interface expose une action
doit être autorisé par la route serveur **et** par la règle. Un rôle exposé mais non
autorisé = refus au moment d'agir.

<!-- ─────────────────────────────────────────────────────────────────────────────
     SECTION DÉPENDANCES — garder si l'hébergeur impose un gestionnaire de paquets.
     ───────────────────────────────────────────────────────────────────────────── -->
## Dépendances

{{HEBERGEUR}} exécute `{{COMMANDE_INSTALL_PROD}}` sur `{{LOCKFILE}}`. Une dépendance
ajoutée avec un autre gestionnaire ne met pas ce fichier à jour → **build de production
cassé** alors que tout fonctionne en local.
⇒ Toujours `{{COMMANDE_INSTALL}}`{{RESYNC}}.

<!-- ─────────────────────────────────────────────────────────────────────────────
     SECTION GOTCHAS — les pièges propres à CE projet. Un gotcha n'entre ici que
     s'il a un symptôme observable ET qu'il coûte cher. Les autres vont dans init.md.
     ───────────────────────────────────────────────────────────────────────────── -->
## Gotchas critiques

### {{TITRE_GOTCHA}}
{{DESCRIPTION}}

**Symptôme** : {{SYMPTOME_OBSERVABLE}}
**Règle** : {{REGLE}}

<!-- ───────────────────────────────────────────────────────────────────────────── -->
## Mise à jour de `init.md`

`init.md` est un briefing **stable**. Il ne change que si :
- un nouveau module apparaît (route, hub, vue) ;
- une convention change ;
- une coordonnée technique change (variable d'environnement, région, identifiant projet) ;
- un gotcha opérationnel nouveau est découvert ;
- l'état d'un module passe de « placeholder » à « livré » ou l'inverse.

Il ne contient **pas** le journal session par session (qui vit dans `harnais/memoire/`).

## Conventions

- **Code** (variables, fonctions, composants, fichiers) : anglais
- **Interface utilisateur** : français
- **Commentaires** : français
- **Commits** : anglais, format conventionnel (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`)
- **Affichage des personnes** : `Nom Prénom`
- **Numéro de version** : géré manuellement par l'utilisateur — ne **jamais**
  l'incrémenter automatiquement
- {{CONVENTIONS_SPECIFIQUES}}
