#!/bin/bash 

# Author: IMF  Sauce Labs 2019

echo "starting Create Sauce Tunnels script."
clear

# Define Variables 

DCURLEU="https://eu1.api.testobject.com/sc/rest/v1"
DCURLUS="https://us1.api.testobject.com/sc/rest/v1"
HEADLESSURL="https://us-east-1.saucelabs.com/rest/v1"

delay=2
sauceuser=$SAUCEUSER
saucekey=$SAUCEKEY
sauceenv=$SAUCEENV
#sauceTunnelId=$
sauceTunnelIdentifier=$SAUCETUNNELIDENTIFIER
#MYDIR=/tmp
MYDIR=/opt/sauce-connect/sc-4.5.4-linux
FILE=$MYDIR/bin/sc
MYCURRENTDIR=$(pwd)
LOGFILE=$MYCURRENTDIR/sauceconnect.log

PORT=4445
while printf -v regex ':%04X .* 0A ' $PORT;grep -q "$regex" /proc/net/tcp*;do
	    ((PORT++))
	      done
	      echo First free port number: $PORT
      
if [ -e $LOGFILE ]; then

      echo "Deleting old log file:" $LOGFILE
      rm -rf $LOGFILE

else 

     echo "No Log file to delete.....proceed with the script."
fi 

if [ -e $FILE ]; then 
	echo "The Sauce Connect executable exists." $FILE

	if [ -n "$SAUCEUSER" ] && [ -n "$SAUCEKEY" ] & [ -n "$SAUCEENV" ] & [ -n "$SAUCETUNNELIDENTIFIER" ]  ; then
		   
		
			if [ $sauceenv == "Web" ]; then
  				echo "Create a tunnel on Web VM"
				sleep $delay
                		ulimit -n 8000; cd $MYDIR; bin/sc -u $SAUCEUSER -k $SAUCEKEY --tunnel-identifier $SAUCETUNNELIDENTIFIER --se-port $PORT -l $LOGFILE
			fi

			if [ $sauceenv == "EU" ]; then
                                echo "Create a tunnel on EU RDC"
				sleep $delay
		 		ulimit -n 8000; cd $MYDIR/bin; ./sc -u $SAUCEUSER -k $SAUCEKEY -x $DCURLEU --tunnel-identifier $SAUCETUNNELIDENTIFIER --se-port $PORT -v -l $LOGFILE
                        fi

			if [ $sauceenv == "US" ]; then
                                echo "Create a tunnel on US RDC"
				#echo "Sauce User: " $sauceuser
				#echo "Sauce Access Key: " $saucekey
				sleep $delay
				ulimit -n 8000; cd $MYDIR ; bin/sc -u $SAUCEUSER -k $SAUCEKEY -x $DCURLUS --tunnel-identifier $SAUCETUNNELIDENTIFIER --se-port $PORT -v -l $LOGFILE 
                        fi

			if [ $sauceenv == "HEADLESS" ]; then
                                echo "Create a tunnel on Headless, with the following parameters"
				#echo "Sauce USer: " $sauceuser
				#echo "Sauce Access Key: " $saucekey
				#echo "Tunnel Id: " $sauceTunnelId
				echo "Headless endpoint: " $HEADLESSURL
                                sleep $delay
				ulimit -n 8000; cd $MYDIR; bin/sc -u $SAUCEUSER -k $SAUCEKEY -x $HEADLESSURL --tunnel-identifier $SAUCETUNNELIDENTIFIER --se-port $PORT
                                # ulimit -n 8000; cd $MYDIR; bin/sc -u $1 -k $2 $HEADLESSURL -i $4 -v -l $LOGFILE
                        fi
		 
	else
  		echo "Syntax: ./script <sauceuser> <sauceaccesskey> <sauceENV: Web|EU|US|HEADLESS> <tunnelId>"
  		exit 1
	fi

else 
	echo "The file: " $FILE " doesnt exist."
	echo "use this link and download the latest version now."
	versions=$(xidel --extract "//a/@href" https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy | grep "osx.zip" | awk -F"[- -]" '{print $2}')
	latestversion=$(echo $versions | sort -n | awk '{print $1}')
	downloadversionURL=$(xidel --extract "//a/@href" https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy | grep "osx.zip" | grep $latestversion)
	wget $downloadversionURL
	downloadedfile=$(ls | grep *.zip)
	tar -xvf $downloadedfile
	rm -rf $downloadedfile
	mydir=$(ls | grep  .-osx)
	mv $mydir SauceConnect 
	echo "https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy"
	exit 1

fi 
