#!/bin/bash

verifyAutoBackup() {
  if [ ! -f /usr/bin/rclone ]; then
    textRed "Auto Backup not Install.Please try again later"
    exit
  fi
}

configAutoBackup() {

  verifyAutoBackup

  textYellow "----------------> CONFIG AUTO BACKUP"

  echo ''

  rclone config

  echo ''
}

backupLocal() {

  verifyMariadb

  GETDAY=$(date +"%F")

  textYellow "----------------> BACKUP VPS"

  rm -rf $BACKUP_DIR/$GETDAY

  echo ''

  textYellow "----------------> START BACKUP DATABASE MYSQL"

  echo ''

  mkdir -p "$BACKUP_DIR/$GETDAY/mysql"

  backupDatabase $BACKUP_DIR/$GETDAY/mysql

  textYellow "----------------> END BACKUP DATABASE MYSQL"

  echo ''

  textYellow "----------------> START BACKUP CODE"

  zip -r $BACKUP_DIR/$GETDAY/backup.zip $UNKNOWN_DIR -q

  echo ''

  textYellow "----------------> BACKUP SUCCESS"

  echo ''

}


backupDriver() {

  if [ ! $RCLONE_NAME ]; then
    textRed "You Have Not Configured WebServer"
    exit
  fi

  verifyAutoBackup

  GETDAY=$(date +"%F")

  rm -rf $BACKUP_DIR/$GETDAY &>/dev/null

  backupLocal

  textYellow "----------------> START UPLOAD GOOGLE DRIVE"

  rclone --transfers=1 move $BACKUP_DIR/$GETDAY "$RCLONE_NAME:$GET_IP_NAME/$GETDAY" &>/dev/null

  echo ''

  rm -rf $BACKUP_DIR/$GETDAY &>/dev/null

  textMagenta "----------------> END UPLOAD GOOGLE DRIVE"

  echo ''

}
