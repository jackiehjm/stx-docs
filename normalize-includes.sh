#!/usr/bin/env bash

. $(pwd)/_utils.sh
if [[ -z ${utils_loaded+x} ]]; then echo "Could not load utilities"; exit 1; fi

directive='pre-include::'
d_begin=':start-after:'
d_end=':end-before:'
inc_base='doc/source'


OIFS=$IFS; IFS=$'\n'
parents=( $(grep -Rl '.. pre-include:: ' --exclude-dir=docs/build --include="*.r*st" --exclude-dir='.*' doc/*) )
IFS=$OIFS

get_substr () {

  local _str=${1//\//\\/}
  local _drop=$2
  local _regex="$_drop\s+(.*)\s*$"
  message "${_str} =~ $_regex"

  if [[ "${str}" =~ "$_regex" ]]
  then
     message "Found ${BASH_REMATCH[1]}"
     echo "${BASH_REMATCH[1]}"
  else
     echo ""
  fi
}

get_inc_path () {
  local _ppath=$1
  local _inc=$2

  if [[ ${_inc::1} == "/" ]]; then
    echo "$inc_base$_inc"
  else
    echo "$(dirname $_ppath)/$_inc"
  fi
}

get_include_content () {
  local _inc_file=$1
  local _inc_start=$2
  local _inc_end=$3
  local _content

  check_file_deps $_inc_file

  if [[ $_inc_start != "" ]] && [[ $_inc_end != "" ]]; then
    _content=$(awk "/.. $_inc_start/{flag=1; next} /.. $_inc_end/{flag=0} flag" "$_inc_file" | sed -r "s/^\s*\.\. $_inc_end\s*$//g")
    # _content=$(sed -n '/\.\. $_inc_start/,/\.\. $_inc_end/{p;/\.\. $_inc_end/q}' $_inc_file)
  elif [[ $_inc_start == "" ]] && [[ $_inc_end == "" ]]; then
    _content=$(<$_inc_file)
  else
    error "Something went horribly wrong"
  fi
  echo "$_content"
}

## Run

for _f in "${parents[@]}"; do
  readarray -t _content < "$_f"
  for i in "${!_content[@]}"; do
    if [[ ${_content[i]} =~ $directive ]]; then
      _inc_file=$(trimspaces $(echo ${_content[i]} | sed -r 's|\s*\.\. pre-include::\s+||g'))
      message "found ${_content[i]}: $_l\nExtracted $_inc_file"
      if [[ ${_content[i+1]} =~ $d_begin ]]; then
        _inc_start=$(trimspaces $(echo ${_content[i+1]} | sed -r 's|\s*:start-after:\s+||g'))
        _inc_end=$(trimspaces $(echo ${_content[i+2]} | sed -r 's|\s*:end-before:\s+||g'))

        if [[ $_inc_end == "" ]]
        then
          error "start/end paramter mismatch in\n$_f\n Quiting"
          exit 1
        fi

        message "Extracted $_inc_start"
        message "Extracted $_inc_end"
        _content[i+1]=""
        _content[i+2]=""
      fi
      _inc_file=$(get_inc_path "$_f" "$_inc_file")
      _includestring=$(get_include_content $_inc_file $_inc_start $_inc_end)
      _content[i]="$_includestring"
    fi
    # ((_line=$_line+1))
  done
  for line in "${_content[@]}"; do out="$out\n$line"; done
  echo -e "${out//\\n/$'\n'}" > $_f
done
