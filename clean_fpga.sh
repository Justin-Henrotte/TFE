#!/bin/bash

# Check if the user supplied exactly one argument
if [ "$#" -ne 1 ]; then
    echo "You must supply exactly one argument."
    echo "Example: $0 blink"
    exit 1 # Return with value 1
fi

# Verify that files .rbf, .dtso and .dtbo exists
RBF_FILE=/root/$1.rbf
if test -f "$RBF_FILE"; then
	echo "$RBF_FILE exists."
else
	echo "$RBF_FILE does not exists."
	exit 1
fi
if test -f "/root/$1.dtso"; then
	echo "/root/$1.dtso exists."
else
	echo "/root/$1.dtso does not exists."
	exit 1
fi
if test -f "/root/$1.dtbo"; then
	echo "/root/$1.dtbo exists."
else
	echo "/root/$1.dtbo does not exists."
	exit 1
fi

# Remove files in /root/ directory
echo "Remove files in /root/ directory"
rm $1.dtso $1.dtbo

# Remove files in /lib/firmware
echo "Remove files in /lib/firmware"
rm /lib/firmware/$1.dtbo
rm /lib/firmware/$1.rbf

# Remove folder in overlays folder
echo "Remove folder in overlays folder"
rmdir /config/device-tree/overlays/$1

# Unmount /config
echo "Unmount /config"
umount /config

exit 0