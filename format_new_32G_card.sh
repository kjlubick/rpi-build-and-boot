#!/bin/sh

DISK=/dev/sdb
PARTITIONS=./32Gpartitions

if [! -d "/opt/raspberrypi/boot" ] || [! -d "/opt/raspberrypi/root" ]; then
	echo "This must be run on skia-rpi-master. /opt/raspberrypi/boot and
/opt/raspberrypi/root must be mounted.  The ansible playbook
start_serving_image.yml does this. Have you run that?"
	exit 1
fi

echo "Going to repartition "$DISK" using "$PARTITIONS
echo "If this is not correct, abort using Ctrl+C"
echo "What will the static IP address of this bot be?"
read IP
echo "What will be the hostname of this bot?"
read HOSTNAME
echo "Partitioning disk"

sudo umount $DISK"1"
sudo umount $DISK"2"
sudo umount $DISK"3"
sudo umount $DISK"4"
sudo umount $DISK"5"
sudo umount $DISK"6"
sudo umount $DISK"7"
sudo sfdisk $DISK < $PARTITIONS

echo "Formatting partitions"
sudo mkfs.fat $DISK"1" -n BOOT
sudo mkfs.ext4  $DISK"3" -L B
sudo mkfs.ext4  $DISK"5" -L VAR
sudo mkfs.ext4  $DISK"6" -L TMP
sudo mkfs.ext4  $DISK"7" -L HOME

sudo umount $DISK"1"
sudo umount $DISK"2"
sudo umount $DISK"3"
sudo umount $DISK"5"
sudo umount $DISK"6"
sudo umount $DISK"7"

echo "Writing /boot"
sudo mount $DISK"1" /media/boot
sudo cp -rp /opt/raspberrypi/boot/* /media/boot/
sudo umount $DISK"1"

echo "Writing /home"
sudo mount $DISK"7" /media/home
sudo cp -rp /opt/raspberrypi/root/home/chrome-bot* /media/home/
sudo umount $DISK"7"