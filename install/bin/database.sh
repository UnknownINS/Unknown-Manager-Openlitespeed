#!/bin/bash

verifyMariadb() {

  if [ ! -f $MYSQL_BIN ]; then
    textRed "Mariadb Error.Please try again later"
    exit
  fi

  if [ $MYSQL_USER == '' || $MYSQL_PASSWORD == '' ]; then
  textRed "You Have Not Configured WebServer"
  echo ''
  exit
  fi
}

MariadbSecure() {

  verifyMariadb

  echo ''

  textYellow "----------------> MARIADB SECURITY"

  mysql_secure_installation

  sudo systemctl restart mariadb &>/dev/null

  echo ""

  textMagenta "_____________ MARIADB SECURITY SUCCESS ____________"

  echo ''
}

uninstallMariaDb() {

  cd "/" || exit

  echo ''

  textYellow "----------------> UNINSTALL MARIADB"

  echo ''

  verifyMariadb

  sudo apt-get purge mariadb* -y

  sudo apt --fix-broken install &>/dev/null

  sudo apt --fix-broken install &>/dev/null

  textMagenta "_____________ UNINSTALL MARIADB SUCCESS ____________"
  echo ''

}

createDatabase() {
  verifyMariadb
  $MYSQL_BIN --user=$MYSQL_USER -p`$MYSQL_PASSWORD` -e "CREATE DATABASE $1;"
}

deleteDatabase() {
  verifyMariadb
  $MYSQL_BIN --user=$MYSQL_USER -p`$MYSQL_PASSWORD` -e "DROP DATABASE $1;"
}


backupDatabase() {

  mkdir -p $1

  databases=$($MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

  for db in $databases; do

    $MYSQL_DUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip >"$1/$db.sql.gz"

  done

}
