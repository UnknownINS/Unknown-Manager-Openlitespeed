#!/bin/bash

verifyAutoBackup() {
  if [ ! -f /snap/bin/rclone ] && [ ! -f /usr/bin/rclone ]; then
  textRed "----------------> RCLONE NOT INSTALL"
    exit
  fi
}

configAutoBackup() {

  verifyAutoBackup

  textYellow "----------------> CONFIG AUTO BACKUP"

  rclone config
}

backupLocal() {

  verifyMariadb

  verifyConstainDatabase

  GETDAY=$(date +"%F")

  textYellow "----------------> BACKUP VPS"

  rm -rf $BACKUP_DIR/$GETDAY  &>/dev/null

  textYellow "----------------> START BACKUP DATABASE MYSQL"

  mkdir -p "$BACKUP_DIR/$GETDAY/mysql"

  backupDatabase $BACKUP_DIR/$GETDAY/mysql

  textYellow "----------------> END BACKUP DATABASE MYSQL"

  textYellow "----------------> START BACKUP CODE"

    ALLDOMAIN=$(dir $UNKNOWN_DIR)

    cd $UNKNOWN_DIR || exit

    for i in $ALLDOMAIN; do

      if [ $i != "localhost" ]; then
        textYellow "----> BACKUP $i"
        zip -r $i.zip $i/* -q
      fi

    done


  textYellow "----------------> BACKUP SUCCESS"

}

backupDriver() {

  if [ -z "$RCLONE_NAME" ]; then
    textRed "----------------> RCLONE NOT CONFIG"
    exit
  fi
  verifyAutoBackup
  verifyMariadb
  verifyConstainDatabase

  GETDAY=$(date +"%F")

  rm -rf $BACKUP_DIR/$GETDAY &>/dev/null

  backupLocal

  textYellow "----------------> START UPLOAD GOOGLE DRIVE"

  rclone --transfers=1 move $BACKUP_DIR/$GETDAY "$RCLONE_NAME:$FOLDER_NAME_REMOTE/$GET_IP_NAME/$GETDAY" &>/dev/null

  rm -rf $BACKUP_DIR/$GETDAY &>/dev/null

  textMagenta "----------------> END UPLOAD GOOGLE DRIVE"

}
