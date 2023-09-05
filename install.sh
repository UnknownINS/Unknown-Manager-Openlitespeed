#!/bin/bash

echo ""
echo "##############################################################################"
echo "#                                                                            #"
echo "#                                                                            #"
echo "#                     WELCOME to Easy OLS WEBSERVER                          #"
echo "#                                                                            #"
echo "#                     Copyright (C)  2023 UNKNOWN.                           #"
echo "#                                                                            #"
echo "#                                                                            #"
echo "##############################################################################"
echo "";
echo "----------------> INSTALL SETUP"

rm -rf /usr/local/EasyOLS &> /dev/null

mkdir -p /usr/local/EasyOLS &> /dev/null

cp -rf install/* /usr/local/EasyOLS &> /dev/null

chmod -R +x /usr/local/EasyOLS  &> /dev/null

ln -s /usr/local/EasyOLS/run.sh /usr/local/bin/EasyOLS &> /dev/null

echo "----------------> Install Success.Use command 'EasyOLS' for use.Thank you"