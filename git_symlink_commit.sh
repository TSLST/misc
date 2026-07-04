#!/bin/bash

DEFAULT_MESSAGE="up"

COMMIT_MESSAGE="${1:-$DEFAULT_MESSAGE}"
CURRENT_DIR=$(pwd)
liens=()

#------------------------
### 1. Identify Symlinks
#------------------------

mapfile -t liens < <(find . -maxdepth 1 -type l)

if [ ${#liens[@]} -eq 0 ]; then
    echo "Symlink commit $CURRENT_DIR >> ERROR: No symlink found!!"
    exit 0
fi

#------------------------
### 2. Replace Symlinks by Actual Files
#------------------------

for lien in "${liens[@]}"; do
    cible=$(readlink -f "$lien")
    echo "Replacing $lien by original file..."
    rm "$lien"
    cp "$cible" "$lien"
done

#------------------------
### 3. Git: Add & Commit
#------------------------

git add .
git commit -m "$COMMIT_MESSAGE"

#------------------------
### 4. Replace Files by Symlinks
#------------------------

for lien in "${liens[@]}"; do
    echo "Restoring symlink $lien..."
    rm "$lien"
    ln -s "$cible" "$lien"
done

echo "Symlink commit $CURRENT_DIR >> SUCCESS!!"