#!/bin/bash
#
# Post-build checks on HTML go here.

RED='\033[0;31m'
NC='\033[0m' # No Color

cd doc/build/html

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
INCLUDE_FILES=( $(grep -rl --include="*.html" --exclude="doc_contribute_guide.html" -e "start-after" -e "end-before" .) )
if [ ${#INCLUDE_FILES[@]} != 0 ]; then
    echo "Found ${#INCLUDE_FILES[@]} HTML file(s) with exposed \"start-after\" and \"end-before\" _include argument(s):"
    for FILE in ${INCLUDE_FILES[@]};
    do
        echo -e "${RED}$FILE${NC}"
    done
    echo "Correct the issue(s) in the corresponding rST file(s)."
    error=1
fi

echo "Checking for unexpanded substitution errors in output ..."
INCLUDE_FILES=( $(grep -rl --include="*.html" --exclude="doc_contribute_guide.html" ' |\S\+| ' .) )
if [ ${#INCLUDE_FILES[@]} != 0 ]; then
    echo -e "Found ${#INCLUDE_FILES[@]} HTML file(s) that may have unexpanded substitution(s):\n${RED}"
    grep -r --include="*.html" --exclude="doc_contribute_guide.html" ' |\S\+| ' . | awk -F: '{if(f!=$1)print ""; f=$1; print $0;}'
    echo -e "${NC}\nCorrect the issue(s) in the corresponding rST file(s).\nHINT: Substitions are not allowed in code blocks, :ref:s,\n:doc:s, or within rST markup such as **, \`\`, and so on."
    error=1
fi

# Set -W to halt tox
if [[ $1 == "-W" ]] && [[ ${error} -eq 1 ]]; then
    exit 1
elif [[ ${error} -ne 1 ]]; then
    echo "... OK"
fi
