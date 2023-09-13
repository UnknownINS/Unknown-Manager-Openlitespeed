#!/bin/bash

uninstallUnknownOLS() {

  echo ''

  sudo rm -rf $APP_INSTALL &>/dev/null

  textMagenta "----------------> UNINSTALL SUCCESS"

  echo ''

  exit
}

updateUnknownOLS() {

  cd /usr/local || exit

  sudo rm -rf $APP_INSTALL &>/dev/null

  git clone https://github.com/UnknownINS/Unknown-Manager-Openlitespeed.git && cd Unknown-Manager-Openlitespeed && bash install.sh &>/dev/null

  cd /usr/local || exit

  rm -rf Unknown-Manager-Openlitespeed

  echo ''

  textMagenta "----------------> UPDATE SUCCESS"

  echo ''

  exit

}

killApt() {
  sudo killall apt apt-get &>/dev/null
  sudo rm /var/lib/apt/lists/lock &>/dev/null
  sudo rm /var/cache/apt/archives/lock &>/dev/null
  sudo rm /var/lib/dpkg/lock* &>/dev/null
}

getAllDomain() {

  ALLDOMAIN=$(dir $UNKNOWN_DIR)

  cd $UNKNOWN_DIR || exit

  for i in $ALLDOMAIN; do

    if [ $i != "localhost" ]; then
      textYellow "----> $i"
      echo ''
    fi

  done

}

verifyExitDir() {

  if [ -d $1 ]; then
    textRed "Folder exist."
    echo ''
    exit
  fi

}


verifyDir() {

  if [ ! -d $1 ]; then
    textRed "Folder not exist."
    echo ''
    exit
  fi

}


updateSystem() {

  textBlue "----------------> UPDATE SYSTEM"

  sudo apt-get purge needrestart -y &>/dev/null

  sudo apt autoremove -y &>/dev/null

  sudo apt update -y

  textBlue "----------------> UPGRADE SYSTEM"

  echo ''

  sudo apt upgrade -y

  textBlue "----------------> INSTALL DEFAULT SYSTEM"

  echo ''

  sudo apt install snapd -y &>/dev/null

  sudo apt install zip unzip -y &>/dev/null

  textBlue "----------------> AUTO CLEAN SYSTEM"

  sudo apt autoremove -y &>/dev/null

  sudo apt autoclean -y &>/dev/null

  echo ""
}
