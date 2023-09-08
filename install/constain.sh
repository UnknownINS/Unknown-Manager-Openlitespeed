#!/bin/bash
export LSWS_DIR=/usr/local/lsws

export UNKNOWN_DIR=/home/unknown

export LSWS_CONFIG=$LSWS_DIR/conf

export LSWS_VHOSTS=$LSWS_CONFIG/vhosts

export GET_IP_NAME=$(curl http://ipinfo.io/ip)

export MYSQL_BIN=/usr/bin/mysql

export MYSQL_DUMP=/usr/bin/mysqldump

export BACKUP_DIR=/home/backup

mkdir -p $BACKUP_DIR &>/dev/null

mkdir -p $UNKNOWN_DIR &>/dev/null

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

configWebServer() {

  echo "----------------> CONFIG WEBSERVER"

  echo ""

  read -p "----------------> INPUT MARIADB USER : " MYSQL_USER

  echo ""

  read -p "----------------> INPUT MARIADB PASSWORD : " MYSQL_PASSWORD

  echo ""

  read -p "----------------> INPUT RCLONE NAME : " RCLONE_NAME

  echo ""

  cat >~/.constain <<EOF
export MYSQL_USER=$MYSQL_USER
export MYSQL_PASSWORD=$MYSQL_PASSWORD
export RCLONE_NAME=$RCLONE_NAME
EOF

  textMagenta "----------------> CONFIG SUCCESS"

  echo ''

  exit
}

