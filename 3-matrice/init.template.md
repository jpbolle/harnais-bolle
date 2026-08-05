<!--
GABARIT — init.md (couche 2 : briefing stable)
Né du harnais version {{VERSION_HARNAIS}}.

RÈGLES DE REMPLISSAGE
1. Ce fichier est un BRIEFING POUR UN AGENT, pas une documentation projet exhaustive.
   Critère : tout ce qui lui permet de se localiser vite. Rien de plus.
2. Ce qui change à chaque session ne va PAS ici (→ harnais/memoire/).
   Ce qui ne doit jamais être violé ne va PAS ici (→ AGENTS.md).
3. Supprimer les sections sans objet. Un briefing à moitié vide est plus utile qu'un
   briefing à moitié faux.
4. Supprimer ce commentaire une fois le remplissage terminé.
-->

# {{NOM_PROJET}} — Briefing agent

> Briefing dense lu au début de chaque session pour se localiser vite.
> Ce n'est PAS une documentation exhaustive. Ce qui change session par session vit dans
> `harnais/memoire/`.

---

## ⚡ TL;DR

- **Quoi** : {{DESCRIPTION_UNE_LIGNE}}
- **Statut** : {{STATUT}} ({{VOLUMETRIE_REELLE}})
- **Stack** : {{STACK}}
- **Branche** : `{{BRANCHE}}` → {{EFFET_DU_PUSH}}
- **Harnais** : né de la matrice `harnais` v{{VERSION_HARNAIS}}, taille {{TAILLE}}.
  Règles impératives dans `AGENTS.md` (source unique, `CLAUDE.md` est un symlink).
  Carte : [`harnais/README.md`](./harnais/README.md).

---

## 1. Coordonnées techniques

| Élément | Valeur |
|---|---|
| {{CLE}} | {{VALEUR}} |

### Variables d'environnement
{{LISTE_VARIABLES}} — **ne jamais écrire les valeurs ici.**

### Développement local
```
{{COMMANDES_DEV}}
```

---

## 2. Conventions

<!-- Uniquement ce qui est SPÉCIFIQUE au projet : les conventions générales sont dans
     AGENTS.md, ne pas les répéter (une info, un seul foyer). -->

- {{CONVENTION}}

### Palette / design
{{PALETTE}}

---

## 3. Permissions

<!-- Garder si le projet a des droits différenciés.
     Socle de référence : harnais 2-ecole/permissions-3-couches.md -->

Trois couches qui doivent rester cohérentes : **interface ⊆ route serveur ⊆ règle de base**.

1. **Interface** — {{MECANISME_UI}}
2. **Route serveur** — {{MECANISME_API}} (contourne les règles de la base)
3. **Règles de la base** — {{MECANISME_REGLES}} (déploiement **manuel**)

**Règles d'or** :
- Source des rôles : {{SOURCE_DES_ROLES}}. Jamais par recherche du document par email.
- Pas de rôle codé en dur dans une route serveur.
- Trois symptômes distincts : refus de permission (règle) vs 401 sur une route (serveur)
  vs rien ne se passe (garde d'interface).

---

## 4. Modèle de données

### Collections principales
{{LISTE_COLLECTIONS}}

### Sous-collections
{{LISTE_SOUS_COLLECTIONS}}

### Documents de configuration
{{LISTE_CONFIG}}

---

## 5. Rôles et identité

<!-- Garder si le projet a des comptes. Socle : harnais 2-ecole/roles-et-identite.md -->

### Rôles
{{LISTE_ROLES}}

### Authentification
{{MECANISMES_AUTH}}

### Résolution d'identité
{{ORDRE_DE_RESOLUTION}} — **cumule** les rôles si plusieurs casquettes.

---

## 6. Modules livrés

| Module | Route | État | Note |
|---|---|---|---|
| {{MODULE}} | `{{ROUTE}}` | {{ETAT}} | {{NOTE}} |

---

## 7. Gotchas opérationnels

<!-- Les pièges de CE projet. Chacun DOIT porter son symptôme observable : un gotcha
     sans symptôme est inutilisable, la session suivante rencontrera le symptôme sans
     faire le lien. Les gotchas généraux du domaine sont dans le dépôt harnais. -->

### {{TITRE}}
{{DESCRIPTION}}
**Symptôme** : {{SYMPTOME}}

---

## 8. Pointeurs

### Documentation
- [`AGENTS.md`](./AGENTS.md) — règles impératives
- [`harnais/README.md`](./harnais/README.md) — carte du harnais
- [`harnais/memoire/MEMORY.md`](./harnais/memoire/MEMORY.md) — état cross-sessions
- {{AUTRES_DOCS}}

### Skills
{{LISTE_SKILLS}}

### Code
{{ARBORESCENCE_COMMENTEE}}

---

## 9. Contexte métier

<!-- Ce qu'un agent ne peut pas déduire du code : le domaine, le vocabulaire, les règles
     de l'institution. Pour une app scolaire FWB, le socle est dans le dépôt harnais
     (2-ecole/domaine-fwb.md) — ne mettre ici que ce qui est propre à cet établissement. -->

{{CONTEXTE}}
