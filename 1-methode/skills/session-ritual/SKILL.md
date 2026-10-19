---
name: session-ritual
description: Rituel de début et de fin de session — gabarit du harnais, à adapter au projet
user_invocable: true
trigger: "début de session", "nouvelle session", "note ça", "mémorise ça", "vérifie le harnais", "fin de session", "on arrête là", "clôture"
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
4. **Faire le point**, sur un seul écran, dans ce format fixe :
   ```markdown
   ## Où on en était
   <deux ou trois lignes tirées du rollup, avec la date de sa dernière entrée>
   ## Ce qui attend
   - <TODO du rollup> : <ce qui le bloque, tel que le fichier le dit>
   ## Par quoi commencer
   1. <proposition> : <la raison, en quelques mots>
   ```
   - **Trois propositions au plus**, chacune appuyée sur **une ligne qu'on peut citer**
     (rollup, roadmap, `git status`). Pas de tâche, d'échéance ni de priorité inventée.
   - **Si la mémoire est vide ou ancienne, le dire en premier** : comparer la date de la
     dernière entrée du rollup au dernier commit. Un écart de semaines = mémoire orpheline
     ou non tenue (cf. `memoire.md`, pièges) ; le point ne vaut que ce que vaut la mémoire.
   - Puis **demander par quoi on commence, et s'arrêter là** : ne lancer aucune des
     propositions de sa propre initiative.
   - ⚠️ **Ne PAS** récapituler les statuts commit/push des sessions passées : `git log` est
     la source de vérité, le redire de mémoire produit des affirmations fausses.

## En cours de session : « note ça »

Déclencheurs : « note ça », « mémorise ça », « garde une trace de ça ».

Mettre à jour **tout de suite** le rollup du module concerné (état, gotcha ou TODO, plus une
ligne datée en haut de son historique), sans attendre la clôture. La date vient de
`date +%F`. Une session longue perd ses détails en route : c'est juste après une production
que la mémoire s'écrit le mieux. Ne pas le faire de sa propre initiative à chaque
production — seulement sur demande, ou à la clôture.

## Fin de session

Déclencheurs : « fin de session », « on arrête là », « clôture ».

1. **Vérifier** : `{{COMMANDE_VERIF}}` doit passer (le hook pre-push le refera de toute
   façon — autant le savoir avant d'être bloqué). Taille L : lancer aussi
   `harnais/hooks/lint-harnais.sh` (forme des fichiers du harnais) — aussi sur « vérifie le
   harnais », à tout moment. Tant qu'il n'a pas dit « Tout est OK », ne pas annoncer un
   harnais en ordre.
2. **Résumer la séance en trois lignes au plus** — ce qui a été produit, modifié ou décidé,
   et où — et **laisser l'utilisateur corriger avant d'écrire quoi que ce soit**. La mémoire
   s'écrit à partir d'un résumé validé, pas de l'impression de l'agent.
3. **Mettre à jour la mémoire** :
   - Compléter le **rollup du module** concerné : état, gotchas, TODOs, + **une ligne**
     datée **en haut** de son historique (date : `date +%F`).
   - **Ne pas créer de fichier `session_*.md`** — le rollup remplace le journal de session.
     Un détail long à conserver tel quel va dans `archive/`.
   - L'index reste à **une ligne par entrée**.
4. **Une règle nouvelle a-t-elle été exprimée aujourd'hui ?** (« ne fais plus jamais… »,
   « toujours… »). Si oui, **proposer où elle va**, sans l'écrire d'office : `AGENTS.md` du
   projet si elle ne vaut qu'ici, `0-moi/consignes.md` du dépôt `harnais` si elle vaut
   partout. Une règle laissée dans la conversation meurt avec elle.
5. **Mettre à jour `init.md`** uniquement en cas de changement structurel : nouveau module
   ou route, convention modifiée, coordonnée technique changée, gotcha nouveau, module
   passé de « placeholder » à « livré ». Pas de journal de session dans `init.md`.
   - **Question à se poser une fois par session** : ai-je écrit aujourd'hui du code de la
     même forme qu'une fois déjà ? Si oui → **proposer** de l'inscrire dans §2 « Patterns
     imposés », avec le chemin du fichier à recopier. C'est le seul moment où on s'en
     souvient : demain, cette répétition sera invisible.
6. **Rappels conditionnels** — ne garder que ceux qui existent dans ce projet :
   - Règles de sécurité de la base de données touchées ? → elles doivent être **déployées**
     (déploiement séparé, jamais automatique) **et** commitées.
   - Nouvelle dépendance ? → vérifier qu'elle est passée par le gestionnaire attendu par
     l'hébergeur (lockfile à jour), sinon le build de prod casse.
   - Un export, un fichier de données réelles (élèves, notes, coordonnées) ou une clé
     a-t-il été créé pendant la séance ? → il ne doit pas être suivi par git (`git status`
     le montre ; le hook refuse les clés, pas les données : c'est l'œil qui veille).
   - {{AUTRES_SURFACES}} — extension, application mobile, tâche planifiée…
7. **Proposer le déploiement** (skill `deploiement`). **Ne jamais pousser sans accord
   explicite.** Avant : **proposer un changement de version — ou pas** (gros changement →
   `3.X` → `3.Y` ; mineur → `3.1.1` → `3.1.2`) ; l'utilisateur tranche
   (cf. `0-moi/consignes.md` § Versions).

*Précisions du 2026-10-19 (format du point, mémoire ancienne, résumé validé avant écriture,
règle nouvelle), reprises des skills `daily` et `wrapup` d'un collègue ; son commit
automatique en clôture a été écarté : le commit, c'est l'utilisateur.*

## Pourquoi un rituel

Le début de session est le moment où un agent est le plus susceptible de partir sur une
compréhension périmée du projet, et le seul moment où une lecture systématique coûte peu.
La fin de session est le seul moment où le contexte est encore chaud pour écrire une
mémoire utile — dix minutes plus tard, elle est perdue.
