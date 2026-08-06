<!--
GABARIT — harnais/plans/<AAAA-MM-JJ>-<sujet>.md (taille L)
Né du harnais version {{VERSION_HARNAIS}}. Doctrine : ../1-methode/roadmap-et-plans.md

QUAND ÉCRIRE UN PLAN
Tâche neuve ou structurelle uniquement (nouveau module, refonte, changement
d'architecture, choix technique). Jamais pour un bug ou un ajustement d'affichage :
un plan pour une petite tâche est une cérémonie, et une cérémonie non suivie dévalue
les règles voisines.

RÈGLES DE REMPLISSAGE
1. Écrit AVANT de coder, validé par l'utilisateur, puis on code.
2. La section « Options » est obligatoire — c'est l'alternative écartée qu'on cherchera
   à retrouver dans six semaines, pas la conclusion.
3. Après livraison : le fichier reste tel quel. C'est une trace datée, pas une doc.
   Ce qui a réellement été construit se lit dans init.md et dans la mémoire.
4. Supprimer ce commentaire une fois le remplissage terminé.
-->

# {{AAAA-MM-JJ}} — {{SUJET}}

- **Statut** : proposé <!-- → validé le {{DATE}} → livré le {{DATE}} -->
- **Demande initiale** : {{CE_QUE_L_UTILISATEUR_A_DEMANDE}}

## Le problème

{{QU_EST_CE_QUI_NE_VA_PAS_AUJOURD_HUI}}
<!-- En termes de symptôme observable, pas de solution manquante. -->

## Options

| Option | Ce que ça implique | Coût / risque |
|---|---|---|
| **A — {{NOM}}** | {{IMPLICATIONS}} | {{COUT}} |
| **B — {{NOM}}** | {{IMPLICATIONS}} | {{COUT}} |

**Retenue : {{OPTION}}**, parce que {{MOTIF}}.

## Ce qu'on fait

1. {{ETAPE}} — fichiers : `{{FICHIERS}}`
2. …

## Ce qu'on ne fait pas dans ce chantier

<!-- Délimiter explicitement : c'est ce qui empêche un chantier de déborder en refonte. -->
- {{HORS_PERIMETRE}}

## Comment on saura que ça marche

{{VERIFICATION_VISIBLE}}
<!-- Ce qu'on voit à l'écran, pas « les tests passent ». -->

## Points à trancher par l'utilisateur

- [ ] {{QUESTION_OUVERTE}}
