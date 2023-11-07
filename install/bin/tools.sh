installNetData(){
  textYellow "----------------> INSTALL NETDATA"

  if [ ! -f /tmp/netdata-kickstart.sh ]; then
    wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh
    sudo ufw allow 19999/tcp &>/dev/null
    sudo ufw reload
  fi
  systemctl stop netdata
  systemctl start netdata
  textMagenta "----------------> INSTALL SUCCESS : $GET_IP_NAME:19999"
}
unInstallNetData(){

  textYellow "----------------> UNINSTALL NETDATA"
  wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh --uninstall
  sudo apt autoremove
  sudo apt autoclean
  rm /tmp/netdata-kickstart.sh &> /dev/null
  textMagenta "----------------> UNINSTALL SUCCESS"
}


deleteFTPDomain(){

  textYellow "----------------> DELETE FTP ACCOUNT FOR DOMAIN"

    read -p "----------------> Enter Domain : " inputDomain

    validate="^([a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]\.)+[a-zA-Z]{2,}$"

    if [[ -z "$inputDomain" ]]; then
      textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
      exit
    fi

  verifyDir $UNKNOWN_DIR/$inputDomain

  nameFTP=$(sed "s/\./_/g" <<<"$inputDomain")

  if [[ "$inputDomain" =~ $validate ]]; then
      verifyNameFTP=$(sudo cat /etc/passwd | grep $nameFTP)
      if [[ -z "$verifyNameFTP" ]]; then
        echo ''
        textRed "----------------> DOMAIN NOT FOUND FTP ACCOUNT"
      else
        deluser $nameFTP
        textRed "----------------> DELETE SUCCESS FTP ACCOUNT"
      fi

  else
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    exit
  fi

}

createFTPForDomain(){
    useradd -d $UNKNOWN_DIR/$2/html -g ftponly -m -s /bin/ftponly $1 &> /dev/null
    textMagenta "----------------> PASSWORD FOR FTP ACCOUNT : "
    passwd $1
    textYellow "----------------> PROTECT WEBSITE"
    securityDomain $2
    textMagenta "----------------> USERNAME FTP ACCOUNT FOR DOMAIN $2 : $1"
}

callbackFTPForDomain(){

    read -p "----------------> Enter Domain : " inputDomain

    validate="^([a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]\.)+[a-zA-Z]{2,}$"

    if [[ -z "$inputDomain" ]]; then
      textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
      exit
    fi

  verifyDir $UNKNOWN_DIR/$inputDomain

  nameFTP=$(sed "s/\./_/g" <<<"$inputDomain")

  if [[ "$inputDomain" =~ $validate ]]; then
      verifyNameFTP=$(sudo cat /etc/passwd | grep $nameFTP)
      if [[ -z "$verifyNameFTP" ]]; then
        createFTPForDomain $nameFTP $inputDomain
      else
        echo ''
        textRed "----------------> USER FTP EXIST"
      fi

  else
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    exit
  fi
}

restartVSFTPD(){
    sudo systemctl restart vsftpd
}

configVSFTPD(){
  sudo ufw allow 20,21,990/tcp
  sudo ufw allow 40000:50000/tcp
  sudo ufw reload
  sudo cp /etc/vsftpd.conf /etc/vsftpd.conf_default
  sudo cp $APP_INSTALL/library/vsftpd.conf /etc/vsftpd.conf

  contentOnlyFTP="
#!/bin/sh
echo 'This account is limited to FTP access only.'"
  cat >/bin/ftponly <<EOF
$contentOnlyFTP
EOF

sudo chmod a+x /bin/ftponly

sudo echo "/bin/ftponly" >> /etc/shells

sudo addgroup ftponly &> /dev/null

}

installFTPForDomain(){

  if [ ! -f /etc/vsftpd.conf ]; then
      textYellow "----------------> INSTALL LIBRARY VSFTPD"
      sudo apt install vsftpd -y
      sudo systemctl start vsftpd
      sudo systemctl enable vsftpd
      configVSFTPD
      restartVSFTPD
  fi
  echo ''
  textYellow "----------------> CREATE FTP FOR DOMAIN"
  echo ''
  callbackFTPForDomain
}
