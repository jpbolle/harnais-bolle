# Tests minimaux — vérifier le résultat, pas la forme

> Taille **L** uniquement. Complète [`garde-fous.md`](garde-fous.md) : la compilation
> vérifie la **forme** du code, ces tests vérifient son **résultat**.

## Le trou que ça comble

`npx tsc --noEmit` — la barrière du hook pre-push — répond à la question « cette fonction
renvoie-t-elle bien un nombre ? ». Jamais à « lequel ? ». Une fonction de moyenne qui
renvoie 26 au lieu de 13 passe la compilation sans une plainte : 26 est un nombre
parfaitement valide.

**Le symptôme, et c'est le pire de tous : il n'y en a pas.** Un calcul faux ne fait pas
planter l'application. Pas d'écran rouge, pas de log, rien dans la console. Un prof ouvre
un bulletin, lit 13,5 au lieu de 12,8, et le croit — c'est un chiffre plausible. L'erreur
se découvre trois semaines plus tard, ou par un parent, ou jamais.

C'est aussi la seule vérification qui ne dépend ni de la bonne volonté de l'agent, ni d'une
relecture du code par l'utilisateur — relecture qui, sur ces projets, n'a pas lieu
(cf. [`../0-moi/profil.md`](../0-moi/profil.md#rapport-au-code)).

## La règle de sélection

**Si le résultat finit sous les yeux d'un prof, d'un élève ou d'un parent, il est testé.
Sinon, non.**

Typiquement, sur une application scolaire :

| Testé | Pas testé |
|---|---|
| Moyennes, pondérations, arrondis | Affichage, mise en page, couleurs |
| Seuils de réussite, calcul d'échec | Appels à la base de données |
| Bornes d'année scolaire, périodes, dates de bulletin | Navigation entre pages |
| Comptages, classements, tris affichés | Code de configuration |

**5 à 10 tests suffisent.** L'objectif n'est pas la couverture, c'est de couvrir les
endroits où une erreur est **silencieuse et coûteuse**. 90 % du code n'a pas besoin de test :
quand il casse, ça se voit tout de suite à l'écran.

## Ce qu'on ne fait pas, et pourquoi

| Écarté | Motif |
|---|---|
| La **couverture** (mesurer le % de code testé) | Chantier sans fin, incompatible avec du travail de soirée et de week-end. Et un pourcentage élevé ne dit rien de la qualité des tests. |
| Les **tests d'interface** (simuler des clics) | Fragiles : ils cassent au moindre changement de design. Un test qui échoue sans raison sérieuse finit désactivé — et il emporte les autres avec lui dans le discrédit. |
| Les **simulations de base de données** | Beaucoup de code pour vérifier surtout la simulation elle-même. Les règles de sécurité se testent avec les outils Firebase, pas ici. |

## L'outil : `node --test`, zéro dépendance

Intégré à Node depuis la version 22.6 — donc **rien à installer, rien à ajouter au
`package.json`**. Sur un projet en production, zéro dépendance nouvelle = zéro risque de
casser le build.

*(Vérifié sur Node v22.15.0 le 2026-08-06.)*

### Emplacement et nommage

Le fichier de test vit **à côté** du fichier qu'il teste, avec le suffixe `.test.ts` :

```
lib/notes.ts
lib/notes.test.ts
```

À côté, et pas dans un dossier `tests/` à part : un test qu'on ne voit pas en ouvrant le
fichier concerné est un test qu'on oublie de mettre à jour.

### Un test complet

```ts
// lib/notes.test.ts
import { test } from 'node:test';
import assert from 'node:assert';
import { calculerMoyenne } from './notes.ts';

test('la moyenne de 12 et 14 vaut 13', () => {
  assert.equal(calculerMoyenne([12, 14]), 13);
});

test('une liste vide ne renvoie pas NaN', () => {
  assert.equal(calculerMoyenne([]), 0);
});
```

Le titre du test se lit en français et énonce la règle métier. C'est volontaire : il doit
être compréhensible **sans lire le code testé**, y compris par quelqu'un qui ne code pas.

### La commande

Dans `package.json` :

```json
"scripts": {
  "test": "node --test --experimental-strip-types \"**/*.test.ts\""
}
```

> ⚠️ **Gotcha — l'extension `.ts` est obligatoire dans l'import.**
> Écrire `from './notes'` au lieu de `from './notes.ts'` échoue avec :
> ```
> Error [ERR_MODULE_NOT_FOUND]: Cannot find module '…/notes'
> ```
> Le message parle d'un module introuvable, ce qui fait chercher du côté d'une dépendance
> manquante ou d'un chemin erroné — alors qu'il ne manque que trois caractères. Node lit le
> TypeScript en retirant les types à la volée, il ne devine pas les extensions comme le
> compilateur.
> *(Reproduit et vérifié le 2026-08-06.)*

## Brancher au garde-fou

Une fois les tests écrits, la commande du hook `pre-push` devient :

```sh
CHECK_CMD="npx tsc --noEmit && npm test"
CHECK_LABEL="TypeScript + tests"
```

Même chose dans la CI, en étape **bloquante**. Un test qui n'empêche rien n'est qu'une
documentation qu'on oublie de lire.

## Entretien

- **Un bug de calcul découvert s'écrit d'abord en test.** Avant de corriger : un test qui
  reproduit l'erreur et qui échoue. On corrige ensuite, jusqu'à ce qu'il passe. C'est la
  seule garantie que ce bug précis ne reviendra pas — et c'est aussi le meilleur moment
  pour écrire un test, puisqu'on tient l'exemple concret.
- **Un test qui échoue ne se supprime pas, il se comprend.** Deux cas seulement : soit le
  code est cassé (on corrige le code), soit la règle métier a changé (on change le test,
  **explicitement**, en disant pourquoi). Supprimer un test gênant, c'est éteindre le
  détecteur de fumée parce qu'il sonne.
- **Ne pas laisser la suite grossir.** Au-delà d'une quinzaine de tests, vérifier qu'on n'a
  pas commencé à tester de l'affichage. La valeur du bloc tient à sa concentration sur les
  calculs.
