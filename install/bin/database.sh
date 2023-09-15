#!/bin/bash

verifyMariadb() {

  if [ ! -f $MYSQL_BIN ]; then
    textRed "----------------> PLEASE CHECK MARIADB AGAIN"
    exit
  fi

  if [[ -z "$MYSQL_USER" ]] || [[ -z "$MYSQL_PASSWORD" ]]; then
    textRed "----------------> PLEASE CHECK CONFIG AGAIN"
    echo ''
    exit
  fi
}

MariadbSecure() {

  if [ ! -f $MYSQL_BIN ]; then
    textRed "----------------> PLEASE CHECK MARIADB AGAIN"
    exit
  fi

  echo ''

  textYellow "----------------> MARIADB SECURITY"

  mysql_secure_installation

  sudo systemctl restart mariadb &>/dev/null

  echo ""

  textMagenta "----------------> MARIADB SECURITY SUCCESS"

  echo ''
}

uninstallMariaDb() {

  cd "/" || exit

  echo ''

  textYellow "----------------> UNINSTALL MARIADB"

  echo ''

  sudo apt-get purge mariadb* -y

  sudo apt --fix-broken install &>/dev/null

  sudo apt --fix-broken install &>/dev/null

  textMagenta "----------------> UNINSTALL MARIADB SUCCESS"
  echo ''

}

createDatabase() {
  $MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE $1;"
}

deleteDatabase() {
  $MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "DROP DATABASE $1;"
}

importDatabase() {
  $MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD $1 <$2
}

backupDatabase() {

  mkdir -p $1

  databases=$($MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

  for db in $databases; do

    $MYSQL_DUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip >"$1/$db.sql.gz"

  done

}
