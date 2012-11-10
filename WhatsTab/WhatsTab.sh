#!/bin/bash
#Checks if user is root
if [[ "$(whoami)" != 'root'  ]];then
  echo "This script must be run as root!"
  exit
fi
#Checks for adb and fastboot location
#Checks for adb and fastboot location
if [[ -x /usr/bin/adb ]]
  then
    adblocation=/usr/bin/adb
    echo "Using fasboot binary in /usr/bin/"
  else if [[ -x ./files/adb ]]; 
  then
    adblocation=./files/adb
    #File permission fix - Thanks to Mark Lord
    sudo chmod a+rx files/adb
  else
  echo "Please enter the directory which contains adb"
  read adb
  adblocation=echo "${adb}/adb"
fi
fi

echo "---------------------------------------------------------"
echo "WhatsTab - WhatsApp Installer for Tablets"
echo "Created by @Complex360 (Twitter) cyr0s (xda-developers)"
echo "---------------------------------------------------------"
#Script will install WhatsApp if it hasn't already been installed
echo "Have you already installed WhatsApp? (y/n)"
read installation
if [[ $installation == "n" ]]; then
#Download and install WhatsApp apk.
echo "Downloading WhatsApp.apk..."
wget http://www.whatsapp.com/android/current/WhatsApp.apk
echo "Installing WhatsApp.apk..."
$adblocation install WhatsApp.apk
echo "WhatsApp installed sucessfully!"
fi

echo "Connect your MOBILE PHONE and press [ENTER]"
read mobile
$adblocation reboot recovery
echo "When recovery opens, mount data and press [ENTER]"
read mounted
echo "Extracting phone data..."
$adblocation pull /data/data/com.whatsapp/shared_prefs/PhoneRegister.xml PhoneRegister.xml
echo "Extracting account data..."
$adblocation pull /data/data/com.whatsapp/files/ ./files/
echo "Unplug your mobile and plug in your tablet, then, press [ENTER]"
read tablet
$adblocation reboot recovery
echo "When recovery opens, mount data and press [ENTER]"
read canadian_mounted_police
echo "Patching phone data..."
$adblocation push PhoneRegister.xml /data/data/com.whatsapp/shared_prefs/PhoneRegister.xml
echo "Patching account data..."
$adblocation rm -r /data/data/com.whatsapp/files/ ./files/
$adblocation push ./files/ /data/data/com.whatsapp/files/
echo "Cleaning up..."
sudo rm -r files && rm PhoneRegister.xml
echo "Done! Whatsapp should now function correctly on your tablet!"
echo "If I've helped you with getting WhatsApp working, pressing [ENTER] now will open a PayPal donation page, otherwise, close this window."
read paypal
xdg-open "https://www.paypal.com/uk/cgi-bin/webscr?cmd=_flow&SESSION=5FsxjV-_HvnOCvEJ9K2Yxg1Ax8KM4OjTo9Hd25ph3Y9-XWxOe-TJndVJuda&dispatch=5885d80a13c0db1f8e263663d3faee8d0b7e678a25d883d0fa72c947f193f8fd"