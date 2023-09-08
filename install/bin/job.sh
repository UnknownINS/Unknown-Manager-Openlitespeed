#!/bin/bash

configAutoJob() {

  textYellow "----------------> CONFIG AUTO WEBSERVER"

  echo ''

  cronJobUpdate=$(crontab -l)

  read -p "----------------> Clean Auto Job (y/n) : " status

  if [ $status == 'y' ]; then
    cronJobUpdate=''
  fi

  read -p "----------------> Install Auto Backup (y/n) : " status

  if [ $status == 'y' ]; then

    if [[ "$cronJobUpdate" =~ "UnknownAuto 18" ]]; then
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

    if [[ "$cronJobUpdate" =~ "UnknownAuto 7 && UnknownAuto 13" ]]; then
      echo ''
    else
      cronJobUpdate="$cronJobUpdate
0 2 * * * UnknownAuto 7 && UnknownAuto 13 &> /dev/null
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
