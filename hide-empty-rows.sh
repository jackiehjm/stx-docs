#!/usr/bin/env bash

# strip empty rows from HTML output tables. Max width 10 columns.
# |hide-empty-rows| must be present in corresponding rst file.

. $(pwd)/_utils.sh
if [[ -z ${utils_loaded+x} ]]; then echo "Could not load utilities"; exit 1; fi

if [ "$#" -ne 1 ]; then
    error "Usage: $0 <htmlPath>"
elif [[ ! -e "$1" ]]; then
    error "$0: Directory \"$1\" not found"
fi

declare htmlPath=$1
declare flag="post-build-hide-empty-table-rows"
declare td="\n*<td>[\n\s]*</td>\n*"
declare td_p=${td}

message "Cleaning up empty table rows in flagged files"

declare flagged_files=( $(grep -rl --include="*.html" "${flag}" ${htmlPath}) )

for _html in ${flagged_files[@]}; do

  confirmation "... $_html"

  sed -i -E -e ':a;N;$!ba;s/\n(<\/tr>)/\1/g' ${_html}
  sed -i -E -e ':a;N;$!ba;s/\n(<td><\/td>+)(<\/tr>)/\1\2/g' ${_html}

  # sed has no non-greedy mode
  for i in {1..10}; do
     sed -i -E "s:^<tr class=(\"row-odd\"|\"row-even\")>${td_p}</tr>::g"  ${_html}
     td_p="$td_p$td"
  done

  # sed -i -E "s:^<tr class=\"row-odd\">(<td></td>+)(</tr>):<tr hidden>\1\2:g" ${_html}
done

confirmation "... Done"