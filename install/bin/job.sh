#!/bin/bash

configAutoJob() {

  textYellow "----------------> CONFIG AUTO WEBSERVER"

  cronJobUpdate=$(crontab -l)

  read -p "----------------> Clean Auto Job (y/n) : " status

  if [ $status == 'y' ]; then
    cronJobUpdate=''
  fi

  read -p "----------------> Install Auto Backup (y/n) : " status

  if [ $status == 'y' ]; then

    if [[ "$cronJobUpdate" =~ "UnknownCLI 10" ]]; then
      echo 'Already Exist.'
    else
      cronJobUpdate="$cronJobUpdate
0 5 * * * UnknownCLI 10 &> /dev/null"
    fi

  fi

  read -p "----------------> Install Auto Renews SSL/HTTPS (y/n) : " status

  if [ $status == 'y' ]; then

    if [[ $cronJobUpdate =~ "certbot renew" ]]; then
      echo 'Already Exist.'
    else
      cronJobUpdate="$cronJobUpdate
0 1 * * * certbot renew &> /dev/null"
    fi
  fi


  read -p "----------------> Install Auto Update Website (y/n) : " status

  if [ $status == 'y' ]; then

    if [[ "$cronJobUpdate" =~ "UnknownCLI 18" ]]; then
      echo 'Already Exist.'
    else
      cronJobUpdate="$cronJobUpdate
0 2 * * * UnknownCLI 18 &> /dev/null"
    fi

  fi


  read -p "----------------> Install Auto Security WebSite (y/n) : " status

  if [ $status == 'y' ]; then

    if [[ "$cronJobUpdate" =~ "UnknownCLI 19" ]]; then
      echo 'Already Exist.'
    else
      cronJobUpdate="$cronJobUpdate
0 3 * * * UnknownCLI 19 &> /dev/null"
    fi

  fi


  ALLDOMAIN=$(dir $UNKNOWN_DIR)

  read -p "----------------> Install WP cron terminal (y/n) : " status

  if [ $status == 'y' ]; then
    if [[ "$cronJobUpdate" =~ "wp-cron" ]]; then
      echo 'Already Exist.'
    else
          for i in $ALLDOMAIN; do
            if [[ $i != "localhost" ]]; then
              cronJobUpdate="$cronJobUpdate
* * * * * wget -q -O - http://$i/wp-cron.php &> /dev/null";
            fi

          done
    fi
  fi

  cat >$APP_INSTALL/crontab.txt <<EOF
$cronJobUpdate
EOF

  sudo crontab $APP_INSTALL/crontab.txt

  rm $APP_INSTALL/crontab.txt

  textMagenta "----------------> UPDATE CRON JOB SUCCESS"

}
