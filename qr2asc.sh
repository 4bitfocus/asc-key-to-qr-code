#!/bin/bash

#####
#
# Author: Kevin Douglas <douglk@gmail.com>
#
# Simple command line script to restore ascii armor gpg keys from a QR image.
# You can use the following commands to import your restored keys:
#
#   gpg --import pgp-public-keys.asc
#   gpg --import pgp-private-keys.asc
#
# This script will allow you to convert QR images created with asc2qr.sh
# info an ascii armor pgp key.
#
# This script depends on the following libraries/applications:
#
#   libqrencode (http://fukuchi.org/works/qrencode/)
#   zbar (http://zbar.sourceforge.net)
#
# If you need to backup or restore binary keys, see this link to get started:
#
#   https://gist.github.com/joostrijneveld/59ab61faa21910c8434c#file-gpg2qrcodes-sh
#
#####

# Name of the output key after decoding
output_key_name="mykey.asc"

# Argument/usage check
if [ $# -lt 1 ]; then
	echo "usage: `basename ${0}` <QR image 1> [QR image 2] [...]"
	exit 1
fi

# For each image on the command line, decode it into text
chunks=()
index=1
for img in "$@"; do
	if [ ! -f ${img} ]; then
		echo "image file not found: ${img}"
		exit 1
	fi
	asc_key="${tmp_file}.${index}"
	echo "decoding ${img}"
    chunk=$( zbarimg --raw ${img} 2>/dev/null | perl -p -e 'chomp if eof' )
    # Please use this next line instead of teh one above if zbarimg does
    # not decode the qr code properly in tests
    # (zbarimg needs to be told it is being given a qr code to decode)
    #chunk=$( zbarimg --raw --set disable --set qrcode.enable ${img} 2>/dev/null )
	if [ $? -ne 0 ]; then
		echo "failed to decode QR image"
		exit 2
	fi
    chunks+=("${chunk}")
	index=$((index+1))
done

asc_key=""
for c in "${chunks[@]}"; do
    asc_key+="${c}"
done

echo "creating ${output_key_name}"
echo "${asc_key}" > ${output_key_name}
