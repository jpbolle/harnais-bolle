<!--
GABARIT — conception.md (racine du projet, avant la première ligne de code)
Né du harnais version {{VERSION_HARNAIS}}. Rempli par le skill /conception.
Doctrine : ../1-methode/roadmap-et-plans.md (section « Avant le harnais : conception.md »).

RÈGLES DE REMPLISSAGE
1. Rien n'est inventé : une réponse que l'utilisateur a passée s'écrit « (non précisé) ».
2. La section « Stack » garde TOUTES les options présentées, pas seulement la retenue :
   c'est l'alternative écartée qu'on cherchera dans six semaines.
3. Chaque étape a un critère « terminée quand… » VISIBLE À L'ÉCRAN, pas « les tests passent ».
4. Après le début du code : le fichier reste tel quel. C'est une trace datée. L'état réel
   se lit dans init.md, l'intention qui bouge dans roadmap.md.
5. Supprimer ce commentaire une fois le remplissage terminé.
-->

# {{NOM_PROJET}} — Conception

- **Date** : {{AAAA-MM-JJ}}
- **Pitch initial** : {{PITCH_TEL_QUE_FORMULE}}
- **Pour qui** : {{UTILISATEURS}} <!-- qui, combien, sur quel matériel (Chromebook ? téléphone ?) -->

## Ce que ça fait

- {{FONCTION_1}}
- {{FONCTION_2}}

## Ce que ça ne fait pas

<!-- Aussi important que la section précédente : c'est ce qui empêche l'app de grossir
     dans toutes les directions à la fois. -->
- {{HORS_PERIMETRE}}

## À quoi ça ressemble

<!-- Écran par écran, en mots : ce qu'on voit, ce qu'on peut faire, où ça mène. -->

| Écran | Ce qu'on y voit | Ce qu'on y fait |
|---|---|---|
| {{ECRAN}} | {{CONTENU}} | {{ACTIONS}} |

## Contrainte réelle

{{CONTRAINTE}} <!-- temps disponible, hébergement, matériel des utilisateurs, compétence -->

## Stack

<!-- Options PROPOSÉES PAR L'AGENT, tranchées par l'utilisateur. -->

| Option | Ce que ça implique | Coût / risque |
|---|---|---|
| **A — {{NOM}}** | {{IMPLICATIONS}} | {{COUT}} |
| **B — {{NOM}}** | {{IMPLICATIONS}} | {{COUT}} |

**Retenue : {{OPTION}}**, parce que {{MOTIF}}.

## Étapes

<!-- Dans l'ordre. Chaque étape produit quelque chose de VISIBLE, qu'on peut montrer. -->

1. {{ETAPE}} — terminée quand {{CE_QU_ON_VOIT}}
2. …

## Comment on saura que c'est réussi

{{CRITERE_DE_SUCCES}} <!-- formulé par l'utilisateur, en termes d'usage réel -->

## Points ouverts

- [ ] {{QUESTION_NON_TRANCHEE}}
