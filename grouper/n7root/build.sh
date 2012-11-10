#!/bin/bash
mkdir bin
cd bin
echo "Downloading script..."
wget -q https://raw.github.com/compl3x/android/master/grouper/n7root/n7root.sh
mkdir files && cd files
echo "Downloading recoveries..."
wget -q http://techerrata.com/file/twrp2/grouper/openrecovery-twrp-2.3.1.1-grouper.img -O twrp.img
wget -q http://download2.clockworkmod.com/recoveries/recovery-clockwork-touch-6.0.1.0-grouper.img -O clockworkmod.img
echo "Copying fastboot and adb..."
sudo cp /usr/bin/adb ./
sudo cp /usr/bin/fastboot ./
sudo chmod a+rx adb fastboot
cd ../
sudo chmod a+rx n7root.sh
# Check all downlaoded files exist
if [ -e files/twrp.img ] && [ -e files/clockworkmod.img ]; then
	echo "Enter version:"
	read version
	echo "Creating tarball..."
	tar -czf "n7root-$version.tar.gz" n7root.sh ./files/
	echo "Done!"
	exit 0
else
	echo "Error, recovery files missing"
	exit 1
fi
