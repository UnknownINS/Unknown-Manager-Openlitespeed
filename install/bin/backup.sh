#!/bin/bash

verifyAutoBackup() {
  if [ ! -f /usr/bin/rclone ]; then
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

  rm -rf $BACKUP_DIR/$GETDAY

  textYellow "----------------> START BACKUP DATABASE MYSQL"

  mkdir -p "$BACKUP_DIR/$GETDAY/mysql"

  backupDatabase $BACKUP_DIR/$GETDAY/mysql

  textYellow "----------------> END BACKUP DATABASE MYSQL"


  textYellow "----------------> START BACKUP CODE"

  zip -r $BACKUP_DIR/$GETDAY/backup.zip $UNKNOWN_DIR/* -q


  textYellow "----------------> BACKUP SUCCESS"

}

backupDriver() {

  if [ -z "$RCLONE_NAME" ]; then
    textRed "----------------> RCLONE NOT CONFIG"
    exit
  fi

  verifyAutoBackup

  GETDAY=$(date +"%F")

  rm -rf $BACKUP_DIR/$GETDAY &>/dev/null

  backupLocal

  textYellow "----------------> START UPLOAD GOOGLE DRIVE"

  rclone --transfers=1 move $BACKUP_DIR/$GETDAY "$RCLONE_NAME:$GET_IP_NAME/$GETDAY" &>/dev/null

  rm -rf $BACKUP_DIR/$GETDAY &>/dev/null

  textMagenta "----------------> END UPLOAD GOOGLE DRIVE"


}
