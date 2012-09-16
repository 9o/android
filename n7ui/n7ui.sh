#!/bin/bash
function disableSetup {
echo "-------------------------------------------
OPTIONS:
(e) Patch build.prop to make setup optional
(d) Remove optional setup patch
-------------------------------------------"
read nuggets
if [[ $nuggets == "e" ]]
then
echo "Making setup optional..."
echo "ro.setupwizard.mode=OPTIONAL" >> build.prop
echo "Setup patch applied!"
showMenu
elif [[ $nuggets == "d" ]]
then
echo "Removing setup patch..."
sed -i 's/ro.setupwizard.mode=OPTIONAL//g' build.prop
echo "Removed setup patch"
showMenu
else
showMenu
fi
}
function scrolling {
echo "-------------------------------------------
OPTIONS:
(e) Patch build.prop to improve scrolling
(d) Remove better scrolling patch
-------------------------------------------"
read scrollme
if [[ $scrollme == "e" ]]
then
echo "Patching build.prop for better scrolling..."
echo "windowsmgr.max_events_per_sec=240" >> build.prop
echo "Patched build.prop for greater scrolling"
showMenu
elif [[ $scrollme == "d" ]]
then
echo "Removing scrolling patch..."
sed -i 's/windowsmgr.max_events_per_sec=240//g' build.prop
echo "Removed scrolling patch!"
showMenu
else
showMenu
fi
}
function patchMedia {
echo "-------------------------------------------
OPTIONS:
(e) Patch build.prop with media patches
(d) Remove media patch from build.prop
-------------------------------------------"
read op2
if [[ $op2 == "e" ]]
then
echo "Adding media patch to build.prop"
echo "ro.media.dec.jpeg.memcap=8000000
ro.media.enc.hprof.vid.bps=8000000" >> build.prop
echo "Patched build.prop with media patch!"
showMenu
elif [[ $op2 == "d" ]]
then
echo "Removing media patch"
sed -i 's/ro.media.dec.jpeg.memcap=8000000//g' build.prop
sed -i 's/ro.media.enc.hprof.vid.bps=8000000//g' build.prop
echo "Removed media patch"
showMenu
else
showMenu
fi
}
function patchUI {
echo "--------------------------------
OPTIONS:
--------------------------------"
echo "(t) Patch build.prop as tablet UI
(p) Patch build.prop as phone (original) UI"
read choice
echo
if [[ $choice == "p" ]]
  then
#Phone (original) UI
sed -i 's/ro.sf.lcd_density=[0-9][0-9][0-9]/ro.sf.lcd_density=213/g' build.prop
echo "Modified to phone (original) UI"
showMenu
elif [[ $choice == "t" ]]
then
#Tablet UI
sed -i 's/ro.sf.lcd_density=[0-9][0-9][0-9]/ro.sf.lcd_density=160/g' build.prop
echo "Modified to tablet UI"
showMenu
else
showMenu
fi
}
function rotation {
echo "-------------------------------------------
OPTIONS:
(e) Patch build.prop to enable rotation
(d) Remove rotation patch from build.prop
-------------------------------------------"
read op
if [[ $op == "e" ]]
then
echo "launcher.force_enable_rotation=true" >> build.prop
echo "Launcher patch done!"
showMenu
elif [[ $op == "d" ]]
then
sed -i 's/launcher.force_enable_rotation=true//g' build.prop
echo "Launcher patch removed!"
showMenu
else
showMenu
fi
}
function appyPatch {
echo "Root is required for patch application"
echo "Attempting to mount /system/"
$adblocation shell su mount -o rw,remount /dev/block/mmcblk0p1 /system
echo "Pushing build.prop onto device"
$adblocation push build.prop /system/build.prop
showMenu
}
function notify {
echo "------------------------------------------------
OPTIONS:
(e) Patch build.prop to remove adb notifications
(d) Remove adb patch from build.prop
------------------------------------------------"
read npop
if [[ $npop == "e" ]]
then
echo "Adding adb notification patch, notifications upon USB connection will now not appear"
echo "persist.adb.notify=0" >> build.prop
showMenu
elif [[ $npop == "d" ]]
then
sed -i 's/persist.adb.notify=0//g' build.prop
echo "adb notification patch removed!"
showMenu
else
showMenu
fi
}
function showMenu {
echo "
-----------------------------------------------------------------
MENU:
-----------------------------------------------------------------
a) Patch for Phone or Tablet UI
b) Enable/disable home screen rotation
c) Remove adb notifications
d) Add media patch (improves media viewing/playback)
e) Add setup patch to make setup wizard optional
f) Patch maxevents to get better scrolling
p) Mount /system/ and push build.prop onto device

Any other key)			In option: go to main menu
				At main menu: Exit application
-----------------------------------------------------------------"

read menuItem

if [[ $menuItem == "a" ]]
then
patchUI
elif [[ $menuItem == "b" ]]
then
rotation
elif [[ $menuItem == "c" ]]
then
notify
elif [[ $menuItem == "d" ]]
then
patchMedia
elif [[ $menuItem == "e" ]]
then
disableSetup
elif [[ $menuItem == "f" ]]
then
scrolling
elif [[ $menuItem == "p" ]]
then
appyPatch
else
exit
fi
}

#Root check
if [[ "$(whoami)" != 'root'  ]];then
  echo "This script must be run as root!"
  exit
fi
#64-bit notice check
if [[ "$(uname -i)" = 'x86_64'  ]];then
  echo "PLEASE ENSURE YOU HAVE ia32-libs INSTALLED. IF YOU DO, PRESS [ENTER]"
  read yayornay
fi
#Determine which adb binary to use
if [[ -x /usr/bin/adb ]]
  then
    adblocation=/usr/bin/adb
    echo "Using adb binary in /usr/bin/"
  else
    adblocation=./files/adb
    #File permission fix - Thanks to Mark Lord
    sudo chmod a+rx files/adb
    echo "Fixed and using bundled adb"
fi

echo "
-----------------------------------------------------------------
		      n7ui - Nexus7 UI modifier
			By cyr0s (@complex360)
		    Donate: michael.cowell3@gmail.com
-----------------------------------------------------------------"

#Evaluate whether pulling prop is necessary
echo "Do you have an existing build.prop in this folder? (y/n)"
read exist
if [[ $exist == "n" ]]; then
$adblocation pull /system/build.prop ./
else 
echo "Using existing build.prop"
fi
echo "

#Lines past this point are likely added by n7ui.
#Nexus7 UI Modifier (n7ui) made by cyros/@Complex360" >> build.prop
showMenu