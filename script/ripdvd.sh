#! /bin/sh

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 targetName(without extension)" >&2
	exit 1
fi

# Device Name of your CD/DVD
DISKNM=`drutil status | egrep --only-matching "Name\: .+" | awk '{print $2}'`
# DISKNM="/dev/disk4" # or manually write device name here...

# Check Volume Name (most of case this value is empty... for data disc)
#VOLUME_NAME=`diskutil information "${DISKNM}" | grep "Volume Name:"` | awk '{print $3}'
# if [ -z "${VOLUMNE_NAME}" ]; then
# 	VOLUME_NAME="Untitled"
# fi

NOW=`date +"%F %T"`
echo "[${NOW}] Unmount Disk..."
diskutil unmountDisk "$DISKNM"

NOW=`date +"%F %T"`
echo "[${NOW}] Convert Disk to ISO... 
dd if="${DISKNM}" of="$1.iso" status=progress # Rip not only 'Volume Size' but also 'Total Disk Size'
echo "Result: $?"

NOW=`date +"%F %T"`
echo "[${NOW}] Mount Disk..."
diskutil mountDisk "$DISKNM"
