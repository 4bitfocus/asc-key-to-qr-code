#!/bin/bash

if [ $# -eq 0 ]; then
    echo "usage: $(basename ${0}) <ascii armor key file>"
    exit 1
fi

set -x

asc_key="$1"

./asc2qr.sh "${asc_key}"

./qr2asc.sh QR*.png

diff "${asc_key}" "./mykey.asc"
if [ $? -eq 0 ]; then
    echo "Diff Test: PASS"
else
    echo "Diff Test: FAIL"
fi

rm ./QR*.png
rm ./mykey.asc
