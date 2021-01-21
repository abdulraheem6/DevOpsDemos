#!/bin/bash
# Author: abdul raheem
echo "starting stop Sauce Tunnels script."
#processId=$(ps aux | grep sc | grep -v grep | awk  '{print $2}')
sauceuser=$SAUCEUSER
saucekey=$SAUCEKEY
sauceenv=$SAUCEENV
sauceTunnelIdentifier=$SAUCETUNNELIDENTIFIER
echo "$processId"
processId=$(ps aux | grep sc | grep $SAUCEUSER | grep $SAUCETUNNELIDENTIFIER | grep -v grep | awk  '{print $2}')
if [[ "" != "$processId" ]]; then
	      echo "Removing the tunnel owner : $SAUCEUSER tunnelIdentifier: $SAUCETUNNELIDENTIFIER"
	      kill -2 $processId
	      echo "removed tunnel successfully"
else
   echo "No Tunnel to remove....."
fi
