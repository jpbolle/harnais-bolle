<!--
GABARIT — roadmap.md (l'intention produit)
Né du harnais version {{VERSION_HARNAIS}}. Doctrine : ../1-methode/roadmap-et-plans.md

RÈGLES DE REMPLISSAGE
1. Trois sections, pas une de plus.
2. AUCUNE DATE. L'ordre suffit. Une date posée sur du travail de soirée est une date
   ratée, et une roadmap visiblement fausse cesse d'être lue.
3. Ce qui est faisable en une session n'est pas de la roadmap : c'est un TODO de mémoire.
4. Une entrée livrée DISPARAÎT (son état se lit dans init.md), elle ne se coche pas.
5. Supprimer ce commentaire une fois le remplissage terminé.
-->

# {{NOM_PROJET}} — Roadmap

> Où va cette application. **Ce qui est déjà construit ne se lit pas ici** mais dans
> [`init.md`](./init.md) ; ce qui bouge cette semaine est dans la mémoire.

## Maintenant

<!-- Un seul chantier, deux au maximum. Au-delà, ce n'est plus un ordre de priorité. -->

- **{{CHANTIER_EN_COURS}}** — {{POURQUOI_MAINTENANT}}
  <!-- S'il existe un plan validé : lien vers harnais/plans/<date>-<sujet>.md -->

## Ensuite

<!-- Dans l'ordre de priorité, sans dates. Une ligne par chantier, formulée en résultat
     visible ("les profs peuvent exporter X"), pas en tâche technique. -->

1. {{CHANTIER_SUIVANT}} — {{RESULTAT_VISIBLE_ATTENDU}}
2. …

## Écarté

<!-- LA SECTION LA PLUS UTILE DU FICHIER. Sans motif écrit, une idée rejetée revient tous
     les trois mois, et la deuxième fois personne ne se souvient pourquoi elle avait été
     rejetée la première. -->

| Idée | Pourquoi non | Quand ça pourrait changer |
|---|---|---|
| {{IDEE_ECARTEE}} | {{MOTIF}} | {{CONDITION_DE_REOUVERTURE}} |
