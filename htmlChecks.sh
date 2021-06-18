#!/bin/bash
#
# Post-build checks on HTML go here.

RED='\033[0;31m'
NC='\033[0m' # No Color

cd doc/build/html

# 1. Check for rST formatting issues that don't cause build warnings/errors
echo "Checking for \"grey bar\" formatting errors in output ..."
GREY_FILES=( $(grep -rl --include="*.html" "blockquote" .) )
if [ ${#GREY_FILES[@]} != 0 ]; then
    echo "Found ${#GREY_FILES[@]} HTML file(s) with greybar formatting issues:"
    for FILE in ${GREY_FILES[@]};
    do
        echo -e "${RED}$FILE${NC}"
    done
    echo "Using a browser, locate vertical grey bars in the left margin of the above file(s), then correct the issue(s) in the corresponding rST file(s)."
    error=1
fi

echo "Checking for \".. include::\" errors in output ..."
INCLUDE_FILES=( $(grep -rl --include="*.html" -e "start-after" -e "end-before" .) )
if [ ${#INCLUDE_FILES[@]} != 0 ]; then
    echo "Found ${#INCLUDE_FILES[@]} HTML file(s) with exposed \"start-after\" and \"end-before\" _include argument(s):"
    for FILE in ${INCLUDE_FILES[@]};
    do
        echo -e "${RED}$FILE${NC}"
    done
    echo "Correct the issue(s) in the corresponding rST file(s)."
    error=1
fi

# Set -W to halt tox
if [[ $1 == "-W" ]] && [[ ${error} -eq 1 ]]; then
    exit 1
elif [[ ${error} -ne 1 ]]; then
    echo "... OK"
fi
