#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Use: $0 branchA branchB"
    echo "Ex : $0 master firebird"
    echo "     Find commits in firebird and master that were not cherry-picked."
    exit 1
fi

cherries=$(git cherry -v $1 $2 | grep "^+" | awk '{print $2}' | xargs -n1 git show -s --pretty=format:"%s%n" | tr "[:lower:]" "[:upper:]" | awk '{print $1}')

for cherry in $cherries; do
    if [ -n "$(git log --grep=$cherry --oneline $1)" ] && [ -n "$(git log --grep=$cherry --oneline $2)" ] ; then
        printf "=== COMMITS FOR %s ===\n\n" $cherry
        printf "+++ %s +++\n" $1
        git log --grep=$cherry -s --date=short --pretty=format:"%h|%ad|%an|%s" $1
        printf "+++ %s +++\n\n" $1
        printf "+++ %s +++\n" $2
        git log --grep=$cherry -s --date=short --pretty=format:"%h|%ad|%an|%s" $2
        printf "+++ %s +++\n\n" $1
        printf "=== END %s ===\n\n\n" $cherry
    fi
done

