#!/bin/bash

installPhpmyadmin() {

  if [ -d "$UNKNOWN_DIR/localhost/html/sqlAdminManager" ]; then
    echo ''
    textMagenta "____________________ EXITS PHPMYADMIN ____________________"
    echo ''
  else
    textYellow "_______________________ DOWNLOAD PHPMYADMIN _______________________"
    mkdir -p "$UNKNOWN_DIR/localhost/html"
    cd "$UNKNOWN_DIR/localhost/html" || exit
    curl -o phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip
    unzip phpmyadmin.zip &>/dev/null
    mv phpMyAdmin-5.2.1-all-languages sqlAdminManager
    rm phpmyadmin.zip
    echo ""
    restartWebserver
    chown -R nobody:nogroup "$UNKNOWN_DIR/localhost/html/sqlAdminManager"
    textMagenta "____________________ SUCCESS INSTALL _____________________"
    echo "URL PHPMYADMIN : http://$GET_IP_NAME/sqlAdminManager"
    cd "$UNKNOWN_DIR" || exit
  fi
  echo ""

  cd $UNKNOWN_DIR || exit

}
