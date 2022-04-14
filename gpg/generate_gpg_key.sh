#!/bin/bash

apt install -y gpg haveged

COMPNAME=$1
PASSPHRASE=$2
KEYINFO="${COMPNAME}-key-info.txt"

if [ "$1" == "" ] || [ "$2" == "" ]; then
 echo -e "please put arguments"
 exit 1
fi

if [ -f ${KEYBOX}/${KEYINFO} ]; then
  echo "already exist!"
  exit 1
fi

cat >${KEYINFO}<<EOF
%echo Generating a basic OpenPGP key
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: ${COMPNAME}
Name-Comment: ${COMPNAME}
Name-Email: ${COMPNAME}@tmax.co.kr
Expire-Date: 3y
Passphrase: ${PASSPHRASE}
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
EOF

gpg --batch --generate-key ${KEYINFO}

gpg --batch --export ${COMPNAME} > ${COMPNAME}-public.key
gpg --batch --pinentry-mode=loopback --yes --passphrase ${PASSPHRASE} --export-secret-key ${COMPNAME} > repo_private.key
echo ${PASSPHRASE} > password.txt

apt-key --keyring ${COMPNAME}-archive.gpg add ${COMPNAME}-public.key
