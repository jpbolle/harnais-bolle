# Profil — qui je suis

> Ce fichier décrit l'utilisateur. Un agent le lit au début de chaque session, sur
> n'importe quel projet. **Ne rien y écrire qui n'ait pas été déclaré explicitement** :
> marquer `(déduit — à valider)` tout le reste.

## Identité et contexte

- **Nom** : Jean-Philippe Bolle (`jeanphilippe.bolle@cnddinant.be`)
- **Établissement** : Collège Notre-Dame de Dinant — secondaire, Fédération
  Wallonie-Bruxelles, Belgique. Trois implantations : Bellevue, Place Albert, Saint-Roch.
- **Trois rôles**, dans cet ordre de portée :
  1. **Formateur IA** (dépasse le cadre du Collège) — forme au *vibe coding* et à la
     création d'applications scolaires. Les apps servent aussi de matériel de formation.
  2. **Professeur de français** au Collège NDD — crée des applications pédagogiques
     (`daspalecte`, `recto-versia`, … dans `~/Documents`).
  3. **Référent numérique** du Collège — automatisation de l'école et application de
     gestion scolaire.
- **Public des applications** : des profs, des élèves, et l'école elle-même. Le Collège
  compte **1300 à 1400 membres** (élèves + personnel) — c'est l'ordre de grandeur du
  périmètre, pas un nombre d'utilisateurs actifs mesuré.
- **Parc matériel de l'école** : **chaque élève a un Chromebook**. ⇒ Contrainte de
  conception permanente : ce qui est destiné aux élèves doit tourner **dans le navigateur,
  sous ChromeOS** — pas d'installation native, écrans et claviers d'entrée de gamme.
- **Rythme de travail** : sur temps libre — **le soir et le week-end**.
- **Autres personnes impliquées** : **Sébastien Dedocq**, référent numérique au Collège
  comme moi, collaborateur sur certaines applications. (C'est le « Seb » de l'indicateur
  « mode travail JP / Seb » dans KitSchool.)

## Rapport au code

- **Niveau technique** : je **ne sais pas écrire** de code au-delà de quelques lignes, mais
  je sais le **parcourir et le lire**. Parcours : modules complémentaires en Google Apps
  Script (découverte de la structure HTML/CSS/JS) → frameworks, API, bases de données.
  J'ai vibecodé des **extensions, des modules complémentaires et des apps full stack**.
  Je suis autonome sur le terminal et sur la console de développement du navigateur
  (lecture des logs).
  ⇒ Conséquence pour l'agent : **ne jamais supposer que je vérifierai le code moi-même.**
  Expliquer en français ce que fait le code compte plus que la beauté du code.
- **Ce que je veux voir quand tu codes** :
  - les **fichiers touchés** ;
  - une **explication** de ce que tu vas faire / de ce que tu as fait ;
  - les **options stratégiques** quand il y en a (pas seulement ta conclusion).
  - Le diff ligne à ligne n'est pas nécessaire.
  ⇒ Pour les actions que **je** dois exécuter, voir la règle des étapes progressives dans
  [`methode.md`](methode.md#format-des-réponses) — c'est une règle dure.
- **Zones sensibles** : voir « Jamais sans accord explicite » dans
  [`methode.md`](methode.md#jamais-sans-accord-explicite). En résumé : **c'est moi qui
  pousse sur GitHub**, et **aucun envoi d'email** sans mon assentiment.
- **Outils** : Claude Code (dans VS Code), Cursor, Antigravity. Les projets portent un
  `AGENTS.md` lu par Cursor et un symlink `CLAUDE.md`.
- **Machines** : **deux postes** — un MacBook Pro et un Mac Studio. (D'où l'importance de
  garder la mémoire dans le dépôt du projet, cf. [`../1-methode/memoire.md`](../1-methode/memoire.md).)
- **Infrastructure personnelle** :
  - **Base de données** : Firebase pour l'essentiel aujourd'hui ; Supabase utilisé par le
    passé, moins maintenant.
  - **Nom de domaine** : `pedagokit.be`, chez **OVH**.
  - **Hébergement** : **VPS Hostinger**, qui accueille ~70 % des projets.

## Projets

| Projet | Objet | État |
|---|---|---|
| **KitSchool** | Gestion scolaire du Collège NDD : élèves, résultats, journal de classe, horaires, PIA, options, ateliers, extension Chrome | **Gros chantier prioritaire**, en production, données réelles |
| **recto-versia** | Outil d'écriture et de lecture pour le cours de français : suivi des compétences de **littératie** des élèves | Projet actif |
| `pedagokitApp`, `daspalecte`, `Sambre-romantique`, `simulationHTML`, `profilIA` | — | « Évolueront gentiment » : pas de chantier en cours |

## Ce que je veux éviter de revivre

**Rien de déclaré** — pas d'échec marquant avec un agent IA à ce jour (question E18,
2026-08-05). À enrichir si un incident survient.

## Ce qui fait une bonne session

Deux critères, dans cet ordre :

1. **L'efficacité** — on a avancé, sans tourner en rond.
2. **Le rendu de l'app** — le résultat visible à l'écran, pas la propreté du code.

⇒ Conséquence pour l'agent : une session qui produit du code correct mais rien de visible
n'est pas une bonne session. Faire voir le résultat.
