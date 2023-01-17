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

# Check Disk Block Size (grep "Device Block Size") # NOTE: Standard data block (in ISO 9660) is 2048 bytes
BLOCK_SIZE=`diskutil information "${DISKNM}" | grep "Device Block Size:" | egrep --only-matching "[0-9]+ Bytes" | egrep --only-matching "^[0-9]+"`

# Check Disk Volume Size (grep "Volume Total Space" or "Volume Used Space")
VOLUME_SIZE=`diskutil information "${DISKNM}" | grep "Volume Total Space:" | egrep --only-matching "[0-9]+ Bytes" | egrep --only-matching "^[0-9]+"` # Volume Size in Bytes
BLOCK_COUNT=`diskutil information "${DISKNM}" | grep "Volume Total Space:" | egrep --only-matching "\(exactly [0-9]+ 512-Byte-Units\)" | awk '{print $2}'` # Volume Size in # of 512-byte block

TMP=`expr ${BLOCK_SIZE} % 512`
if [ "$TMP" -ne 0 ]; then
	echo "Error: Block size is not multiple of 512: ${BLOCK_SIZE}" >&2
	exit 1
fi

# Calculate Actual Block Count
TMP=`expr "${BLOCK_SIZE}" / 512`
COPY_COUNT=`expr "${BLOCK_COUNT}" / "${TMP}"`

NOW=`date +"%F %T"`
echo "[${NOW}] Unmount Disk..."
diskutil unmountDisk "$DISKNM"

NOW=`date +"%F %T"`
echo "[${NOW}] Convert Disk to ISO... (${VOLUME_SIZE} Bytes = ${BLOCK_SIZE} Bytes * ${COPY_COUNT} Blocks )"
# dd if="${DISKNM}" of="$1.iso" status=progress # Rip not only 'Volume Size' but also 'Total Disk Size'
dd if="${DISKNM}" of="$1.iso" bs=${BLOCK_SIZE} count=${COPY_COUNT} status=progress 
echo "Result: $?"

NOW=`date +"%F %T"`
echo "[${NOW}] Mount Disk..."
diskutil mountDisk "$DISKNM"
