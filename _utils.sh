
declare RED='\033[0;31m'
declare OG="\033[93m"
declare GR='\033[0;32m'
declare NC='\033[0m'

# Output functions. Colorize various types of messages. 
message () { echo -e "$@" 1>&2; }
confirmation () { message $GR$@$NC; }
warn () { message $OG$@$NC; }
error () { message $RED$0:$?: $@$NC; exit 1; }

# Check for and exit if file dependancies are not met. Takes a list of full or
# relative paths.
check_file_deps () {
  for filereq in $@
  do
    if [ ! -f "${filereq}" ] && [ ! -L "${filereq}" ]; then error "${filereq}  not found. Quiting."; exit 1; fi
  done
}

# Check for and exit if command dependancies are not met. Takes a list of 
# executables.
check_util_deps () {
  for dep in $@
  do
    if ! hash $dep 2>/dev/null; then
      error >&2 "... $dep dependency not met. Please install."
      exit 1
    fi
  done
}

# Creates an rST  title over/underscore string of the same length
# as the argument. Section strings are not supported. Returned output
# is a sequence of equal signs (=).
make_strike () {
  local _title="$1"
  local _strike
  _strike=$(for ((i=1; i<=${#_title}; i++)); do
    printf '=%.0s' "$i"
  done)
  echo $_strike
}

# Trim leading and trailing whitespaces from string.
trimspaces () {
  local _s=$1

  _s="${_s#"${_s%%[![:space:]]*}"}"
  _s="${_s#"${_s%%[![:space:]]*}"}"

  echo $_s
}

# Sets a global hash of acronyms and definitions from rst :abbr: defs. Also
# sets an array of hash keys to facilitate sorting.
#
# Takes path to the file to parse. Optional "1" flag as second option 
# suppresses plural forms such as "PVCs". 
get_abbrs () {

  local ABBREVS
  declare -a -g acro_keys
  declare -A -g acro_keyvals
  local regex=":abbr:\`([A-Za-z]+)\s+\((.*)\)\`"

  [[ ! -z ${1+x} ]] && [[ -e $1 ]] && ABBREVS="$1" \
     || error "Can't find abbrevs file $1"

  [[ ! -z $2{+x} ]] && [[ ${2} == "1" ]] \
     && local strip_plurals=$2

  while IFS= read -r line
  do
    if [[ $line =~ $regex ]]; then 
  
      if [[ ${strip_plurals} -eq 1 ]] && [[ ${BASH_REMATCH[1]:0-1} == "s" ]]; then
        message " Skipping pluralization \"${BASH_REMATCH[1]}\""
        continue
      fi
      acro_keys+=("${BASH_REMATCH[1]}")
      acro_keyvals["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
    fi
  done < "$ABBREVS" || error "Cannot read $ABBREVS"

}


# Report duplicate :abbr: anchor strings. (Duplicate placeholders cause 
# Sphinx warnings.)
#
# Takes an array of anchor strings. Echos duplicates and returns a duplicate
# count
check_abbr_dups () {

   local -a _anchors=("$@")
   declare -a dups; declare -i _dup_count=0
   IFS=$'\n'; dups=($(sort -f <<<"${_anchors[*]}")); unset IFS
   
   message "... Checking for duplicate anchor strings"
   
   for ((i=0; i < ${#dups[@]}; i++)); do
     if [[ ${dups[$i]} == ${dups[$i-1]} ]]; then 
       warn " Duplicate anchor string \"${dups[$i]}\" found"
       ((_dup_count=$_dup_count+1))
     fi
   done

   echo $_dup_count

}

declare utils_loaded=1