#!/usr/bin/env bash

for f in *.html
do
    if [[ $f =~ ([_a-zA-Z0-9]+).html ]]
    then
        html2text.py $f > ${BASH_REMATCH[1]}.md
    fi
done
