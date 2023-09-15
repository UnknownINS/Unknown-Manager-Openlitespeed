#!/bin/bash

configAutoJob() {

  textYellow "----------------> CONFIG AUTO WEBSERVER"

  echo ''

  cronJobUpdate=$(crontab -l)

  read -p "----------------> Clean Auto Job (y/n) : " status

  if [ $status == 'y' ]; then
    cronJobUpdate=''
  fi

  echo ''

  read -p "----------------> Install Auto Backup (y/n) : " status

  if [ $status == 'y' ]; then

    if [[ "$cronJobUpdate" =~ "UnknownCLI 10" ]]; then
      echo ''
    else
      cronJobUpdate="$cronJobUpdate
0 5 * * * UnknownCLI 10 &> /dev/null
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

  read -p "----------------> Install Auto Update and Security Website (y/n) : " status

  if [ $status == 'y' ]; then

    if [[ "$cronJobUpdate" =~ "UnknownCLI 17 && UnknownCLI 18" ]]; then
      echo ''
    else
      cronJobUpdate="$cronJobUpdate
0 2 * * * UnknownCLI 17 && UnknownCLI 18 &> /dev/null
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
