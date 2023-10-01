#!/bin/bash

installWebServer() {

  notificationInstall

  mkdir -p $UNKNOWN_DIR

  cd "$UNKNOWN_DIR" || exit

  installLibraryWebServer

  textYellow "----------------> INSTALL MARIADB"


  UP=$(pgrep mariadb | wc -l)

  if [ "$UP" -ne 1 ]; then
    sudo apt install mariadb-server -y &>/dev/null
    sudo systemctl start mariadb &>/dev/null
  fi

  textYellow "----------------> INSTALL OPENLITESPEED"

  wget -O - https://repo.litespeed.sh | sudo bash &>/dev/null

  updateSystem

  sudo apt-get install openlitespeed -y &>/dev/null

  verifyExitOpenLiteSpeed

  systemctl start lsws &>/dev/null


  cleanVhostsDefault

  createVirtualHost "localhost"

  updateHTTPConfig

  systemctl start lsws &>/dev/null

  systemctl restart lsws &>/dev/null

  textYellow "----------------> INSTALL PHP8.1 FOR OPENLITESPEED"

  sudo apt-get install lsphp81 lsphp81-common lsphp81-curl lsphp81-mysql lsphp81-opcache lsphp81-imap lsphp81-opcache -y &>/dev/null

  systemctl start lsws &>/dev/null

  disableFirewall

  textMagenta "----------------> INSTALL WEBSERVER SUCCESS"

  echo "ADMIN OPENLITESPEED : $GET_IP_NAME:7080"

  systemctl restart lsws

}

installLibraryWebServer() {

  updateSystem

  textYellow "----------------> INSTALL SSL/HTTPS"

  sudo snap install --classic certbot &>/dev/null

  textYellow "----------------> INSTALL LIBRARY WEBSERVER"

  curl https://rclone.org/install.sh | sudo bash &>/dev/null

  textYellow "----------------> INSTALL WORDPRESS TOOL"

  sudo apt install php8.1-cli php8.1-common php8.1-curl php8.1-mbstring php8.1-mysql php8.1-xml -y &>/dev/null

  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &>/dev/null

  chmod +x wp-cli.phar

  sudo mv wp-cli.phar /usr/local/bin/wp &>/dev/null

  sudo wp cli update &>/dev/null

  sudo apt autoremove -y &>/dev/null

  sudo apt autoclean -y &>/dev/null

}
