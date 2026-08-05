# 3-matrice — les gabarits à remplir

Les fichiers que le nouveau projet recevra, sous forme de **gabarits**. Ils ne contiennent
aucune valeur concrète : uniquement des `{{PLACEHOLDERS}}`, des blocs conditionnels et des
instructions de remplissage (en `<!-- commentaires -->` à supprimer une fois remplis).

| Gabarit | Devient | Couche |
|---|---|---|
| [`AGENTS.template.md`](AGENTS.template.md) | `AGENTS.md` à la racine (+ symlink `CLAUDE.md`) | 1 |
| [`init.template.md`](init.template.md) | `init.md` à la racine | 2 |
| [`harnais-README.template.md`](harnais-README.template.md) | `harnais/README.md` | carte |

## Procédure automatique

Dans le dossier du nouveau projet, avec un agent :

```
/nouveau-projet
```

Voir [`../skills/nouveau-projet/SKILL.md`](../skills/nouveau-projet/SKILL.md).

## Procédure manuelle

Si aucun agent n'est disponible :

```bash
MATRICE=~/Documents/harnais
PROJET=<chemin-du-nouveau-projet>

# Couches 1-2
cp $MATRICE/3-matrice/AGENTS.template.md $PROJET/AGENTS.md
cp $MATRICE/3-matrice/init.template.md   $PROJET/init.md
cd $PROJET && ln -s AGENTS.md CLAUDE.md

# Carte du harnais + garde-fous (taille L uniquement)
mkdir -p $PROJET/harnais/hooks $PROJET/.github/workflows
cp $MATRICE/3-matrice/harnais-README.template.md $PROJET/harnais/README.md
cp $MATRICE/1-methode/hooks/pre-push             $PROJET/harnais/hooks/pre-push
chmod +x $PROJET/harnais/hooks/pre-push
git config core.hooksPath harnais/hooks
cp $MATRICE/1-methode/ci/ci-node-ts.yml          $PROJET/.github/workflows/ci.yml

# Skills (taille M et plus)
mkdir -p $PROJET/.claude/skills
cp -r $MATRICE/1-methode/skills/*                $PROJET/.claude/skills/
cp $MATRICE/1-methode/settings.json.example      $PROJET/.claude/settings.json

# Mémoire
mkdir -p $PROJET/harnais/memoire/archive
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
