#!/bin/bash
# ---
# Name: git_symlink_commit.sh
# Type: Code
# Use: >
#    Shell script to commit symlinks to github repo automatically.
#    Replace the symlink by a copy of the original file, commits, 
#    then restores the symlink
# Tags: !!str "#bash #git #symlinks"
# Creation: 2026-07-04
# Update: 2026-07-04
# Contributors: [神縁]
# Version: !!str 0.1.0
# ---

#===============================================================================
## Variables
#===============================================================================

DEFAULT_MESSAGE="up"

COMMIT_MESSAGE="${1:-$DEFAULT_MESSAGE}"
CURRENT_DIR=$(pwd)
symlinks=()
declare -A arr_files

#===============================================================================
## Main Flow
#===============================================================================

#------------------------
### 1. Identify Symlinks
#------------------------

mapfile -t symlinks < <(find . -maxdepth 1 -type l)

if [ ${#symlinks[@]} -eq 0 ]; then
    echo "Symlink commit $CURRENT_DIR >> ERROR: No symlink found!!"
    exit 0
fi

for symlink in "${symlinks[@]}"; do
    arr_files["$symlink"]="$(readlink "$symlink")"
done

#------------------------
### 2. Replace Symlinks by Actual Files
#------------------------

for symlink in "${!arr_files[@]}"; do
   target="${arr_files[$symlink]}"
   echo "Replacing $symlink by original file..."
   rm "$symlink"
   cp "$target" "$symlink"
done

#------------------------
### 3. Git: Add & Commit
#------------------------

git add .
git commit -m "$COMMIT_MESSAGE"
git push

#------------------------
### 4. Replace Files by Symlinks
#------------------------

for symlink in "${!arr_files[@]}"; do
   target="${arr_files[$symlink]}"
   echo "Restoring symlink $symlink..."
   rm "$symlink"
   ln -s "$target" "$symlink"
done

echo "Symlink commit $CURRENT_DIR >> SUCCESS!!"

# ***