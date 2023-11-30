#!/usr/bin/env bash

# Read a file (typlically source/shared/abbrevs.txt) and report on duplicate
# entries

. $(pwd)/_utils.sh
if [[ -z ${utils_loaded+x} ]]; then echo "Could not load utilities"; exit 1; fi

declare ABBREVS="doc/source/shared/abbrevs.txt"
# declare ABBREVS=".stx-docs/doc/source/shared/abbrevs.txt" # for testing

message "Checking for duplicate acronyms ..."

# acro_keys: array of anchor strings
# acro_keyvals: hash of anchors/definitions
get_abbrs "${ABBREVS}"

# Check for duplicate anchors in :abbr: defs. We've had problems with these
# in the past.
dup_count=$(check_abbr_dups "${acro_keys[@]}")

[[ $dup_count -gt 0 ]] && error "Duplicate(s) MUST be fixed in $ABBREVS"

confirmation "... Done"