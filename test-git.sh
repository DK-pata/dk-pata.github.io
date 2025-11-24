#!/bin/bash

HUGO_DIR="$(pwd)"
GIT_DIR="$HUGO_DIR/_git-pata"

echo "=== 1) Vérif dépôt ==="
if [ ! -d "$GIT_DIR/.git" ]; then
  echo "Pas de dépôt git dans _git-pata, arrêt."
  exit 1
fi

echo "=== 2) git status dans _git-pata ==="
git -C "$GIT_DIR" status || { echo "git status KO, arrêt."; exit 1; }
#!/bin/bash
GIT_DIR="$(pwd)/_git-pata"

echo "Vérif dépôt dans: $GIT_DIR"
git -C "$GIT_DIR" status || { echo "git status KO, arrêt."; exit 1; }
