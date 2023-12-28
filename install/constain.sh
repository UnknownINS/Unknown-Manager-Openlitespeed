#!/bin/bash
export LSWS_DIR=/usr/local/lsws

export UNKNOWN_DIR=/home/unknown

export LSWS_CONFIG=$LSWS_DIR/conf

export LSWS_VHOSTS=$LSWS_CONFIG/vhosts

export LSWS_CONFIGPHP=$LSWS_DIR/lsphp81/etc/php/8.1/litespeed/php.ini

export GET_IP_NAME=$(curl -sS http://ipinfo.io/ip)

export MYSQL_BIN=/usr/bin/mysql

export MYSQL_DUMP=/usr/bin/mysqldump

mkdir -p $UNKNOWN_DIR &>/dev/null

export RESTORE_DIR=/home/restore

rm -rf $RESTORE_DIR/* &>/dev/null

mkdir -p $RESTORE_DIR &>/dev/null


setVariablesSystem() {

  if [ -f ~/.constain ]; then
    source ~/.constain
  else
    touch ~/.constain
    chmod 777 ~/.constain
    cat >~/.constain <<EOF
export MYSQL_USER=''
export MYSQL_PASSWORD=''
export RCLONE_NAME=''
export FOLDER_NAME_REMOTE=''
export FTP_NAME=''
export BACKUP_DIR='/home/backup'
EOF
  fi

mkdir -p $BACKUP_DIR &>/dev/null

}

verifyConstainDatabase() {

  if [[ -z "$MYSQL_USER" ]] || [[ -z "$MYSQL_PASSWORD" ]]; then
    textRed "----------------> PLEASE CHECK CONFIG AGAIN"
    exit
  fi
}

configWebServer() {
  echo "----------------> CONFIG WEBSERVER"

  read -p "----------------> INPUT MARIADB USER ( * ) : " MYSQL_USER

  read -p "----------------> INPUT MARIADB PASSWORD ( * ) : " MYSQL_PASSWORD

  read -p "----------------> INPUT RCLONE NAME : " RCLONE_NAME

  read -p "----------------> INPUT FOLDER NAME REMOTE BACKUP : " FOLDER_NAME_REMOTE

  read -p "----------------> DIRECTORY LOCAL BACKUP ( * ) : " BACKUP_DIR

  read -p "----------------> INPUT ACCOUNT ROOT ( * ) : " FTP_NAME



  if [[ -z "$MYSQL_USER" ]] || [[ -z "$MYSQL_PASSWORD" ]] || [[ -z "$FTP_NAME" ]] || [[ -z "$BACKUP_DIR" ]]; then
    textRed "----------------> PLEASE CHECK CONFIG AGAIN"
    exit
  fi

  cat >~/.constain <<EOF
export MYSQL_USER=$MYSQL_USER
export MYSQL_PASSWORD=$MYSQL_PASSWORD
export RCLONE_NAME=$RCLONE_NAME
export FOLDER_NAME_REMOTE=$FOLDER_NAME_REMOTE
export FTP_NAME=$FTP_NAME
export BACKUP_DIR=$BACKUP_DIR
EOF

  textMagenta "----------------> CONFIG SUCCESS"

  exit
}
