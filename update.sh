#!/bin/bash

SHOULD_PUSH=false
if [[ "$1" == "--push" ]]; then
    SHOULD_PUSH=true
fi

echo '##############################################################################################'
echo 'Updating README...'
echo "# Project Resume" > README.md
echo "This repo contains submodules pointing to my research projects for various courses at the University Of Tennessee." >> README.md
echo "">> README.md
echo "The following are links to the individual projects:" >> README.md

echo '##############################################################################################'
echo 'Updating submodules...'
git pull
git submodule update --init --recursive
path=$(pwd)
cat .gitmodules | grep "path" | awk '{print $3}' | while read line
do
    cd $line

    echo '##############################################################################################'
    echo "Pulling newest commits for: $line"
    git checkout main
    git pull

    echo "Updating README.md"
    url=`git config --get remote.origin.url | sed 's/git@github\.com:/https:\/\/github\.com\//' | sed 's/\.git//'`
    echo "URL: $url"
    echo "- [$line]($url)" >> $path/README.md

    echo "Executing update.sh"
    if [[ $SHOULD_PUSH == true ]]; then
        ./update.sh --push
    else
        ./update.sh
    fi

    cd $path
done
echo '##############################################################################################'

if [[ $SHOULD_PUSH == true ]]; then
    git add *
    git commit -m "Update All Projects"
    git push
    echo '##############################################################################################'
fi
