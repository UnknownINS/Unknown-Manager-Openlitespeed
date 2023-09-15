#!/bin/bash

chownNobodyDomain() {
  echo ''
  read -p "----------------> Input Domain : " inputDomain
  echo ''
  if [ -z "$inputDomain" ]; then
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    echo ''
    exit
  fi
  chown -R nobody:nogroup $UNKNOWN_DIR/$inputDomain/html &>/dev/null
  textMagenta "----------------> PERMISSION FILE AND FOLDER PUBLIC FOR DOMAIN SUCCESS"
  echo ''
}
