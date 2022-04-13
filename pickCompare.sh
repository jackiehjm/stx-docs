#!/usr/bin/env bash

RED='\033[0;31m'
GR='\033[0;32m'
NC='\033[0m' # No color

today=$(date '+%Y-%m-%d')
default_start="2020-01-01"

config_file=".pickOptions.sh"

export COLUMNS=80
IFS=$'\n'

echo -e "`cat <<EOF
${GR}
-----------------------------------------------------------------------------
Find pending cherry-picks by comparing commits on two branches.

The following conditions must be met:

* Pick notation must be used at the end of the subject line. E.g.

  \"IPv4 6 min max address ranges (dsR6, r5)\"

* The subject line must not change between the initial commit and the pick.

* The branch you want to compare with must be a remote of the one you are in.

* Both branches must be up-to-date. ('repo sync', 'git fetch --all' etc)
-----------------------------------------------------------------------------
${NC}
EOF`"


get_branches () {

  local refs="refs\/remotes"

  echo -e "Select the two branches you want to compare:\n"

  for branch in br1 br2
  do

    select br in $(git for-each-ref --format='%(refname)' refs/remotes | sed -E "s/^\s*($refs\/gerrit|$refs\/m|$refs\/wrs|$refs\/origin\/HEAD).*$//g" | sed -E 's/^refs\/remotes\///g')
    do

    br=${br/  /}
    br=${br%%*( )}

      case $br in

        "")
          echo "Invalid entry"
          continue
        ;;
        *)
          declare -g ${branch}="$br"
          break
        ;;
      esac

    done
  done
  if [[ "$br1" == "$br2" ]]; then
     echo -e "\n${RED}Comparing $br1 with itself makes no sense. Please pick two branches.${NC}\n"
     get_branches
  fi
}

get_dates () {

  echo -e "Select a date range\n"

  for date in begin end
  do

    while :
    do

      if [[ $date == "begin" ]]; then display_date=$default_start; else display_date=${today}; fi

      read -e -p "Enter $date date or ENTER for $display_date (yyyy-mm-dd): " edate

      case $edate in

        "")
          if [[ $date == "begin" ]]; then
            declare -g ${date}=${default_start}
          else
            declare -g ${date}=${today}
          fi
          break
        ;;
        *)
          if ! date -d $edate > /dev/null; then
             echo -e "${RED}$edate is not valid. Try again.${NC}"
             continue
          else          
             declare -g ${date}=$edate
             break
          fi
        ;;

      esac
    done
  done
}

get_users () {

  echo -e "Select users\n"

  for auth in auth1 auth2
  do

    if [[ $auth == "auth1" ]]; then
       repo=$br1
    else
       repo=$br2
    fi

    echo -e "Optionally, select a ${GR}$repo${NC} author to filter by:\n"

    select os in $(git log --pretty=format:%an --after="$begin" --before="$end" $repo  | sort | uniq; echo "None")
    do

      case $os in

        None)
          echo "No author selected, will show all authors."
          declare -g ${auth}=""
          break
        ;;
        *)
          declare -g ${auth}="$os"
          break
        ;;
      esac
    done
    # if [[ ${auth}=="" ]]; then break; fi
  done
}

get_pick () {

  read -e -p 'Optional string to filter on in (pick list): ' str

}

confirm_options () {

  read -n 1 -s -r -p "Press any key to continue or CTL-C to quit"
  echo -e "\n\n"

}

compare_branches () {

  for pick in $({ git log --pretty=format:%s%n --after="$begin" --before="$end" --author="$auth1" $br1 & git log --pretty=format:%s%n --after="$begin" --before="$end" --author="$auth2" $br2; } | grep "(.*$str.*)$" | sort | uniq -u); do
    echo -e "${RED}" $(git log --grep=$pick --date=format:'%Y-%m-%d %H:%M:%S' --pretty=format:"%cd, %s [ %h ]" --after=$begin --before=$end --author=$auth1 --author=$auth2 $br1 $br2) "${NC}"
  done

}

save_settings () {

  echo -e "`cat <<EOF

  First Branch:         $br1
  Second Branch:        $br2
  First Branch Author:  $auth1
  Second Branch Author: $auth2
  Start Date:           $begin
  End Date:             $end
  Pick Search String:   $str

EOF`"

  read -p 'Save your options for reuse [y/n]: ' -n1 save_opts;

  case $save_opts in

  y|Y)

    echo -e "`cat <<EOF
br1="$br1"
br2="$br2"
auth1="$auth1"
auth2="$auth2"
begin="$begin"
end="$end"
str="$str"

EOF`" > $config_file

    echo " ... saved"

  ;;

  *)
     echo " ... not saved"
  ;;

  esac

}

read_settings () {

  if [[ -f ${config_file} ]]; then

    echo -e "\nFound saved options:\n"

    values=$(<$config_file)

    values=${values/br1=/"First Branch: "}
    values=${values/br2=/"Second Branch: "}
    values=${values/auth1=/"First Author: "}
    values=${values/auth2=/"Second Author: "}
    values=${values/begin=/"Start Date: "}
    values=${values/end=/"End Date: "}
    values=${values/str=/"Pick Search String: "}

    echo -e "$values\n"

    read -p 'Reuse these options now? [y/n]: ' -n1 read_opts;

    case $read_opts in

    Y|y)
       CONTEXT_DIR="${BASH_SOURCE%/*}"
       if [[ ! -d "$CONTEXT_DIR" ]]; then CONTEXT_DIR="$PWD"; fi
       . "$CONTEXT_DIR/$config_file"
        echo " ... read"
    ;;
    *)
        echo " ... not read"
    ;;
    esac

  fi
}

read_settings

if [ -z ${br1+x} ] || [ -z ${br2+x} ]; then get_branches; fi

if [ -z ${begin+x} ] || [ -z ${end+x} ]; then get_dates; fi

if [[ ! $read_opts == [yY] ]]; then

  get_users
  get_pick
  save_settings

fi

confirm_options
compare_branches
