#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color

declare -a dirtyFiles

dirtyFiles=( $(git status --porcelain doc/source 2>/dev/null) )

echo "Checking status of doc/source"

if [ ${#dirtyFiles[@]} -ne 0 ]; then
    echo -e "${RED}Repo is dirty. Please stash, add or manually delete the following files:${NC}"
    for file in ${dirtyFiles[@]};
    do
        if [[ ${file} == "??" ]]; then continue; fi
        echo -e "${RED}$file${NC}"
    done
    exit 1
else
    echo "... OK"
fi