#!/bin/bash
export LSWS_DIR=/usr/local/lsws

export UNKNOWN_DIR=/home/unknown

export LSWS_CONFIG=$LSWS_DIR/conf

export LSWS_VHOSTS=$LSWS_CONFIG/vhosts

export GET_IP_NAME=$(curl -sS http://ipinfo.io/ip)

export MYSQL_BIN=/usr/bin/mysql

export MYSQL_DUMP=/usr/bin/mysqldump

export BACKUP_DIR=/home/backup

mkdir -p $BACKUP_DIR &>/dev/null

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
EOF
  fi
}

verifyConstainDatabase() {

  if [[ -z "$MYSQL_USER" ]] || [[ -z "$MYSQL_PASSWORD" ]]; then
    textRed "----------------> PLEASE CHECK CONFIG AGAIN"
    exit
  fi
}

configWebServer() {
  echo "----------------> CONFIG WEBSERVER"

  read -p "----------------> INPUT MARIADB USER : " MYSQL_USER

  read -p "----------------> INPUT MARIADB PASSWORD : " MYSQL_PASSWORD


  read -p "----------------> INPUT RCLONE NAME : " RCLONE_NAME


  if [[ -z "$MYSQL_USER" ]] || [[ -z "$MYSQL_PASSWORD" ]]; then
    textRed "----------------> PLEASE CHECK CONFIG AGAIN"
    exit
  fi

  cat >~/.constain <<EOF
export MYSQL_USER=$MYSQL_USER
export MYSQL_PASSWORD=$MYSQL_PASSWORD
export RCLONE_NAME=$RCLONE_NAME
EOF

  textMagenta "----------------> CONFIG SUCCESS"

  exit
}
