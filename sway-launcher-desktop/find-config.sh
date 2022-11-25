#!/bin/bash

for dir in $(fd . ~/dotfiles/ --type=d --exact-depth=1); do
    list=$(fd --type=f --base-directory="$dir" --follow --maxdepth=5)
    for f in $list; do
        base=$(basename "$dir")
        echo -e "$f\034edit-config\034$base/$f\034$dir\034"
    done
done
