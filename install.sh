#!/bin/bash

echo ""
echo "##############################################################################"
echo "#                                                                            #"
echo "#                                                                            #"
echo "#                    WELCOME to UNKNOWN OLS WEBSERVER                        #"
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

ln -s /usr/local/unknown/Unknown.sh /usr/local/bin/Unknown &> /dev/null

ln -s /usr/local/unknown/UnknownCLI.sh /usr/local/bin/UnknownCLI &> /dev/null

rm -rf Unknown-Manager-Openlitespeed &> /dev/null

echo "----------------> Install Success.Use command 'Unknown' for use.Thank you"
