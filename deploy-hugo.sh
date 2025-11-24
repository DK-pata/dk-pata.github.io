#!/bin/bash

HUGO_DIR="$(pwd)"
SOURCE_DIR="$HUGO_DIR/public"
GIT_DIR="$HUGO_DIR/_git-pata"
GIT_REPO="origin"
BRANCH="main"

echo "=== 1) Build Hugo ==="
hugo || { echo "Échec du build Hugo"; exit 1; }

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Le dossier '$SOURCE_DIR' n'existe pas."
  exit 1
fi

if [ ! -d "$GIT_DIR/.git" ]; then
  echo "Aucun dépôt Git trouvé dans '$GIT_DIR/.git'."
  exit 1
fi

echo "=== 2) Nettoyage de _git-pata (sauf .git) ==="
(
  cd "$GIT_DIR" || exit 1

  for entry in * .*; do
    case "$entry" in
      '.'|'..'|'.git')
        continue
        ;;
      *)
        rm -rf -- "$entry"
        ;;
    esac
  done
)

echo "=== 3) Copie de public -> _git-pata ==="
cp -r "$SOURCE_DIR/." "$GIT_DIR/" || { echo "Copie échouée"; exit 1; }

echo "=== 4) Commit & push dans _git-pata ==="
git -C "$GIT_DIR" status || { echo "git status a échoué dans _git-pata"; exit 1; }
git -C "$GIT_DIR" add .

if git -C "$GIT_DIR" diff --cached --quiet; then
  echo "Aucun changement à committer, rien à pousser."
else
  git -C "$GIT_DIR" commit -m "Deploy Hugo"
  git -C "$GIT_DIR" push "$GIT_REPO" "$BRANCH"
fi

echo "=== Déploiement terminé ==="
