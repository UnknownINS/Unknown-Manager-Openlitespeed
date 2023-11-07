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
  rm -rf /tmp/ &>/dev/null
  sudo apt autoremove
  sudo apt autoclean
  textMagenta "----------------> UNINSTALL SUCCESS"
}


installFTPforDomain(){

  textYellow "----------------> INSTALL FTP FOR DOMAIN"

  if [ -f /etc/vsftpd.conf ]; then
    echo "có"
  fi

}
