#!/bin/sh
 
DISK=/dev/sdb

sudo umount $DISK"1"
sudo umount $DISK"2"
sudo umount $DISK"3"
sudo umount $DISK"4"
sudo umount $DISK"5"
sudo umount $DISK"6"
sudo umount $DISK"7"
sudo sfdisk $DISK < ./32Gpartitions

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

sudo mount $DISK"1" /media/boot
sudo cp -rp /opt/raspberrypi/boot/* /media/boot/
sudo umount $DISK"1"

