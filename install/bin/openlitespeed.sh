#!/bin/bash

verifyExitOpenLiteSpeed() {
  if [ ! -d "$LSWS_DIR" ]; then
    textRed "WEBSERVER ERROR.PLEASE REINSTALL THE WEBSERVER"
    exit
  fi
}

cleanVhostsDefault() {
  verifyExitOpenLiteSpeed $1
  rm -rf $LSWS_CONFIG/templates &> /dev/null
  rm -rf $LSWS_VHOSTS &> /dev/null
  mkdir -m 0755 $LSWS_VHOSTS &> /dev/null
}

createVirtualHost() {

  verifyExitOpenLiteSpeed

  mkdir -p "$LSWS_VHOSTS/$1"

  mkdir -p $UNKNOWN_DIR/$1/html/

  cd $UNKNOWN_DIR/$1/html || exit

  touch index.html

  touch 404.html

  echo "<html><head></head><body><h1>$1</h1></body></html>" >$UNKNOWN_DIR/$1/html/index.html

  createFile404 404.html

  contentConf="
docRoot                   \$VH_ROOT/html/
vhDomain                  $1
enableGzip                1
index  {
  useServer               0
  indexFiles              index.html index.php
}
rewrite  {
  enable                  1
  autoLoadHtaccess        1
}
errorpage 404 {
  url                     /404.html
}
"

  if [ $1 != "localhost" ]; then

    contentConf="$contentConf
vhssl  {
  keyFile                 /etc/letsencrypt/live/$1/privkey.pem
  certFile                /etc/letsencrypt/live/$1/fullchain.pem
  certChain               1
}
"
  fi

  cat >$LSWS_VHOSTS/$1/vhconf.conf <<EOF
$contentConf
EOF

  cd $UNKNOWN_DIR || exit

}

updateHTTPConfig() {

  verifyExitOpenLiteSpeed

  sudo rm "$LSWS_CONFIG/httpd_config.conf" &>/dev/nul

  getVirtualHost=''

  domainHTTP=''

  domainHTTPS=''

  defaultSSL=''

  ALLDOMAIN=$(dir $UNKNOWN_DIR)

  for i in $ALLDOMAIN; do

    getVirtualHost="
$getVirtualHost
virtualhost $i {
  vhRoot                  $UNKNOWN_DIR/$i
  configFile              $LSWS_VHOSTS/$i/vhconf.conf
  allowSymbolLink         1
  enableScript            1
  restrained              1
}
"

    if [[ $i == 'localhost' ]]; then
      domainHTTP="$domainHTTP
   map                     $i $GET_IP_NAME"
    else
      defaultSSL=$i

      domainHTTP="$domainHTTP
   map                     $i $i"

      domainHTTPS="$domainHTTPS
   map                     $i $i"
    fi

  done

  listenerHTTP="

listener HTTP {
  address                 *:80
  secure                  0$domainHTTP
}
"

  listenerHTTPS="
listener HTTPS {
  address                 *:443
  secure                  1
  keyFile                 /etc/letsencrypt/live/$defaultSSL/privkey.pem
  certFile                /etc/letsencrypt/live/$defaultSSL/fullchain.pem
  certChain               1$domainHTTPS
}
"

  echo "
#
# PLAIN TEXT CONFIGURATION FILE
#
# If not set, will use host name as serverName
serverName
user                      nobody
group                     nogroup
priority                  0
inMemBufSize              60M
swappingDir               /tmp/lshttpd/swap
autoFix503                1
gracefulRestartTimeout    300
mime                      conf/mime.properties
showVersionNumber         0
adminEmails               root@localhost

errorlog logs/error.log {
  logLevel                DEBUG
  debugLevel              0
  rollingSize             10M
  enableStderrLog         1
}

accesslog logs/access.log {
  rollingSize             10M
  keepDays                30
  compressArchive         0
}
indexFiles                index.html, index.php

expires  {
  enableExpires           1
  expiresByType           image/*=A604800,text/css=A604800,application/x-javascript=A604800,application/javascript=A604800,font/*=A604800,application/x-font-ttf=A604800
}
autoLoadHtaccess          1

tuning  {
  maxConnections          10000
  maxSSLConnections       10000
  connTimeout             300
  maxKeepAliveReq         10000
  keepAliveTimeout        5
  sndBufSize              0
  rcvBufSize              0
  maxReqURLLen            32768
  maxReqHeaderSize        65536
  maxReqBodySize          2047M
  maxDynRespHeaderSize    32768
  maxDynRespSize          2047M
  maxCachedFileSize       4096
  totalInMemCacheSize     20M
  maxMMapFileSize         256K
  totalMMapCacheSize      40M
  useSendfile             1
  fileETag                28
  enableGzipCompress      1
  compressibleTypes       default
  enableDynGzipCompress   1
  gzipCompressLevel       6
  gzipAutoUpdateStatic    1
  gzipStaticCompressLevel 6
  brStaticCompressLevel   6
  gzipMaxFileSize         10M
  gzipMinFileSize         300

  quicEnable              1
  quicShmDir              /dev/shm
}

fileAccessControl  {
  followSymbolLink        1
  checkSymbolLink         0
  forceStrictOwnership    0
  requiredPermissionMask  000
  restrictedPermissionMask 000
}

perClientConnLimit  {
  staticReqPerSec         0
  dynReqPerSec            0
  outBandwidth            0
  inBandwidth             0
  softLimit               10000
  hardLimit               10000
  gracePeriod             15
  banPeriod               300
}

CGIRLimit  {
  maxCGIInstances         20
  minUID                  11
  minGID                  10
  priority                0
  CPUSoftLimit            10
  CPUHardLimit            50
  memSoftLimit            1460M
  memHardLimit            1470M
  procSoftLimit           400
  procHardLimit           450
}

accessDenyDir  {
  dir                     /
  dir                     /etc/*
  dir                     /dev/*
  dir                     conf/*
  dir                     admin/conf/*
}

accessControl  {
  allow                   ALL
}

extprocessor lsphp81 {
  type                    lsapi
  address                 uds://tmp/lshttpd/lsphp.sock
  maxConns                1000
  env                     PHP_LSAPI_CHILDREN=10
  env                     LSAPI_AVOID_FORK=200M
  initTimeout             60
  retryTimeout            0
  persistConn             1
  respBuffer              0
  autoStart               2
  path                    lsphp81/bin/lsphp
  backlog                 100
  instances               1
  priority                0
  memSoftLimit            2547M
  memHardLimit            2547M
  procSoftLimit           1400
  procHardLimit           1500
}

scripthandler  {
  add                     lsapi:lsphp81 php
}

railsDefaults  {
  maxConns                1
  env                     LSAPI_MAX_IDLE=60
  initTimeout             60
  retryTimeout            0
  pcKeepAliveTimeout      60
  respBuffer              0
  backlog                 50
  runOnStartUp            3
  extMaxIdleTime          300
  priority                3
  memSoftLimit            3047M
  memHardLimit            3047M
  procSoftLimit           500
  procHardLimit           600
}

wsgiDefaults  {
  maxConns                5
  env                     LSAPI_MAX_IDLE=60
  initTimeout             60
  retryTimeout            0
  pcKeepAliveTimeout      60
  respBuffer              0
  backlog                 50
  runOnStartUp            3
  extMaxIdleTime          300
  priority                3
  memSoftLimit            3047M
  memHardLimit            3047M
  procSoftLimit           500
  procHardLimit           600
}

nodeDefaults  {
  maxConns                5
  env                     LSAPI_MAX_IDLE=60
  initTimeout             60
  retryTimeout            0
  pcKeepAliveTimeout      60
  respBuffer              0
  backlog                 50
  runOnStartUp            3
  extMaxIdleTime          300
  priority                3
  memSoftLimit            3047M
  memHardLimit            3047M
  procSoftLimit           500
  procHardLimit           600
}

module cache {
internal            1
checkPrivateCache   1
checkPublicCache    1
maxCacheObjSize     10000000
maxStaleAge         200
qsCache             1
reqCookieCache      1
respCookieCache     1
ignoreReqCacheCtrl  1
ignoreRespCacheCtrl 0

enableCache         0
expireInSeconds     3600
enablePrivateCache  0
privateExpireInSeconds 3600
  ls_enabled              1
}
$getVirtualHost
$listenerHTTP
$listenerHTTPS
" >"$LSWS_CONFIG/httpd_config.conf"

  cd $UNKNOWN_DIR || exit

}

restartWebserver() {

  textYellow "----------------> RESTART WEBSERVER"

  service lsws restart && killall lsphp &>/dev/null

  systemctl restart mariadb &>/dev/null

  systemctl restart lsws &>/dev/null

  service lsws restart && killall lsphp &> /dev/null

}

resetAdminPassword() {

  textYellow "----------------> RESET WEB ADMIN"

  verifyExitOpenLiteSpeed

  sudo $LSWS_DIR/admin/misc/admpass.sh

  restartWebserver
}

updateWebserver() {

  updateSystem

  textYellow "----------------> UPDATE DPKG"

  sudo dpkg --configure -a &>/dev/null

  textYellow "----------------> UPDATE WP CLI"

  sudo wp cli update -y &>/dev/null

  textYellow "----------------> UPDATE OPENLITESPEED"

  sudo apt upgrade openlitespeed -y &>/dev/null

  textYellow "----------------> AUTO CLEAN"

  sudo apt autoremove -y &>/dev/null

  sudo apt autoclean -y &>/dev/null

  textMagenta "----------------> UPDATE WEBSERVER SUCCESS"

}

updateDomainSever() {

  ALLDOMAIN=$(dir $UNKNOWN_DIR)

  cd $UNKNOWN_DIR || exit

  for i in $ALLDOMAIN; do

    if [ $i != "localhost" ]; then
      createVirtualHost $i
      rm $UNKNOWN_DIR/$i/html/index.html &>/dev/null
    fi

    updateHTTPConfig

    restartWebserver

    textMagenta "----------------> RELOAD HTTP/HTTPS CONFIG SUCCESS"

  done
}

configVariableOpenLiteSpeed(){

  textYellow "----------------> CONFIG VARIABLE OPENLITESPEED"

  ARGS_UPDATE_CONFIG=([upload_max_filesize='200M'] [max_input_time=30] [memory_limit="512M"] [max_execution_time=300] [post_max_size='800M'])

  read -p "----------------> UPLOAD MAX FILE SIZE ( M ) : " ARGS_UPDATE_CONFIG['upload_max_filesize']
  read -p "----------------> MAX INPUT TIME ( NUMBER ) : " ARGS_UPDATE_CONFIG['max_input_time']
  read -p "----------------> MEMORY LIMIT ( M ) : " ARGS_UPDATE_CONFIG['memory_limit']
  read -p "----------------> MAX EXECUTION TIME ( NUMBER ) : " ARGS_UPDATE_CONFIG['max_execution_time']
  read -p "----------------> POST MAX SIZE ( M ) : " ARGS_UPDATE_CONFIG['post_max_size']

   if [ -f $LSWS_CONFIGPHP ]; then
     for item in "${ARGS_UPDATE_CONFIG[@]}"; do
          sed -i "s/$item/; $item/g" $LSWS_CONFIGPHP
          echo '' | tee -a $LSWS_CONFIGPHP >/dev/null
          echo '' | tee -a $LSWS_CONFIGPHP >/dev/null
          echo "$item = ${ARGS_UPDATE_CONFIG[$item]}" | tee -a $LSWS_CONFIGPHP >/dev/null
     done
    restartWebserver

    textMagenta "----------------> UPDATE VARIABLE OPENLITESPEED SUCCESS"
    else
       textRed "----------------> PLEASE CHECK AGAIN"
    fi

}
