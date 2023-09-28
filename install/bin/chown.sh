#!/bin/bash

chownNobodyDomain() {

  read -p "----------------> Input Domain : " inputDomain
  if [ -z "$inputDomain" ]; then
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    exit
  fi
  chown -R nobody:nogroup $UNKNOWN_DIR/$inputDomain/html &>/dev/null

  find $UNKNOWN_DIR/$inputDomain/html -type d -exec chmod 755 {} \;

  find $UNKNOWN_DIR/$inputDomain/html -type f -exec chmod 644 {} \;

  textMagenta "----------------> PERMISSION FILE AND FOLDER PUBLIC FOR DOMAIN SUCCESS"
}
