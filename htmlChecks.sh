#!/bin/bash
#
# Post-build checks on HTML go here.

RED='\033[0;31m'
NC='\033[0m' # No Color

cd doc/build

# 1. Check for rST formatting issues that don't cause build warnings/errors
echo "Checking for \"grey bar\" formatting errors in output ..."
GREY_FILES=( $(grep -rl --include="*.html" "blockquote" .) )
if [ ${#GREY_FILES[@]} != 0 ]; then
    echo "Found ${#GREY_FILES[@]} file(s):"
    for FILE in ${GREY_FILES[@]};
    do
        echo -e "${RED}$FILE${NC}"
    done
    echo "Using a browser, locate vertical grey bars in the left margin of the above file(s), then correct the issue(s) in the cooresponding rST file(s)."
    # Set -W to halt tox
    if [[ $1 == "-W" ]]; then
        exit 1
    fi
fi

# 2. do - check for emdash before option (missing backticks)