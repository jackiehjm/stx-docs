#!/usr/bin/env bash

# Replace DS strings in US usage of supported hardware table.

reqFiles=()

HW_versions="doc/build/html/planning/kubernetes/verified-commercial-hardware.html"
reqFiles+=("$HW_version")

for f in ${reqFiles[@]}; do
   if [[ ! -f $HW_versions ]]; then
      echo "$f not found. Quiting"; exit 1
   fi
done

declare -A strings
strings=(
         ["Studio Cloud Version"]="StarlingX Version"
         ["WRCP"]=""
         ["22.12"]="Release 8"
         ["22.06"]="Release 7"
         ["21.12"]="Release 6"
         ["21.05"]="Release 5"
         ["20.06"]="Release 4"
#         ['<div class="row">']='<div class="row" style="margin-left:-100px">'
         ['font-size: 16px;']='font-size: 13px;'
         ['class="reference internal"']='class="reference internal" style="font-size:9pt"'
         ['<h2>']='<h2 style="font-size:22pt">'
         ['<div class="custom-hw docutils container">']='<div class="custom-hw docutils container" style="font-size:10pt">'
         ['class="btn docs-sidebar-release-select">StarlingX Documentation']='class="btn docs-sidebar-release-select" style="font-size:10pt">StarlingX Documentation' 
         ['#1AADA4']='#2a4e68'
       )

echo "... tidying up $HW_versions"
for string in "${!strings[@]}"; do 
   sed -i "s/$string/${strings[$string]}/g" $HW_versions
done
