#!/bin/bash

# Check if the user supplied exactly one argument
if [ "$#" -ne 1 ]; then
    echo "You must supply exactly one argument."
    echo "Example: $0 blink"
    exit 1 # Return with value 1
fi

# Verify that file exists
RBF_FILE=/root/$1.rbf
if test -f "$RBF_FILE"; then
	echo "$RBF_FILE exists."
else
	echo "$RBF_FILE does not exists."
	exit 1
fi

# Create .dtso file
echo "Create .dtso file."
DTSO_FILE=/root/$1.dtso
cat <<EOF >$DTSO_FILE
/dts-v1/;
/plugin/;

/{
	fragment@0 {
    	target-path = "/soc/base_fpga_region";
        __overlay__ {
	    #address-cells = <1>;
            #size-cells = <1>;
            firmware-name = "$1.rbf";
        };
    };
};
EOF

# Compile the device tree
echo "Compile the device tree"
dtc -O dtb -o $1.dtbo -b 0 -@ $1.dtso

# Copy files to /lib/firmware
echo "Copy files to /lib/firmware"
mkdir -p /lib/firmware
cp $1.dtbo /lib/firmware
cp $1.rbf /lib/firmware

# Mount configfs
echo "Mount configfs"
mkdir -p /config
mount -t configfs configfs /config

# Create new folder in overlays folder
echo "Create new folder in overlays folder"
mkdir /config/device-tree/overlays/$1

# Pass name of the device tree
echo "Pass name of the device tree"
echo -n "$1.dtbo" > /config/device-tree/overlays/$1/path

exit 0