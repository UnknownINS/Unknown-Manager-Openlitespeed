#!/bin/bash

verifyMariadb() {

  if [ ! -f $MYSQL_BIN ]; then
    textRed "----------------> PLEASE CHECK MARIADB AGAIN"
    exit
  fi

  if [[ -z "$MYSQL_USER" ]] || [[ -z "$MYSQL_PASSWORD" ]]; then
    textRed "----------------> PLEASE CHECK CONFIG AGAIN"
    exit
  fi
}

MariadbSecure() {

  if [ ! -f $MYSQL_BIN ]; then
    textRed "----------------> PLEASE CHECK MARIADB AGAIN"
    exit
  fi

  textYellow "----------------> MARIADB SECURITY"

  mysql_secure_installation

  sudo systemctl restart mariadb &>/dev/null

  textMagenta "----------------> MARIADB SECURITY SUCCESS"

}

uninstallMariaDb() {

  cd "/" || exit

  textYellow "----------------> UNINSTALL MARIADB"

  sudo apt-get purge mariadb* -y

  sudo apt --fix-broken install &>/dev/null

  sudo apt --fix-broken install &>/dev/null

  textMagenta "----------------> UNINSTALL MARIADB SUCCESS"
}

FlushMYSQL(){
  $MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "FLUSH PRIVILEGES;";
}
GrantingSQLUserPermissions(){
  $MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON $1.* TO '$2'@'localhost' WITH GRANT OPTION;";
}

createUserDatabase(){
  $MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE USER '$1'@'localhost' IDENTIFIED BY '$2';"
}

deleteUserDatabase(){
    $MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "DROP USER '$1'@'localhost';"
}

createDatabase() {
  $MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE $1;"
}

deleteDatabase() {
  $MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "DROP DATABASE $1;"
}

importDatabase() {
  $MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD $1 < $2
}

backupDatabase() {
  mkdir -p $1
  databases=$($MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")
  for db in $databases; do
    $MYSQL_DUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip >"$1/$db.sql.gz"
  done
}

customBackupDatabase(){
  $MYSQL_DUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $1 | gzip >"$2/$1.sql.gz"
}

renameDataBase(){

  $MYSQL_DUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD -R $1 > "$RESTORE_DIR/$1.sql"

  createDatabase $2

  deleteDatabase $1

  importDatabase $2 "$RESTORE_DIR/$1.sql"

  rm -rf $RESTORE_DIR &> /dev/null
}

repairDatabases(){

  verifyMariadb

  databases=$($MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

  for db in $databases; do
    textYellow "----------------> CHECK AND REPAIR DATABASE $db"
    repairSingleDatabase $db
  done

}
repairSingleDatabase(){

    getTables=$($MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW TABLES FROM $1"  | grep -Ev "(Tables_in_$1)")

    for table in $getTables; do
      $MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "use $1;ALTER TABLE $table ENGINE = MyISAM;REPAIR TABLE $table;" &> /dev/null
    done
}
