#! /bin/sh

if [ "$#" -ne 1 ] || ! [ -f "$1" ]; then
	echo "Usage: $0 cdrFile" >&2
	exit 1
fi

hdiutil makehybrid -iso -joliet -o "$1.iso" "$1"
