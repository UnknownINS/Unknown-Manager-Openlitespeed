#!/bin/bash

securityDomain() {

  textYellow "----> $1"

  chown -R root:root $UNKNOWN_DIR/$1

  cd $UNKNOWN_DIR/$1/html || exit

  find $UNKNOWN_DIR/$1/html -type d -exec chmod 755 {} \;

  find $UNKNOWN_DIR/$1/html -type f -exec chmod 644 {} \;

  cd $UNKNOWN_DIR/$1/html/wp-content || exit

  chown -R nobody:nogroup $UNKNOWN_DIR/$1/html/wp-content

  chown -R root:root plugins themes

  chown root:root index.php


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
