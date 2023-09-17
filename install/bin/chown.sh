#!/bin/bash

chownNobodyDomain() {
  read -p "----------------> Input Domain : " inputDomain
  if [ -z "$inputDomain" ]; then
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    exit
  fi
  chown -R nobody:nogroup $UNKNOWN_DIR/$inputDomain/html &>/dev/null
  textMagenta "----------------> PERMISSION FILE AND FOLDER PUBLIC FOR DOMAIN SUCCESS"
}
