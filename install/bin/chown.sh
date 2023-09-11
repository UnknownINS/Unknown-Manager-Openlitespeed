#!/bin/bash

chownNobodyDomain() {
  echo ''
  read -p "----------------> Input Domain : " inputDomain
  echo ''
  chown -R nobody:nogroup $UNKNOWN_DIR/$inputDomain/html &> /dev/null
  textMagenta "----------------> PERMISSION FILE AND FOLDER PUBLIC FOR DOMAIN SUCCESS"
  echo ''
}