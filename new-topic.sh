#!/usr/bin/env bash

if ! hash uuidgen 2>/dev/null; then
  echo >&2 "... uuidgen dependency not met. Please install."
  exit 1
fi

ask_name () {

   echo -e "`cat <<EOF

   You are about to create a new reStructuredText file in

   ${WD}

   If this is not what you want, press CTL-C to quit and change to the directory
   you want to create the file in.

   Enter a title for the new topic. The file name and topic label used for
   linking will be based on this value.


EOF`"


    while read -e -p 'Topic title: ' title ; do
      if [[ -z $title ]]; then
         continue
      else
         break
      fi
    done

}



ask_type () {

  echo -e "`cat <<EOF

  Thanks. Now choose a topic type. Enter one of the following characters:

    t) A task topic. Will contain the outline of a procedure.
    i) An index.
    r) A reference topic. Will contain a minimal list-table definition.
    g) A minimal generic topic.

EOF`"

    while read -p 'Topic type: ' -n1 input; do

       case $input in

           t|i|r|g)
              break
             ;;

           *)
             echo -e "Enter a valid value"
             continue
             ;;

        esac

    done

}

write_stub () {

   echo "$1" > "${WD}/${filename}.rst"
   if [[ -f ${WD}/${filename}.rst ]]; then
     echo -e "\nCreated ${WD}/${filename}.rst"
     exit 0
   else
     exit 1
   fi

}


WD=$1

myuuid=$(uuidgen)

# Keep as fallback?
# myuuid="$(od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}')"


myuuid="${myuuid:24:35}"

ask_name

strike=$(for ((i=1; i<=${#title}; i++)); do
  printf '=%.0s' "$i"
done)


ask_type

filename="${title//[^[:alnum:]]/-}"
filename=$(echo $filename | tr -s -)
filename=${filename,,}
filename="${filename}-${myuuid}"
filename=`sed 's/--/-/g' <<< $filename`
[ $input == "i" ] && filename="index-${filename}"

CONTEXT_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$CONTEXT_DIR" ]]; then CONTEXT_DIR="$PWD"; fi
. "$CONTEXT_DIR/templates/topic-templates.txt"

case $input in

   t)
     write_stub "${task}"
     ;;

   i)
     write_stub "${index}"
     ;;

   r)
      write_stub "${reference}"
      ;;

   g)
      write_stub "${topic}"
      ;;

   *)
      echo -e "$input not valid"
      ;;

esac


