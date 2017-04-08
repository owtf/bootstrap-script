#!/bin/bash
# AUTHOR: 'Viyat Bhalodia'

# =============================================================
#  COLORS
# =============================================================

# COLORS {{{
Bold=$(tput bold)
Underline=$(tput sgr 0 1)
Reset=$(tput sgr0)
# Regular Colors
Red=$(tput setaf 1)
Green=$(tput setaf 2)
Yellow=$(tput setaf 3)
Blue=$(tput setaf 4)
Purple=$(tput setaf 5)
Cyan=$(tput setaf 6)
White=$(tput setaf 7)
# Bold
BRed=${Bold}$(tput setaf 1)
BGreen=${Bold}$(tput setaf 2)
BYellow=${Bold}$(tput setaf 3)
BBlue=${Bold}$(tput setaf 4)
BPurple=${Bold}$(tput setaf 5)
BCyan=${Bold}$(tput setaf 6)
BWhite=${Bold}$(tput setaf 7)
#}}}

# =============================================================
# FUNCTIONS
# =============================================================
print_line() {
  printf "%$(tput cols)s\n"|tr ' ' '*'
}

prompt_sudo() {
  [ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
}

print_title() {
  clear
  print_line
  echo -e "# ${Bold}$1${Reset}"
  print_line
  echo ""
}

print_info() {
  #Console width number
  T_COLS=`tput cols`
  echo -e "${Bold}$1${Reset}\n" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
}

print_warning() {
  T_COLS=`tput cols`
  echo -e "${BYellow}$1${Reset}\n" | fold -sw $(( $T_COLS - 1 ))
}

print_danger() {
  T_COLS=`tput cols`
  echo -e "${BRed}$1${Reset}\n" | fold -sw $(( $T_COLS - 1 ))
}

check_git() {
  #Depending on the return value $? you can assume git is installed or not.
  #If you get 0 everything is fine otherwise git is not installed. You can also test this.
  #This assumes everything is setup correctly and git is in your $PATH and the git command is not renamed.
  #http://stackoverflow.com/questions/7292584/how-to-check-if-git-is-installed-from-bashrc
  git --version 2>&1 >/dev/null
  GIT_IS_AVAILABLE=$?
  if [ $GIT_IS_AVAILABLE -ne 0 ]; then
    echo "${BRed}Error - ${White}It seems git is not installed on your system. Please install and run the script again."
    exit 1
  fi
}

Install() {
  python install/install.py
}

clean_up() {
  # Perform program exit housekeeping
  # Optionally accepts an exit status
  rm -f $1
  exit
}

pause(){
  read -p "$*"
}

# =============================================================
#  CONSTANTS
# =============================================================
dev=https://github.com/owtf/owtf.git
latest_release=https://github.com/owtf/owtf/archive/v2.1a.tar.gz
tikka_masala=https://github.com/owtf/owtf/archive/v2.0a.tar.gz
scriptdir=$(dirname $0)

# =============================================================
#  START OF THE MAIN SCRIPT
# =============================================================

main(){
  clear
  print_title "${BWhite}Welcome to the OWTF quick installation\n"
  print_warning " OWTF requires minimum of 60 MiB space for a minimal installation and sudo access, please make sure you have enough space on your partition."
  check_git
  prompt_sudo
  print_line
  echo -e "${BCyan}The script can be cancelled at any time with CTRL+C \n"
  echo -e  "${BYellow}Select your OWTF version: "
  # options parsing
  options=("OWTF 2.1a Chicken Korma"
    "OWTF 2.0a Tikka Masala"
    "OWTF develop branch"
    "Quit"
  )
  select opt in "${options[@]}"
  do
    case $opt in
      "OWTF 2.1a Chicken Korma")
        print_info " Fetching the source code and starting installation process.."
        wget $latest_release; tar xvf $(basename $latest_release); rm -f $(basename $latest_release) 2> /dev/null
        mv owtf-2.1a owtf/; cd owtf/
        Install
        break
      ;;
      "OWTF 2.0a Tikka Masala")
        print_info " Fetching the source code and starting installation process.."
        wget $tikka_masala; tar xvf $(basename $tikka_masala); rm -f $(basename $tikka_masala) 2> /dev/null
        mv owtf-2.0a owtf/; cd owtf/
        Install
        break
      ;;
      "OWTF develop branch")
        print_info " Fetching repository and starting installation process.."
        git clone -b develop $dev; cd owtf/
        Install
        break
      ;;
      "Quit")
        print_info " If you wish to install OWTF later, please run this script again.."
        break
      ;;
      *)
        echo -e " Invalid option. Try again."; continue ;;
    esac
  done
}

main
