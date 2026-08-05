# Interview — remplir `profil.md` et `methode.md`

> Mode d'emploi pour l'agent : poser ces questions **par groupes de 3 ou 4**, jamais les
> vingt d'un coup. Écrire dans `profil.md` / `methode.md` **au fur et à mesure** (à la fin
> de chaque groupe), pas à la fin de l'interview — une interruption ne doit rien coûter.
>
> Reformuler les réponses en règles actionnables, pas en verbatim. Une phrase comme
> « ça m'agace quand tu détailles trop » doit devenir une consigne exécutable :
> « réponses courtes par défaut ; le détail seulement si demandé ».
>
> Durée visée : 10-15 minutes.

---

## Groupe A — Contexte (→ `profil.md`)

1. Quel est ton métier / ton rôle exact, et dans quel cadre ces applications sont-elles
   utilisées ?
2. Pour qui développes-tu : toi seul, ton établissement, d'autres écoles ? Y a-t-il des
   utilisateurs réels aujourd'hui, et combien ?
3. Développes-tu sur ton temps de travail, ton temps libre, les deux ? Par sessions
   longues ou par créneaux courts ?
4. Y a-t-il d'autres personnes qui touchent au code ou aux données (un collègue, un
   informaticien de l'école) ?

## Groupe B — Rapport au code (→ `profil.md`)

5. Comment décrirais-tu ton niveau technique : ce que tu sais lire, ce que tu sais écrire,
   ce sur quoi tu dépends entièrement de moi ?
6. Quand je te propose du code, qu'est-ce que tu veux voir : le résultat seulement, les
   fichiers touchés, le diff, l'explication du raisonnement ?
7. Y a-t-il des parties de tes projets que tu ne veux jamais me voir toucher sans te
   prévenir (données de prod, règles de sécurité, envois d'emails, migrations) ?
8. Sur quels outils travailles-tu (Claude Code, Cursor, autre) et sur combien de machines ?

## Groupe C — Rythme et validation (→ `methode.md`)

9. Préfères-tu que je fasse d'abord un plan à valider, ou que j'attaque directement et
   qu'on corrige ensuite ? Est-ce que ça dépend de la taille de la tâche — et si oui, où
   est la frontière ?
10. Qu'est-ce que je peux décider seul, sans te demander ?
11. Qu'est-ce que je ne dois **jamais** faire sans ton accord explicite ?
12. Quand je détecte un problème dans ce que tu me demandes, tu veux que je le signale et
    continue, ou que je m'arrête et attende ?

## Groupe D — Format des réponses (→ `methode.md`)

13. Mes réponses sont-elles en général trop longues, trop courtes, à peu près justes ?
14. Qu'est-ce qui te fait perdre du temps dans nos échanges ? (Sois précis : c'est la
    question la plus utile de l'interview.)
15. Tu veux des tableaux, des listes, du texte suivi ? Des emojis ou pas ?
16. Quand une tâche est finie, qu'attends-tu comme compte rendu : une phrase, un résumé
    structuré, la liste des fichiers touchés ?

## Groupe E — Projets et horizon (→ `profil.md`)

17. Quels projets as-tu en cours ou en tête pour les prochains mois ?
18. Y a-t-il des choses que tu as abandonnées ou ratées avec un agent IA, et que tu
    aimerais éviter de revivre ?
19. Sur quoi juges-tu qu'une session a été réussie ?

---

## Après l'interview

- Relire `profil.md` et `methode.md` **à voix haute avec l'utilisateur** — c'est là que
  sortent les corrections importantes.
- Retirer la mention `<!-- NON REMPLI -->` en tête de chaque fichier.
- Reporter dans `consignes.md` toute règle exprimée en négatif (« ne fais jamais… »).
- Proposer de recopier l'ensemble dans `~/.claude/CLAUDE.md` (cf. [`README.md`](README.md)).
- Bumper `VERSION` en mineur et commiter.
