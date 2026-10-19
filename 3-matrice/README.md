# 3-matrice — les gabarits à remplir

Les fichiers que le nouveau projet recevra, sous forme de **gabarits**. Ils ne contiennent
aucune valeur concrète : uniquement des `{{PLACEHOLDERS}}`, des blocs conditionnels et des
instructions de remplissage (en `<!-- commentaires -->` à supprimer une fois remplis).

| Gabarit | Devient | Couche |
|---|---|---|
| [`AGENTS.template.md`](AGENTS.template.md) | `AGENTS.md` à la racine (+ symlink `CLAUDE.md`) | 1 |
| [`init.template.md`](init.template.md) | `init.md` à la racine | 2 |
| [`roadmap.template.md`](roadmap.template.md) | `roadmap.md` à la racine (taille M et plus) | intention |
| [`plan.template.md`](plan.template.md) | `harnais/plans/<date>-<sujet>.md` (taille L) | intention |
| [`conception.template.md`](conception.template.md) | `conception.md` à la racine, avant tout code (rempli par `/conception`) | intention |
| [`harnais-README.template.md`](harnais-README.template.md) | `harnais/README.md` | carte |
| [`gitignore.template`](gitignore.template) | `.gitignore` à la racine (compléter s'il existe déjà) | garde-fou |

## Procédure automatique

Dans le dossier du nouveau projet, avec un agent :

```
/conception <pitch>   # si le projet part d'une idée, sans code : écrit conception.md
/nouveau-projet       # pose le harnais
```

Voir [`../skills/conception/SKILL.md`](../skills/conception/SKILL.md) et
[`../skills/nouveau-projet/SKILL.md`](../skills/nouveau-projet/SKILL.md).

## Procédure manuelle

Si aucun agent n'est disponible. **D'abord l'inventaire** de l'étape 4a du skill
([`SKILL.md`](../skills/nouveau-projet/SKILL.md#étape-4--inventorier-puis-écrire)) : si un
fichier visé existe déjà, on s'arrête et on fusionne à la main. Les `cp -n` ci-dessous ne
remplacent jamais un fichier existant — ils le sautent en silence, d'où l'inventaire.

```bash
MATRICE=~/Documents/harnais
PROJET=<chemin-du-nouveau-projet>

# Couches 1-2
cp -n $MATRICE/3-matrice/gitignore.template   $PROJET/.gitignore   # s'il existe : ajouter les lignes manquantes à la main
cp -n $MATRICE/3-matrice/AGENTS.template.md $PROJET/AGENTS.md
cp -n $MATRICE/3-matrice/init.template.md   $PROJET/init.md
cd $PROJET && ln -s AGENTS.md CLAUDE.md

# Carte du harnais + garde-fous (taille L uniquement)
mkdir -p $PROJET/harnais/hooks $PROJET/.github/workflows
cp -n $MATRICE/3-matrice/harnais-README.template.md $PROJET/harnais/README.md
cp -n $MATRICE/1-methode/hooks/pre-push             $PROJET/harnais/hooks/pre-push
cp -n $MATRICE/1-methode/hooks/lint-harnais.sh      $PROJET/harnais/hooks/lint-harnais.sh
chmod +x $PROJET/harnais/hooks/pre-push $PROJET/harnais/hooks/lint-harnais.sh
git config core.hooksPath harnais/hooks   # seulement si `git config core.hooksPath` était vide
cp -n $MATRICE/1-methode/ci/ci-node-ts.yml          $PROJET/.github/workflows/ci.yml

# Skills (taille M et plus)
mkdir -p $PROJET/.claude/skills
cp -Rn $MATRICE/1-methode/skills/*                  $PROJET/.claude/skills/
cp -n  $MATRICE/1-methode/settings.json.example     $PROJET/.claude/settings.json

# Mémoire
mkdir -p $PROJET/harnais/memoire/archive
[ -e $PROJET/harnais/memoire/MEMORY.md ] || \
  printf '# Mémoire %s\n\nIndex — une ligne par entrée.\n' "$(basename $PROJET)" \
  > $PROJET/harnais/memoire/MEMORY.md
```

Puis remplir les `{{PLACEHOLDERS}}` **à la main**, en supprimant tout bloc qui ne
s'applique pas au projet.

## La règle qui fait la valeur des gabarits

**Supprimer ce qui ne s'applique pas est plus important que remplir ce qui s'applique.**

Un `AGENTS.md` qui contient une règle sur les élèves dans un projet sans élèves, ou une
procédure de déploiement de règles de base dans un projet sans base, apprend à l'agent que
les règles de ce fichier sont approximatives. À partir de là, il traite toutes les autres
de la même façon — y compris celles qui protègent la production.
