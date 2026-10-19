# Skills et plugins externes — ce qui vit hors du dépôt

> **Pourquoi ce fichier existe.** Les plugins Claude Code s'installent dans `~/.claude/`,
> qui n'est pas un dépôt git. Rien ne se synchronise entre le MacBook Pro et le Mac Studio,
> et surtout **rien ne signale l'écart** : sur la machine en retard, l'agent ne dit pas
> « il me manque un outil », il travaille simplement moins bien. Ce fichier-ci est la seule
> liste qui traverse les deux postes.
>
> Ce n'est pas une liste de souhaits : **on n'y écrit un skill qu'une fois installé et
> vérifié** sur au moins une machine.

## État installé

Vérifié le **2026-08-06** sur le **MacBook Pro**. Colonne « Portée » : `global` = actif dans
tous les projets ; `projet` = installé dans le dossier d'un projet précis.

| Skill / plugin | Ce qu'il apporte | Portée | Mac Studio |
|---|---|---|---|
| `typescript-lsp` | *Serveur de langage* (analyse le code en continu comme un IDE) : renvoie les erreurs de type à l'agent après chaque modification, au lieu de les découvrir quand l'app plante. Le plus utile des trois, vu que l'utilisateur ne relit pas le code lui-même. | global | ☐ à rejouer |
| `impeccable` | 60 règles de détection des tics d'UI générée par IA + audit de qualité visuelle (`/impeccable audit`, `/impeccable polish`). Vise le critère « le rendu de l'app » de [`../0-moi/profil.md`](../0-moi/profil.md#ce-qui-fait-une-bonne-session). | global | ☐ à rejouer |
| `firebase-security-rules-auditor` | Relit les règles de sécurité Firestore et note les failles de 1 à 5 (élévation de privilège, contournement d'autorisation). Publié par Firebase. Réservé aux projets à données réelles. | projet — KitSchool | ✅ automatique **une fois commité** |
| `frontend-design`, `firebase` (officiels) | Déjà installés avant ce fichier, gardés. | global | ☐ à rejouer |
| `/conception`, `/nouveau-projet` (skills de la matrice) | Concevoir une app depuis un pitch, puis poser le harnais. Liens symboliques vers `~/Documents/harnais/skills/`, donc toujours à jour avec la matrice, sans copie. Posés le 2026-10-19. | global | ☐ à rejouer |
| `/transcript`, `/video_download` (skills d'un collègue, copiés dans `~/.claude/skills/`, adaptés le 2026-10-19 : chemins `transcripts/` et `downloads/` dans le dossier courant, `whisper-ctranslate2` appelé directement) | Transcrire une vidéo ou un enregistrement localement (Whisper), télécharger une vidéo ou son audio (`yt-dlp`). **Outillage personnel, rien à voir avec le harnais d'une app.** Les originaux sont dans les zips `transcript.zip` et `video_download.zip` de Téléchargements. | global | ☐ à copier à la main (pas de dépôt) |

**La différence de la dernière colonne est la leçon du fichier** : un skill en portée
*globale* vit dans `~/.claude/` et ne franchit pas la frontière entre les deux Macs ; un
skill en portée *projet* est un fichier du dépôt et voyage tout seul avec `git pull`.
Quand le choix existe, préférer la portée projet.

## Outils système

Ce que l'agent peut appeler en ligne de commande et qui ne vit ni dans un dépôt ni dans
`~/.claude/`. Vérifié le **2026-10-19** sur le **MacBook Pro**. Vérification :
`command -v <outil>` dans un **terminal ordinaire** (pas dans une session Claude Code, voir
le piège `rg`).

| Outil | À quoi il sert | Installation | MacBook Pro | Mac Studio |
|---|---|---|---|---|
| `git` | Versions | Livré avec macOS | ✅ | ✅ (livré) |
| `jq` | Lire et transformer du JSON en ligne de commande (hooks, scripts) | Livré avec macOS (`/usr/bin/jq`) | ✅ | ✅ (livré) |
| `uv` | Tout Python (cf. [`consignes.md`](../0-moi/consignes.md#dépendances)) | Installateur officiel, **pas Homebrew** | ✅ 0.13.1 | ☐ |
| `ffmpeg` | Convertir audio et vidéo ; prépare le son pour la transcription | `brew install ffmpeg` | ✅ 8.0.1 | ☐ |
| `whisper-ctranslate2` | Transcrire la parole en texte **localement** (cours, réunions) : rien ne sort de la machine | `uv tool install --python 3.12 whisper-ctranslate2` | ✅ 0.5.8 | ☐ |
| `rg` (ripgrep) | Recherche de texte très rapide dans les fichiers | `brew install ripgrep` | ☐ absent | ☐ |

**Piège `rg`** : dans une session Claude Code, `rg` répond toujours — c'est une fonction que
Claude Code injecte pour utiliser son ripgrep embarqué. Un `command -v rg` fait là conclut à
tort que l'outil est installé. Vérifier dans un terminal ordinaire.

**Piège `uv tool install`** (vécu le 2026-10-19) : sans `--python 3.12`, uv a pris le Python
3.14 de Homebrew, trop récent pour les paquets précompilés de `whisper-ctranslate2` ; il a
rabattu sur une version de 2023 (0.2.9) et tenté de **compiler** une dépendance, échec
« pkg-config is required ». Avec `--python 3.12`, uv télécharge ce Python lui-même et
installe la version courante (0.5.8) en quelques secondes. Règle : **si `uv tool install`
compile, c'est que la version de Python est trop neuve : fixer `--python 3.12`.**

*Origine : liste d'outils conseillée par un collègue (prompts d'installation de son espace de
cours), 2026-10-19. Reprise pour l'inventaire par machine ; aucun n'est requis par le harnais
d'une app.*

## Rattrapage sur une machine neuve

À dérouler **une étape à la fois**, dans cet ordre.

1. Serveur de langage :
   ```
   /plugin install typescript-lsp@claude-plugins-official
   ```
2. Déclarer la source d'`impeccable`, puis l'installer :
   ```
   /plugin marketplace add pbakaus/impeccable
   /plugin install impeccable@impeccable
   ```
3. L'auditeur Firestore : **rien à faire** s'il a été commité dans KitSchool — il arrive
   avec le `git pull`. S'il manque, le réinstaller depuis le dossier du projet :
   ```
   npx skills add https://github.com/firebase/agent-skills --skill firebase-security-rules-auditor
   ```
   L'installateur écrit trois choses dans le dépôt : `.agents/skills/<nom>/SKILL.md` (le
   skill lui-même), un lien symbolique dans `.claude/skills/` (par où Claude Code le voit)
   et `skills-lock.json` (la version installée). Les trois doivent être commités, sinon le
   skill ne suit pas.
4. Recréer `~/.claude/CLAUDE.md` (voir plus bas) — sans lui, l'agent ne connaît pas le profil
   hors de ce dépôt.
5. Lier les skills de la matrice (le clone doit être à `~/Documents/harnais`, sinon adapter) :
   ```
   ln -s ~/Documents/harnais/skills/conception     ~/.claude/skills/conception
   ln -s ~/Documents/harnais/skills/nouveau-projet ~/.claude/skills/nouveau-projet
   ```
6. Outils système (voir le tableau plus haut), dans l'ordre : uv par l'installateur officiel,
   puis `brew install ffmpeg ripgrep`, puis `uv tool install --python 3.12 whisper-ctranslate2`.
   Puis copier `~/.claude/skills/transcript/` et `~/.claude/skills/video_download/` depuis le
   MacBook Pro (ils ne sont dans aucun dépôt).
7. Vérifier :
   ```
   cat ~/.claude/settings.json          # enabledPlugins doit lister les plugins à true
   ls ~/.claude/CLAUDE.md
   ls -l ~/.claude/skills/              # conception et nouveau-projet doivent pointer vers la matrice
   command -v uv ffmpeg rg whisper-ctranslate2   # dans un terminal ordinaire
   ```

## Le fichier `~/.claude/CLAUDE.md`

Choix retenu le 2026-08-06 (cf. [`../0-moi/README.md`](../0-moi/README.md#mécanisme-de-diffusion--pull-jamais-copie)) :
**un renvoi vers `0-moi/`, pas une copie du profil.** Contenu à recréer à l'identique :

```markdown
# Consignes globales — Jean-Philippe Bolle

> Ce fichier est un **renvoi**, pas une copie. Le foyer unique de « qui je suis » et
> « comment on travaille » est le dépôt `harnais`. Ne jamais recopier son contenu ici :
> deux versions divergent toujours, et l'agent finirait par appliquer des consignes périmées.

## Trois fichiers à connaître avant d'agir

Depuis `/Users/jpbolle/Documents/harnais/0-moi/` :

| Fichier | Ce qu'il contient |
|---|---|
| `profil.md` | Qui je suis, mon contexte, mon rapport au code |
| `methode.md` | Rythme, périmètre de décision, format des réponses attendu |
| `consignes.md` | Les interdits durables et leur *pourquoi* |

Ces trois fichiers **priment sur les habitudes par défaut de l'agent**.

**Claude Code les importe automatiquement** (lignes `@` en bas de ce fichier) : leur
contenu suit ce texte. **Si ce contenu n'est pas là** (autre outil qui ignore les `@`,
fichier déplacé, autre machine), **les ouvrir et les lire soi-même avant d'agir**.

**Si tu ne peux pas les lire du tout** : **le dire et t'arrêter**. Ne pas deviner mes
préférences, ne pas te rabattre sur tes réglages par défaut — `consignes.md` contient des
interdits dont la violation coûte cher (push, envoi d'email, dépendance ajoutée). Un agent
qui les ignore sans le savoir est plus dangereux qu'un agent qui demande.

## Entretien

Toute règle nouvelle exprimée dans un projet remonte dans
`/Users/jpbolle/Documents/harnais/0-moi/consignes.md` — jamais dans ce fichier-ci.

## Imports

@/Users/jpbolle/Documents/harnais/0-moi/profil.md
@/Users/jpbolle/Documents/harnais/0-moi/methode.md
@/Users/jpbolle/Documents/harnais/0-moi/consignes.md
```

> **Renvoi pur, décidé le 2026-08-06.** Une première version résumait ici les huit
> interdits principaux, comme filet si le dépôt était inaccessible. Écarté : c'était une
> deuxième copie de [`../0-moi/consignes.md`](../0-moi/consignes.md), qui aurait divergé au
> premier changement de consigne — et une consigne périmée appliquée avec assurance est
> pire que pas de consigne du tout. Le filet est remplacé par une instruction d'arrêt :
> dépôt illisible ⇒ l'agent le signale au lieu d'improviser.

> **Imports `@`, ajoutés le 2026-10-14.** Avant, le fichier disait seulement « lis ces
> trois fichiers » : la lecture dépendait de la bonne volonté de l'agent et coûtait trois
> appels d'outil à chaque session. Les lignes `@chemin` les font charger par Claude Code
> lui-même, sans copie : c'est toujours un renvoi. Ce que dit la doc Claude Code (page
> « memory ») :
> - dans `~/.claude/CLAUDE.md`, les imports se chargent **sans fenêtre d'approbation**,
>   même hors du projet ;
> - un `@` **entre backticks** (accents graves) ou dans un bloc de code n'est **pas**
>   importé — d'où les lignes nues en bas du fichier ;
> - vérifier ce qui a été chargé : `/context`, rubrique *Memory files*.
>
> ⚠️ **Gotcha — ne pas recopier ces `@` dans l'`AGENTS.md` d'un projet.** Dans un fichier
> de projet, un import qui sort du dossier ouvre une fenêtre d'approbation. **Si on la
> refuse, les imports restent désactivés et la fenêtre ne revient plus** : le profil cesse
> d'être chargé dans ce projet, sans aucun message. Le chargement global suffit.
> *Origine : prompt d'installation d'un espace de cours examiné le 2026-10-14 ; la doc a
> été vérifiée, mais pas encore le comportement sur la version 2.1.223 installée (à
> confirmer par `/context` à la prochaine session).*

## Ce qui a été écarté, et pourquoi

Un skill écarté sans motif écrit revient tous les six mois dans la conversation.

| Écarté | Motif |
|---|---|
| `Superpowers` | Impose sa propre boucle « plan d'abord », en concurrence avec [`../0-moi/methode.md`](../0-moi/methode.md#rythme). Deux méthodes rivales s'annulent. |
| Les 13 autres serveurs de langage (Python, Rust, Go…) | Tout le code de l'utilisateur est en JS/TS. |
| `~/.codex/AGENTS.md` (renvoi global pour Codex) | Codex n'est quasiment jamais utilisé (décidé le 2026-08-06). Le renvoi global n'existe que pour Claude Code, et c'est suffisant. |
| **Serveurs MCP Google Classroom** (versions communautaires) | ⛔ **Refus de principe, pas un report.** Un serveur tiers verrait passer noms d'élèves, travaux et notes — des données de mineurs. Base légale, analyse d'impact et décision de l'école d'abord ; ce n'est pas un arbitrage individuel, même comme référent numérique. Seul chemin défendable si le besoin devient réel : le serveur MCP Workspace de Google lui-même, via l'admin Workspace de l'école. |
| **Skills pédagogiques** ([k12-teacher-skills](https://github.com/anthropics/k12-teacher-skills), [education-agent-skills](https://github.com/GarethManning/education-agent-skills)) | Hors périmètre : ils servent à **préparer des cours**, pas à construire des applications — ils échouent au critère d'admission de `2-ecole/`. Leur foyer serait une installation globale ou un dépôt à part. À noter aussi : les skills officiels sont calés sur les référentiels scolaires américains, donc inutilisables tels quels en FWB. Rien n'existe pour la FWB (constat du 2026-08-06). |
| Skill d'audit RGPD (scan de données personnelles dans le code, génération d'AIPD) | **Reporté, pas rejeté.** Pertinent pour KitSchool (données de mineurs), mais il n'a d'objet qu'au moment où on harnachera ce projet. À réexaminer à ce moment-là, en appui du bloc `../2-ecole/rgpd-chiffrement.md`. |

## À essayer

Ni installé, ni écarté — la liste courte de ce qui mérite un test.

| Piste | Ce qu'il faut faire | Coût / risque |
|---|---|---|
| Connecteur **Learning Commons Knowledge Graph** | Il apparaît déjà dans les sessions Claude Code mais **non autorisé**. L'autorisation se fait dans les réglages de connecteurs sur claude.ai — un agent ne peut pas la déclencher. | Gratuit, aucune donnée d'élève en jeu. Sert surtout à voir la mécanique d'un skill pédagogique sérieux, pas à s'en servir en FWB. |
| `Context7` (injecte la doc à jour d'une bibliothèque) | L'essayer sur une session Next.js ou Firebase, et juger. | Faible. Utile sur le papier — ces deux-là bougent vite et la mémoire du modèle date. |
| Audit d'accessibilité (WCAG) | Comparer sérieusement deux ou trois paquets ; aucun n'a été évalué. | Faible. Terrain concret : élèves sur Chromebooks d'entrée de gamme, contraste et taille de cible. |

## Règle d'admission

Un skill entre dans ce fichier s'il est **utile à n'importe quelle app** (tier 1). Un skill
qui n'a de sens que pour une seule application n'entre pas ici : il vit dans le
`.claude/skills/` de cette application, et rien d'autre n'est à écrire.

L'auditeur Firestore figure quand même dans le tableau **en tant qu'exception documentée** :
il est réutilisable par toute app Firebase à données réelles, mais installé dans un seul
projet pour l'instant. Le jour où un deuxième projet en a besoin, la commande est ici.
