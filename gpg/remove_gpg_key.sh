#!/bin/bash

USERNAME=$1

if [ "$1" == "" ]; then
 echo -e "please put arguments"
 exit 1
fi

gpg --delete-secret-key ${USERNAME}
gpg --delete-key ${USERNAME}

rm *.key
rm *.gpg
rm *.txt
