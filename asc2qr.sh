#!/bin/bash

#####
#
# Author: Kevin Douglas <douglk@gmail.com>
#
# Simple command line script to backup ascii armor gpg keys to paper. You can
# use the following commands to export your keys in ascii armor format:
#
#   gpg --armor --export > pgp-public-keys.asc
#   gpg --armor --export-secret-keys > pgp-private-keys.asc
#   gpg --armor --gen-revoke [your key ID] > pgp-revocation.asc
#
# These can then be used to restore your keys if necessary.
#
# This script will allow you to convert the above ascii armor keys into a
# printable QR code for long-term archival.
#
# This script depends on the following libraries/applications:
#
#   libqrencode (http://fukuchi.org/works/qrencode/)
#
# If you need to backup or restore binary keys, see this link to get started:
#
#   https://gist.github.com/joostrijneveld/59ab61faa21910c8434c#file-gpg2qrcodes-sh
#
#####

# Maximum chuck size to send to the QR encoder. QR version 40 supports
# 2,953 bytes of storage.
file_split_size=2800

# Prefix string for the PNG images that are produced
image_prefix="QR"

# Argument/usage check
if [ $# -ne 1 ]; then
	echo "usage: `basename ${0}` <ascii armor key file>"
	exit 1
fi

asc_key=${1}
if [ ! -f ${asc_key} ]; then
	echo "key file not found: ${asc_key}"
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

# Split the key file into usable chunks that the QR encoder can consume
split -b ${file_split_size} ${asc_key} "${tmp_file}."

# For each chunk, encode it into a qc image
index=1
for file in ${tmp_file}.*; do
	img="${image_prefix}${index}.png"
	echo "generating ${img}"
	cat ${file} | qrencode -o ${img}
	if [ $? -ne 0 ]; then
		echo "failed to encode image"
		exit 2
	fi
	index=$((index+1))
done

# Find the correct secure deletion utility (srm on Mac, shred on Linux)
sec_del="srm"
which ${sec_del} 2>&1 1>/dev/null
if [ $? -ne 0 ]; then
	sec_del="shred --remove"
fi

# Securely clean up temporary files
${sec_del} ${tmp_file}
${sec_del} ${tmp_file}.*
