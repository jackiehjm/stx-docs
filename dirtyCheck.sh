#!/bin/bash

. $(pwd)/_utils.sh
if [[ -z ${utils_loaded+x} ]]; then echo "Could not load utilities"; exit 1; fi

declare -a dirtyFiles

dirtyFiles=( $(git status --porcelain doc/source 2>/dev/null) )

message "Checking status of doc/source"

if [ ${#dirtyFiles[@]} -ne 0 ]; then
    warn "Repo is dirty. Please stash, add or manually delete the following files:\n"
    for file in ${dirtyFiles[@]};
    do
        if [[ ${file} == "??" ]]; then continue; fi
        if [[ ${file} == "M" ]]; then continue; fi
        warn "$file"
    done
    exit 1
else
    confirmation "... OK"
fi