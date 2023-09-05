#!/bin/bash

echo ""
echo "##############################################################################"
echo "#                                                                            #"
echo "#                                                                            #"
echo "#                   WELCOME to UNKNOWN OLS WEBSERVER                         #"
echo "#                                                                            #"
echo "#                     Copyright (C)  2023 UNKNOWN.                           #"
echo "#                                                                            #"
echo "#                                                                            #"
echo "##############################################################################"
echo "";
echo "----------------> INSTALL SETUP"

rm -rf /usr/local/unknown &> /dev/null

mkdir -p /usr/local/unknown &> /dev/null

cp -rf install/* /usr/local/unknown &> /dev/null

chmod -R +x /usr/local/unknown  &> /dev/null

ln -s /usr/local/unknown/run.sh /usr/local/bin/unknown &> /dev/null

cd ../ || exit

rm -rf unknown

echo "----------------> Install Success.Use command 'unknown' for use.Thank you"