# RGPD et chiffrement applicatif

Une application scolaire traite des données personnelles de **mineurs** : identité,
registre national, adresse, contacts, santé, suivi social. C'est la catégorie la plus
exposée du règlement.

## Le principe

Le chiffrement au repos fourni par l'hébergeur ne protège **pas** contre un accès à la
console d'administration de la base. Un chiffrement **applicatif** (la donnée est chiffrée
par le code avant d'être écrite) protège, lui, contre la lecture directe de la base.

Schéma retenu : **AES-256-GCM**, clé de 64 caractères hexadécimaux en variable
d'environnement, format stocké `iv:tag:données` en hexadécimal.

## L'architecture, en deux règles

- **Écriture** : passer par une route **serveur** qui chiffre avant d'écrire.
- **Lecture** : passer par une route **serveur** qui déchiffre avant de renvoyer au client.

Le client ne voit jamais ni la clé ni la donnée chiffrée. Concrètement, cela signifie que
**tout champ sensible interdit l'accès direct depuis le navigateur** — c'est une contrainte
d'architecture, pas un détail d'implémentation, et elle se décide au moment de créer le
champ, pas après.

## L'exception à documenter

Un champ utilisé dans une **clause de filtrage** (`where`) ne peut pas être chiffré : la
base compare des valeurs chiffrées, la requête ne renvoie rien.

⇒ Ces champs restent en clair, et **la liste doit être explicite et justifiée**. Cas
typiques : les adresses email des responsables (utilisées pour retrouver les enfants d'un
parent à la connexion), les identifiants techniques.

⚠️ **Piège** : les nom et prénom de l'élève sont souvent laissés en clair eux aussi, parce
que l'interface les affiche partout et que passer par une route de déchiffrement pour
chaque liste serait rédhibitoire. C'est un arbitrage défendable, mais il doit être
**écrit** : sans ça, un script de création de fiche chiffrera ces champs « pour bien
faire », et toutes les listes afficheront du charabia sans qu'aucune erreur ne soit levée.

**Règle** : maintenir une constante unique listant les champs sensibles, et s'y référer —
jamais de décision au cas par cas dans le code.

## Checklist à chaque nouveau champ

1. Contient-il une donnée personnelle ou sensible ? Si oui → chiffrement obligatoire.
2. Est-il utilisé dans un filtre ? Si oui → il reste en clair, et on **écrit pourquoi**.
3. L'ajouter à la constante des champs sensibles.
4. Vérifier que **toutes** les voies d'écriture passent par le serveur — y compris les
   imports, les synchronisations et les scripts ponctuels.

## Reste à faire (dette classique)

Le chiffrement est la partie technique. Le RGPD **documentaire** est un chantier distinct,
qu'on repousse toujours et qui doit être fait avant une mise en service élargie :

- registre des traitements,
- analyse d'impact (AIPD/DPIA) — obligatoire pour un traitement à grande échelle de
  données de mineurs,
- information des personnes et exercice des droits (accès, rectification, effacement),
- durées de conservation et purge,
- sous-traitants et transferts hors UE,
- procédure en cas de violation de données.

Point d'attention : héberger les données **en Union européenne** (choisir explicitement la
région à la création de la base — c'est **irréversible** ensuite, et c'est l'un des rares
choix d'infrastructure qu'on ne peut pas corriger après coup).
