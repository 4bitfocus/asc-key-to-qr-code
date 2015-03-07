# Paper Backups of Ascii PGP Keys

Shell scripts to convert between ascii armor PGP keys and QR codes for paper backup

# Convert Ascii Armor Key Files To QR Code Images

    [kevin@computer]$ asc2qr.sh ~/gpg_public_key.asc 
    generating QR1.png
    generating QR2.png

    [kevin@computer]$ ls -l
    total 24
    -rw-r--r--  1 kevin  group  6873 Mar  7 11:30 QR1.png
    -rw-r--r--  1 kevin  group  1251 Mar  7 11:30 QR2.png

# Convert QR Code Images to Ascii Armor Key Files

    [kevin@computer]$ qr2asc.sh *.png
    decoding QR1.png
    decoding QR2.png

    [kevin@computer]$ ls -l
    total 32
    -rw-r--r--  1 kevin  group  3127 Mar  7 11:30 mykey.asc

    [kevin@computer]$ diff ~/gpg_public_key.asc mykey.asc 
    [kevin@computer]$

