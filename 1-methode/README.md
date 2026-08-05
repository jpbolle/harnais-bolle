# 1-methode — le squelette agnostique

Ce qui vaut pour **n'importe quelle application**, scolaire ou non. C'est la forme du
harnais : où l'information vit, comment une session commence et finit, ce qui empêche
mécaniquement de casser la prod.

## Contenu

| Fichier | Rôle | Taille minimale |
|---|---|---|
| [`les-5-couches.md`](les-5-couches.md) | Le modèle : où vit quelle information et pourquoi | S |
| [`memoire.md`](memoire.md) | La mémoire cross-sessions : structure, emplacement, pièges | S |
| [`garde-fous.md`](garde-fous.md) | Les vérifications qui ne dépendent pas de la bonne volonté de l'agent | L |
| [`skills/session-ritual/`](skills/session-ritual/SKILL.md) | Rituel de début et de fin de session | M |
| [`skills/deploiement/`](skills/deploiement/SKILL.md) | Le patron « N surfaces indépendantes » | M |
| [`hooks/pre-push`](hooks/pre-push) | Hook git bloquant sur la compilation | L |
| [`ci/ci-node-ts.yml`](ci/ci-node-ts.yml) | GitHub Actions : re-vérification sur machine neutre | L |
| [`settings.json.example`](settings.json.example) | Allowlist de permissions Claude Code | M |

## Comment s'en servir

Ces fichiers ne se copient pas tels quels dans un projet : ils sont **la source** dans
laquelle le skill [`/nouveau-projet`](../skills/nouveau-projet/SKILL.md) pioche pour
rédiger l'`AGENTS.md` et l'`init.md` du projet.

Les seuls fichiers qui se copient littéralement sont les exécutables : `hooks/pre-push`,
`ci/ci-node-ts.yml`, `settings.json.example`, et les deux `SKILL.md` (à adapter aux noms
et commandes réels du projet).

## Le principe qui tient tout

**Une information vit à un seul endroit, choisi selon sa fréquence de changement.**

Une règle qui ne bouge jamais et une actualité de session n'ont pas le même foyer. Les
mélanger produit soit un fichier de règles pollué d'actualité périmée, soit une mémoire
qui répète des règles — et dans les deux cas, deux copies qui divergent. La duplication
est l'ennemi principal d'un harnais : c'est elle, pas le manque de documentation, qui
rend un agent incohérent d'une session à l'autre.
