# Paper Backups of Ascii PGP Keys

Shell scripts to convert between ascii armor PGP keys and QR codes for paper backup.

After exporting your private keys in ascii armor format, you can use the scripts
in this project to convert them to PNG images that can be printed and archived.

This is ever so slightly easier than printing the ascii key directly and using OCR
software to recreate the key.

## Dependencies

This project depends on a couple libraries that come with applicatons that are called
by these scripts.

    libqrencode (http://fukuchi.org/works/qrencode/)
    zbar (http://zbar.sourceforge.net)

## Export keys From GPG

To export keys from GPG use one of these commands:

    gpg --armor --export > pgp-public-keys.asc
    gpg --armor --export-secret-keys > pgp-private-keys.asc
    gpg --armor --gen-revoke [your key ID] > pgp-revocation.asc

*NOTE* Be sure to securely remove your private and revocation keys once they
are correctly backed up. This can be done from the command line with either the 'srm'
tool on Max OS X or with 'shred' on Linux.

## Convert To QR Code Images

Use the asc2qr.sh script to convert a public or private key in ascii armor format
into QR code PNG images.

    [kevin@computer]$ asc2qr.sh ~/gpg_public_key.asc 
    generating QR1.png
    generating QR2.png

    [kevin@computer]$ ls -l
    total 24
    -rw-r--r--  1 kevin  group  6873 Mar  7 11:30 QR1.png
    -rw-r--r--  1 kevin  group  1251 Mar  7 11:30 QR2.png

Print the resulting images and save them in a fireproof safe or safety deposit box.

## Convert To Ascii Armor Key Files

Use the qr2asc.sh script to convert QR code images (created from an photo of
the image) to a public or private key in ascii armor format.

    [kevin@computer]$ qr2asc.sh *.png
    decoding QR1.png
    decoding QR2.png

    [kevin@computer]$ ls -l
    total 32
    -rw-r--r--  1 kevin  group  3127 Mar  7 11:30 mykey.asc

    [kevin@computer]$ diff ~/gpg_public_key.asc mykey.asc 
    [kevin@computer]$

## Import Keys Into GPG

To import keys into GPG use one of these commands:

    gpg --import pgp-public-keys.asc
    gpg --import pgp-private-keys.asc

*NOTE* Be sure to securely remove your private and revocation keys once they
are correctly backed up. This can be done from the command line with either the 'srm'
tool on Max OS X or with 'shred' on Linux.
