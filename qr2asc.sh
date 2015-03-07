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

# Create a temp file to use as a pattern for splitting the input key file.
# This helps protect against file collisions in the current directory.
export TMPDIR=""
tmp_file=$(mktemp keyparts.XXXXXX)
if [ $? -ne 0 ]; then
	echo "failed to create temporary file"
	exit 1
fi

# For each image on the command line, decode it into text
index=1
for img in "$@"; do
	if [ ! -f ${img} ]; then
		echo "image file not found: ${img}"
		exit 1
	fi
	asc_key="${tmp_file}.${index}"
	echo "decoding ${img}"
	zbarimg --raw ${img} 2>/dev/null | perl -p -e 'chomp if eof' > ${asc_key}
	if [ $? -ne 0 ]; then
		echo "failed to decode QR image"
		exit 2
	fi
	index=$((index+1))
done

echo "creating ${output_key_name}"
cat ${tmp_file}.* > ${output_key_name}

# Find the correct secure deletion utility (srm on Mac, shred on Linux)
sec_del="srm"
which ${sec_del} 2>&1 1>/dev/null
if [ $? -ne 0 ]; then
	sec_del="shred --remove"
fi

# Securely clean up temporary files
${sec_del} ${tmp_file}
${sec_del} ${tmp_file}.*
