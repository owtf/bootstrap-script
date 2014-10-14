#!/bin/bash
# owtf is an OWASP+PTES-focused try to unite great tools and facilitate pen testing
# Copyright (c) 2014, Abraham Aranguren <name.surname@gmail.com> Twitter: @7a_ http://7-a.org
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# * Neither the name of the <organization> nor the
# names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# __author__ = 'Viyat Bhalodia'

# LOGS
LOGGER=/usr/bin/logger

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
  cd install/; python2 install.py
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
dev=https://github.com/owtf/owtf/archive/lions_2014.zip
stable=https://github.com/owtf/owtf/archive/v1.0.1.tar.gz
scriptdir=$(dirname $0)


# =============================================================
#  START OF THE MAIN SCRIPT
# =============================================================

main(){
  clear
  print_title "${BWhite}Welcome to the OWTF quick installation\n"
  print_warning " OWTF requires minimum of 60 MiB space for a minimal installation, please make sure you have enough space on your partition."
  check_git
  print_line
  echo -e "${BCyan}The script can be cancelled at any time with CTRL+C \n"
  echo -e  "${BYellow}Select your OWTF version: "
  # options parsing
  options=("OWTF 1.0.1 Lionheart"
           "OWTF 1.0.1 (bleeding-edge)"
           "Quit"
        )
  select opt in "${options[@]}"
  do
      case $opt in
          "OWTF 1.0.1 Lionheart")
            print_info " Fetching the source code and starting installation process"
            print_info " Make sure you have sudo access."
            wget $stable; tar xvf $(basename $stable); rm -f $(basename $stable) 2> /dev/null
            mv owtf-1.0.1 owtf/; cd owtf/
            Install
            ;;
          "OWTF 1.0.1 (bleeding-edge)")
            print_info " Fetching repository and starting installation process"
            print_info " Make sure you have sudo access."
            wget $dev; unzip $(basename $dev); rm -f $(basename $dev) 2> /dev/null
            mv owtf-lions_2014/ owtf/; cd owtf/
            Install
            ;;
          "Quit")
              break
              ;;
          *) echo -e "Invalid option. Try another one."; continue ;;
      esac
  done
}

main
