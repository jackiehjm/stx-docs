#!/bin/bash
#
# Post-build checks on HTML go here.

if [ -z ${1+x} ]; then echo "Usage: ./htmlChecks.sh <htmlPath>" && exit 0; fi

. $(pwd)/_utils.sh
if [[ -z ${utils_loaded+x} ]]; then echo "Could not load utilities"; exit 1; fi

htmlPath=$1

RED='\033[0;31m'
NC='\033[0m' # No Color

cd ${htmlPath} || { echo "Can't change to ${htmlPath}" && exit 0; }

echo "Checking for \"grey bar\" formatting errors in output ..."
GREY_FILES=( $(grep -rl --include="*.html" "blockquote" .) )
if [ ${#GREY_FILES[@]} != 0 ]; then
    warn "Found ${#GREY_FILES[@]} HTML file(s) with greybar formatting issues:"
    for FILE in ${GREY_FILES[@]};
    do
        warn "$FILE"
    done
    warn "Using a browser, locate vertical grey bars in the left margin of the above file(s), then correct the issue(s) in the corresponding rST file(s)."
    error=1
fi

echo "Checking for \".. include::\" errors in output ..."
INCLUDE_FILES=( $(grep -rl --include="*.html" -e "start-after" -e "end-before" .) )
if [ ${#INCLUDE_FILES[@]} != 0 ]; then
    warn "Found ${#INCLUDE_FILES[@]} HTML file(s) with exposed \"start-after\" and \"end-before\" _include argument(s):"
    for FILE in ${INCLUDE_FILES[@]};
    do
        warn "$FILE"
    done
    warn "Correct the issue(s) in the corresponding rST file(s)."
    error=1
fi

echo "Checking for unexpanded substitution errors in output ..."
SUBS_FILES=( $(grep -rlo --include="*.html" --exclude="doc_contribute_guide.html" '[>\s]|\S\+|[<\s]' .) )
if [ ${#SUBS_FILES[@]} != 0 ]; then
    warn "Found ${#SUBS_FILES[@]} HTML file(s) that may have unexpanded substitution(s):\n${RED}"
    grep -ro --include="*.html" --exclude="doc_contribute_guide.html" '[>\s]|\S\+|[<\s]' . | awk -F: '{if(f!=$1)print ""; f=$1; print $0;}'
    warn "\nCorrect the issue(s) in the corresponding rST file(s).\nHINT: Substitions are not allowed in code blocks, :ref:s,\n:doc:s, or with in rST markup such as **, \`\`, and so on."
    error=1
fi

# Set -W to halt tox
if [[ $2 == "-W" ]] && [[ ${error} -eq 1 ]]; then
    exit 1
elif [[ ${error} -ne 1 ]]; then
    confirmation "... OK"
fi
