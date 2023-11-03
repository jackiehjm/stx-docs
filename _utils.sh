
declare RED='\033[0;31m'
declare GR='\033[0;32m'
declare NC='\033[0m'

# Output functions. Colorize various types of messages. 
message () { echo -e "$@" 1>&2; }
confirmation () { message $GR$@$NC; }
warn () { message $RED$@$NC; }
error () { message $RED$@$NC; exit 1; }

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

declare utils_loaded=1