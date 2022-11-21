#!/usr/bin/env bash

# Fetch arbitrary files from a remote location for processing/
# inclusion in local build.

message () { echo -e "$@" 1>&2; }

usage_error () {
   message "\nUsage: $0 -c config-file -o <file|stdout> [-f -b]
   -c <config-file> contains fetch and save locations for files
   -o sets the output path to the save locations in <config-file> or to STDOUT
   -f optionally forces existing output files to be overwritten
   -b skips branch lookup. Use this if downloading from a non-git URL\n"
   exit 1
}

check_util_deps () {
  for dep in $@
  do
    if ! hash $dep 2>/dev/null; then
      message >&2 "... $dep dependency not met. Please install."
      exit 1
    fi
  done
}

check_file_deps () {
  for filereq in $@
  do
    if [ ! -f "${filereq}" ] && [ ! -L "${filereq}" ]; then message "${filereq}  not found. Quiting."; exit 1; fi
  done
}

load_configs () { 
  CONTEXT_DIR="${BASH_SOURCE%/*}"
  if [[ ! -d "$CONTEXT_DIR" ]]; then CONTEXT_DIR="$PWD"; fi
  . "$CONTEXT_DIR/$config_file"
  message "Loaded $CONTEXT_DIR/$config_file"
}

get_remote () {

  if [[ $no_branch = "t" ]]; then message "Branch ignored"; return; fi

  local regex_br="^defaultbranch\=(.*)\s*$"
  local _remote=$(grep defaultbranch $branch_file)

  if [[ "${_remote}" =~ $regex_br ]]
  then
     remote="${BASH_REMATCH[1]}/"
  else
     message "Can't find remote branch"; exit 1
  fi
  message "Remote is: $remote"
}


fetch_files () {
  for f in "${!remote_files[@]}"; do

    local _outfile

    case $out_method in

       "file")
         _outfile="$common_target${remote_files[$f]}"
         if [ ! -d $(dirname $_outfile) ]; then mkdir -p `dirname $_outfile`; fi
         ;;
       "stdout") 
         _outfile="-"
         ;;
       *)
         message "Should never get here!"; exit 1;
         ;;

    esac

    if [ -f $_outfile ] && [ ! "$force" = "t" ] && [ "$out_method" = "file" ]; then 
       message "$_outfile already exists, use \"-f\" to override. Quiting"
       usage_error
       exit 1
    fi

    wget -q -O $_outfile http://$remote_repo/$remote$f

    if [ $? -ne 0 ]; then 
       if [ ! -s $_outfile ]; then rm -f $_outfile; fi
       message "Could not download ${remote_files[$f]}. Quiting"
       exit 1
    fi

  done
}

while getopts "c:o:fb" flag
do
    case "${flag}" in

      c)
        config_file=$OPTARG
        ;;

      o) 
        case $OPTARG in

          file) out_method="file" ;;
          stdout) out_method="stdout" ;;
          *) usage_error ;;

        esac
        ;;

      f) force="t" ;;

      b) no_branch="t" ;;

      *) message "Unknown arg \"$flag\""; usage_error ;;

    esac
done

shift "$(( OPTIND - 1 ))"

if [ -z "$config_file" ] || [ -z "$out_method" ]
then
  message "ARGS CHECK FAILED"
  usage_error
fi

branch_file=".gitreview"

## Run

check_util_deps wget
check_file_deps $branch_file $config_file
declare -A remote_files && load_configs $config_file
get_remote
fetch_files
