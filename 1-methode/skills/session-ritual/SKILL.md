---
name: session-ritual
description: Rituel de début et de fin de session — gabarit du harnais, à adapter au projet
user_invocable: true
trigger: "début de session", "nouvelle session", "fin de session", "on arrête là", "clôture"
---

# Rituel de session — {{NOM_PROJET}}

> Gabarit issu du harnais. À l'installation : remplacer `{{NOM_PROJET}}`, les chemins de
> mémoire, la commande de vérification et les rappels conditionnels par ceux du projet.
> Supprimer les rappels qui ne s'appliquent pas — un rappel hors sujet apprend à l'agent
> que la checklist est décorative.

## Début de session

1. **Lire le contexte** dans cet ordre :
   - `AGENTS.md` (auto-chargé via le symlink `CLAUDE.md`) — règles impératives
   - `init.md` — briefing technique dense
   - L'index de mémoire (`harnais/memoire/MEMORY.md`) + le **rollup du module** qu'on va
     probablement toucher
2. **État git** : `git status` puis `git log --oneline -5`.
3. **Vérifier que les garde-fous sont armés** (une fois par machine, au premier démarrage
   sur ce poste) : `git config core.hooksPath` doit renvoyer `harnais/hooks`. Vide = le
   hook pre-push est présent mais inactif → le signaler.
4. **Saluer** avec un résumé ultra-court : dernier commit, TODOs en attente (repris des
   rollups), puis demander l'objectif du jour.
   - ⚠️ **Ne PAS** récapituler les statuts commit/push des sessions passées : `git log` est
     la source de vérité, le redire de mémoire produit des affirmations fausses.

## Fin de session

Déclencheurs : « fin de session », « on arrête là », « clôture ».

1. **Vérifier** : `{{COMMANDE_VERIF}}` doit passer (le hook pre-push le refera de toute
   façon — autant le savoir avant d'être bloqué).
2. **Mettre à jour la mémoire** :
   - Compléter le **rollup du module** concerné : état, gotchas, TODOs, + **une ligne**
     datée dans son historique.
   - **Ne pas créer de fichier `session_*.md`** — le rollup remplace le journal de session.
     Un détail long à conserver tel quel va dans `archive/`.
   - L'index reste à **une ligne par entrée**.
3. **Mettre à jour `init.md`** uniquement en cas de changement structurel : nouveau module
   ou route, convention modifiée, coordonnée technique changée, gotcha nouveau, module
   passé de « placeholder » à « livré ». Pas de journal de session dans `init.md`.
4. **Rappels conditionnels** — ne garder que ceux qui existent dans ce projet :
   - Règles de sécurité de la base de données touchées ? → elles doivent être **déployées**
     (déploiement séparé, jamais automatique) **et** commitées.
   - Nouvelle dépendance ? → vérifier qu'elle est passée par le gestionnaire attendu par
     l'hébergeur (lockfile à jour), sinon le build de prod casse.
   - {{AUTRES_SURFACES}} — extension, application mobile, tâche planifiée…
5. **Proposer le déploiement** (skill `deploiement`). **Ne jamais pousser sans accord
   explicite.**

## Pourquoi un rituel

Le début de session est le moment où un agent est le plus susceptible de partir sur une
compréhension périmée du projet, et le seul moment où une lecture systématique coûte peu.
La fin de session est le seul moment où le contexte est encore chaud pour écrire une
mémoire utile — dix minutes plus tard, elle est perdue.
