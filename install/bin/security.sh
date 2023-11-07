#!/bin/bash

securityDomain() {

  textYellow "----> $1"

  nameFTP=$(sed "s/\./_/g" <<<"$1")

  verifyNameFTP=$(sudo cat /etc/passwd | grep $nameFTP)

  if [[ -z "$verifyNameFTP" ]]; then
      chown -R $FTP_NAME $UNKNOWN_DIR/$1
    else
      chown -R $nameFTP::ftponly $UNKNOWN_DIR/$1
  fi

  cd $UNKNOWN_DIR/$1/html || exit

  find $UNKNOWN_DIR/$1/html -type d -exec chmod 755 {} \;

  find $UNKNOWN_DIR/$1/html -type f -exec chmod 644 {} \;

  if [ -d $UNKNOWN_DIR/$1/html/wp-content ]; then

      cd $UNKNOWN_DIR/$1/html/wp-content || exit

      chown -R nobody:nogroup $UNKNOWN_DIR/$1/html/wp-content

        if [[ -z "$verifyNameFTP" ]]; then
            chown -R $FTP_NAME plugins themes
            chown $FTP_NAME index.php
          else
            chown -R $nameFTP::ftponly plugins themes
            chown $nameFTP::ftponly index.php
        fi
  fi
    chown nobody:nogroup $UNKNOWN_DIR/$1/html
}

securityWebServer() {

  ALLDOMAIN=$(dir $UNKNOWN_DIR)

  textYellow "----------------> PROTECT WEBSITE"

  cd $UNKNOWN_DIR || exit

  for i in $ALLDOMAIN; do

    if [ $i == "localhost" ]; then

      chown -R nobody:nogroup $UNKNOWN_DIR/$i
    else
      securityDomain $i
    fi

  done

  cd $UNKNOWN_DIR || exit

}
