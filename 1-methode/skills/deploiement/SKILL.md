---
name: deploiement
description: Déployer {{NOM_PROJET}} — les N surfaces indépendantes
user_invocable: true
trigger: "deploy", "déployer", "mettre en prod", "push prod"
---

# Déployer {{NOM_PROJET}} — {{N}} surfaces INDÉPENDANTES

> Gabarit issu du harnais. À l'installation : lister les surfaces **réelles** de ce projet,
> supprimer les autres.

⚠️ Le piège central : il n'y a presque jamais **un** déploiement, mais plusieurs, découplés.
En oublier un = production incohérente, et le symptôme apparaît chez l'utilisateur, pas
chez le développeur. Le cas typique : du code livré qui utilise une nouvelle collection,
mais les règles de sécurité pas redéployées → `permission denied` en prod alors que tout
fonctionne en local.

## Surface 1 — l'application (automatique sur push)

1. `{{COMMANDE_VERIF}}` doit passer (le hook pre-push le bloque sinon).
2. `git status` — montrer les changements, proposer un commit (anglais, conventionnel).
3. `git push origin main` → build et déploiement **automatiques**.
   **Jamais sans accord explicite de l'utilisateur.**
4. La CI revérifie en parallèle sur machine neutre.
5. Vérifier ensuite dans l'application déployée — en particulier les pages touchées.

## Surface 2 — les règles de sécurité de la base (MANUEL)

Si les règles ont changé, ou si une nouvelle collection est lue/écrite **côté client** :

```
{{COMMANDE_DEPLOIEMENT_REGLES}}
```

Puis vérifier dans l'app **et** commiter le fichier de règles : il doit toujours refléter
ce qui est réellement déployé. Idem pour les index si le projet en a.

## Surface 3 — {{AUTRE_SURFACE}} (MANUEL)

Extension de navigateur, application mobile, tâche planifiée, fonction serverless…
Chacune a son propre cycle : bump de version → build → publication → noter la version
publiée dans le rollup du module.

## Checklist post-déploiement

Ces réglages **ne voyagent pas avec le code** — c'est ce qui les rend faciles à oublier :

- Nouvelle variable d'environnement ? → à ajouter côté hébergeur (secrets), sinon crash
  au runtime, après un build pourtant réussi.
- Nouveau contenu piloté par la base (template d'email, permission dynamique, paramètre) ?
  → à créer ou cocher dans l'interface d'administration, pas dans le code.
- Migration de données à lancer ? → elle n'est pas déclenchée par le déploiement.
