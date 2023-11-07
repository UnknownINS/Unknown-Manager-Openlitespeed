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
  textMagenta "----------------> UNINSTALL SUCCESS"
}

createFTPForDomain(){

    read -p "----------------> Enter Domain : " inputDomain

    validate="^([a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]\.)+[a-zA-Z]{2,}$"

    if [[ -z "$inputDomain" ]]; then

      textRed "----------------> PLEASE CHECK DOMAIN AGAIN"

      exit
    fi

  verifyDir $UNKNOWN_DIR/$inputDomain

  if [[ "$inputDomain" =~ $validate ]]; then
    textYellow "----------------> CREATE FTP FOR DOMAIN"

    FTP_PASSWORD=$(openssl rand -base64 20)

  else
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    exit
  fi
}

installFTPForDomain(){

  textYellow "----------------> INSTALL FTP FOR DOMAIN"

  if [ ! -f /etc/vsftpd.conf ]; then
    echo "Không";
    textMagenta "----------------> FTP SEVER NOT INSTALL"
    else
      echo "có";
      #sudo apt install vsftpd -y
      #configVSFTPD
      #createFTPForDomain
  fi

}
