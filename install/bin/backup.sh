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

  mkdir -p "$BACKUP_DIR"


  textYellow "----------------> START BACKUP WEBSITE"

    ALLDOMAIN=$(dir $UNKNOWN_DIR)

    cd $UNKNOWN_DIR || exit

    for i in $ALLDOMAIN; do

      if [ $i != "localhost" ]; then
        textYellow "----> BACKUP $i"

        mkdir -p "$BACKUP_DIR/$i/i$GETDAY"

        zip -r $BACKUP_DIR/$i/$GETDAY/$i.zip $i/* -q

        nameDatabase=$(sed "s/\./_/g" <<<"$i")

        customBackupDatabase $nameDatabase $BACKUP_DIR/$i/$GETDAY

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

  backupLocal

  textYellow "----------------> START UPLOAD GOOGLE DRIVE"

  rclone --transfers=1 move $BACKUP_DIR "$RCLONE_NAME:$FOLDER_NAME_REMOTE/$GET_IP_NAME" &>/dev/null

  textMagenta "----------------> END UPLOAD GOOGLE DRIVE"

}
