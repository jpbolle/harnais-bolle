#!/bin/sh
# lint-harnais.sh — vérifie la FORME des fichiers du harnais, sans rien modifier.
#
# Déterministe, zéro jeton : mêmes fichiers, même verdict. L'agent lance, lit le rapport,
# corrige avec accord, relance jusqu'à « Tout est OK ». Tant que ce script n'a pas dit OK,
# l'agent n'annonce pas un harnais en ordre : c'est son verdict qui fait foi, pas
# l'impression de celui qui a écrit les fichiers.
#
# Appelé par le hook pre-push (bloquant) et à la demande :  harnais/hooks/lint-harnais.sh
# À lancer depuis la racine du projet. Code de sortie : 0 si tout est conforme, 1 sinon.
#
# Ce qu'il attrape (chaque piège est documenté dans 1-methode/memoire.md ou les-5-couches.md) :
#   1. Un AGENTS.md sans CLAUDE.md à côté      → consigne locale ignorée par Claude Code, sans erreur
#   2. Un {{PLACEHOLDER}} ou <!-- GABARIT oublié → l'agent lit un gabarit à la place d'une règle
#   3. L'index mémoire qui enfle ou dévie      → contexte tronqué au démarrage, sans signal
#   4. Un SKILL.md à l'en-tête YAML cassé       → le skill disparaît de la liste, sans erreur
#   5. Un secret ou un fichier > 5 Mo suivi par git → part en ligne au prochain push, pour toujours

MAX_INDEX_LINES=40          # au-delà, l'index MEMORY.md n'est plus un index
MEMORY_INDEX="harnais/memoire/MEMORY.md"

ERRORS=0
ko() { printf '!! %s\n' "$1"; ERRORS=$((ERRORS + 1)); }

# Parcours commun : on ignore .git, node_modules et les archives de mémoire.
scan() { find . \( -path './.git' -o -path '*/node_modules' -o -path '*/harnais/memoire/archive' \) -prune -o -type f -name "$1" -print; }

# ---- 1. AGENTS.md orphelins ------------------------------------------------------------
# `-e` échoue aussi sur un symlink cassé : voulu, un pont cassé vaut un pont absent.
for agents in $(scan AGENTS.md); do
  dir=$(dirname "$agents")
  [ -e "$dir/CLAUDE.md" ] || ko "$dir/AGENTS.md sans CLAUDE.md à côté — corriger : cd $dir && ln -s AGENTS.md CLAUDE.md"
done

# ---- 2. Gabarits non remplis -----------------------------------------------------------
# Les fichiers nommés _gabarit.md ou *.template.md sont des gabarits par nature : ignorés.
for f in AGENTS.md init.md roadmap.md $(find ./harnais -type f -name '*.md' 2>/dev/null | grep -v -e '_gabarit.md' -e '.template.md' -e '/archive/'); do
  [ -f "$f" ] || continue
  # Un {{ cité entre accents graves (`{{X}}`) est une mention, pas un gabarit : ignoré.
  grep -v '`[^`]*{{' "$f" | grep -q '{{' && ko "$f contient un {{PLACEHOLDER}} non rempli"
  grep -q '<!-- GABARIT' "$f" && ko "$f contient un commentaire <!-- GABARIT non supprimé"
done

# ---- 3. Index mémoire ------------------------------------------------------------------
if [ -f "$MEMORY_INDEX" ]; then
  n=$(grep -c '^- \[' "$MEMORY_INDEX")
  [ "$n" -gt "$MAX_INDEX_LINES" ] && ko "$MEMORY_INDEX : $n entrées (max $MAX_INDEX_LINES) — l'index enfle, consolider dans les rollups"
  # Toute ligne non vide qui n'est ni titre, ni citation, ni entrée au bon format
  for ln in $(grep -nv -e '^$' -e '^#' -e '^>' -e '^- \[[^]]*\]([^)]*) — ' "$MEMORY_INDEX" | cut -d: -f1); do
    ko "$MEMORY_INDEX ligne $ln : hors format « - [Titre](fichier.md) — accroche » — du contenu dans l'index ?"
  done
fi

# ---- 4. En-têtes des SKILL.md ----------------------------------------------------------
for f in $(scan SKILL.md); do
  [ "$(sed -n 1p "$f")" = "---" ] || { ko "$f : pas d'en-tête YAML (première ligne doit être ---)"; continue; }
  close=$(sed -n '2,40p' "$f" | grep -n '^---$' | head -1 | cut -d: -f1)
  [ -n "$close" ] || { ko "$f : en-tête YAML non fermé (manque le --- final)"; continue; }
  head=$(sed -n "2,$((close))p" "$f")
  printf '%s\n' "$head" | grep -q '^name:' || ko "$f : en-tête sans champ name"
  printf '%s\n' "$head" | grep -q '^description:' || ko "$f : en-tête sans champ description"
  # Une valeur non citée qui contient « : » casse le YAML → le skill n'est pas chargé, sans erreur
  printf '%s\n' "$head" | grep -E '^(name|description):' | grep -v -E '^[a-z_-]+: *["'"'"']' | grep -qE '^[a-z_-]+: .*: ' \
    && ko "$f : une valeur de l'en-tête contient « : » sans guillemets — la mettre entre guillemets doubles"
done

# ---- 5. Secrets et fichiers lourds suivis par git ---------------------------------------
# Un fichier suivi (git ls-files) part au push. Un secret poussé est à révoquer, pas à
# retirer : l'historique le garde. Hors dépôt git : contrôle sauté sans bruit.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  OLDIFS=$IFS; IFS='
'
  for f in $(git ls-files | grep -iE '(^|/)\.env(\..*)?$|\.(pem|key|p12|pfx)$|serviceaccount[^/]*\.json$|credentials[^/]*\.json$|(^|/)secrets?\.[a-z]+$' | grep -viE '\.(example|sample|template)$'); do
    ko "$f est suivi par git et ressemble à un secret — le retirer du suivi (git rm --cached) et l'ajouter au .gitignore ; s'il a déjà été poussé, révoquer la clé"
  done
  for f in $(git ls-files | while IFS= read -r x; do [ -f "$x" ] && [ "$(wc -c < "$x")" -gt 5242880 ] && printf '%s\n' "$x"; done); do
    ko "$f fait plus de 5 Mo et est suivi par git — un dépôt n'est pas un disque : l'écarter (.gitignore) ou le stocker ailleurs"
  done
  IFS=$OLDIFS
fi

# ---- Verdict ---------------------------------------------------------------------------
if [ "$ERRORS" -eq 0 ]; then
  echo "[harnais] ✅ Tout est OK."
  exit 0
fi
echo "[harnais] ❌ $ERRORS anomalie(s) de forme dans le harnais."
exit 1
