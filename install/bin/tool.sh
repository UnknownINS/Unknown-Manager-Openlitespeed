#!/bin/bash

securityDomain() {

  textBlue "----> $1"

  chown -R root:root $UNKNOWN_DIR/$1

  cd $UNKNOWN_DIR/$1/html || exit

  find $UNKNOWN_DIR/$1/html -type d -exec chmod 755 {} \;

  find $UNKNOWN_DIR/$1/html -type f -exec chmod 644 {} \;

  cd $UNKNOWN_DIR/$1/html/wp-content || exit

  chown -R nobody:nogroup $UNKNOWN_DIR/$1/html/wp-content

  chown -R root:root plugins themes

  chown root:root index.php

  echo ""

}

securityWebServer() {

  ALLDOMAIN=$(dir $UNKNOWN_DIR)

  textYellow "----------------> PROTECT WEBSITE"

  echo ""

  cd $UNKNOWN_DIR || exit

  for i in $ALLDOMAIN; do

    if [ $i == "localhost" ]; then

      chown -R nobody:nogroup $UNKNOWN_DIR/$i
    else
      securityDomain $i
    fi

  done

  cd $UNKNOWN_DIR || exit

  echo ''

}

killAptGet() {

  sudo killall apt apt-get &>/dev/null
  sudo rm /var/lib/apt/lists/lock &>/dev/null
  sudo rm /var/cache/apt/archives/lock &>/dev/null
  sudo rm /var/lib/dpkg/lock* &>/dev/null
}

configAutoJob() {

  textYellow "----------------> CONFIG AUTO WEBSERVER"

  echo ''

  cronJobUpdate=$(crontab -l)

  read -p "----------------> Install Auto Backup (y/n) : " status

  if [ $status == 'y' ]; then

    if [[ "$cronJobUpdate" =~ "UnknownAuto 17" ]]; then
      echo ''
    else
      cronJobUpdate="$cronJobUpdate
0 5 * * * UnknownAuto 17 &> /dev/null
"
    fi

  fi
  echo ''

  read -p "----------------> Install Auto Renews SSL/HTTPS (y/n) : " status

  if [ $status == 'y' ]; then

    if [[ $cronJobUpdate =~ "certbot renew" ]]; then
      echo ''
    else
      cronJobUpdate="$cronJobUpdate
0 1 * * * certbot renew &> /dev/null
"
    fi
  fi

  echo ''

  read -p "----------------> Install Auto Update and Protect Website Wordpress (y/n) : " status

  if [ $status == 'y' ]; then

    if [[ "$cronJobUpdate" =~ "UnknownAuto 7 && UnknownAuto 12" ]]; then
      echo ''
    else
      cronJobUpdate="$cronJobUpdate
0 2 * * * UnknownAuto 7 && UnknownAuto 12 &> /dev/null
"
    fi

  fi
  echo ''

  cat >$APP_INSTALL/crontab.txt <<EOF
$cronJobUpdate
EOF

  sudo crontab $APP_INSTALL/crontab.txt

  rm $APP_INSTALL/crontab.txt

  echo ''

}

uninstallUnknownOLS() {

  echo ''

  sudo rm -rf $APP_INSTALL &>/dev/null

  textMagenta "_____________ UNINSTALL SUCCESS ____________"

  echo ''

  exit
}
