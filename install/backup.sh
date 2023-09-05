#!/bin/bash
export APP_INSTALL=/usr/local/EasyOLS
source $APP_INSTALL/constain.sh
source $APP_INSTALL/bin/color.sh
source $APP_INSTALL/bin/openlitespeed.sh
source $APP_INSTALL/bin/mysql.sh
source $APP_INSTALL/bin/tool.sh

setVariablesSystem

backupDriverNow