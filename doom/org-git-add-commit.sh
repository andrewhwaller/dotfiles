#!/bin/bash

cd "$HOME/github/org" || exit 1

# Make sure master branch is checked out
if ! [[ $(git rev-parse --abbrev-ref HEAD) = "main" ]]
then
    echo "ERROR: main branch not checked out" >&2
    exit 1
fi

# Only run add/commit if there is anything to add
if [[ $(git status --porcelain) ]]
then
    git add --all . && git commit -a -m "auto from org-git-add-commit" && git push
fi
