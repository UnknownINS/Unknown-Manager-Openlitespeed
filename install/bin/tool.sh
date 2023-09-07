#!/bin/bash

chownProtectDomain(){
	
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

chownProtect(){

ALLDOMAIN=$(dir $UNKNOWN_DIR)

textYellow "----------------> PROTECT WEBSITE"

echo ""

  cd $UNKNOWN_DIR || exit

  for i in $ALLDOMAIN; do

    if [ $i == "localhost" ]; then
    
    chown -R nobody:nogroup $UNKNOWN_DIR/$i
    else
      chownProtectDomain $i

    fi

  done
  
  cd $UNKNOWN_DIR || exit

  echo ''

}

killAptGet(){

  sudo killall apt apt-get &> /dev/null
  sudo rm /var/lib/apt/lists/lock &> /dev/null
  sudo rm /var/cache/apt/archives/lock &> /dev/null
  sudo rm /var/lib/dpkg/lock* &> /dev/null
}

backupVPS(){

  verifyMariadb

  GETDAY=$(date +"%F")
  
  textYellow "----------------> BACKUP VPS"

  rm -rf $BACKUP_DIR/$GETDAY

  echo ''

  textYellow "----------------> START BACKUP DATABASE MYSQL"

  echo ''

  mkdir -p "$BACKUP_DIR/$GETDAY/mysql"

  backupDatabase $BACKUP_DIR/$GETDAY/mysql

  textYellow "----------------> END BACKUP DATABASE MYSQL"

  echo '';

  textYellow "----------------> START BACKUP CODE"


  zip -r $BACKUP_DIR/$GETDAY/backup.zip $UNKNOWN_DIR -q

  echo '';

  textYellow "----------------> BACKUP SUCCESS"

  echo '';

}


configAutoBackup(){

    textYellow "----------------> CONFIG AUTO BACKUP"

    echo ''

    rclone config

    echo ''
}

backupDriverNow(){

  if [ ! $RCLONE_NAME ]; then
    textRed "You Have Not Configured WebServer"
    echo ''
    exit
  fi

  GETDAY=$(date +"%F")

  rm -rf $BACKUP_DIR/$GETDAY &> /dev/null

  backupVPS

  echo ''

  textYellow "----------------> START UPLOAD GOOGLE DRIVE"

  echo ''

  rclone --transfers=1 move $BACKUP_DIR/$GETDAY "$RCLONE_NAME:$GET_IP_NAME/$GETDAY" &> /dev/null

  echo '';

  rm -rf $BACKUP_DIR/$GETDAY &> /dev/null

  textMagenta "_________________ END UPLOAD GOOGLE DRIVE ________________"

  echo '';

}



autoRenewSSL(){

  mycron=$(crontab -l)

  if [[ mycron =~ "certbot renew" ]]; then
      textRed "Command already exists"
    else
    printf "0 1 * * * certbot renew &> /dev/null\n" >> mycron
  fi

  sudo crontab mycron

  rm mycron
}


installCrontabAutoBackup(){

        mycron=$(crontab -l)
        if [[ mycron =~ "backup.sh" ]]; then
           echo ''
          else
          printf "0 5 * * * /usr/local/unknown/backup.sh &> /dev/null\n" >> mycron
        fi

        sudo crontab mycron

        rm mycron
}


configAutoJob(){

      textYellow "----------------> CONFIG AUTO WEBSERVER"
      echo ''


      cronJobUpdate=$(crontab -l)

      cd $UNKNOWN_DIR || exit

      touch crontab.txt

      echo $cronJobUpdate >> crontab.txt

      read -p "----------------> Install Auto Backup (y/n) : " status

      if [ $status == 'y' ]; then
        
        if [[ "$cronJobUpdate" =~ "backup.sh" ]]; then
           echo ''
          else
          cronJobUpdate="$cronJobUpdate
          0 5 * * * /usr/local/unknown/backup.sh &> /dev/null
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

        echo $cronJobUpdate >> crontab.txt

        sudo crontab $UNKNOWN_DIR/crontab.txt

        rm crontab.txt

        echo ''

}