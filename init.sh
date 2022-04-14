#!/bin/bash

cat >/etc/aptly.conf<<EOF
{
  "rootDir": "/var/spool/aptly",
  "downloadConcurrency": 4,
  "downloadSpeedLimit": 0,
  "architectures": [],
  "dependencyFollowSuggests": false,
  "dependencyFollowRecommends": false,
  "dependencyFollowAllVariants": false,
  "dependencyFollowSource": false,
  "dependencyVerboseResolve": false,
  "gpgDisableSign": false,
  "gpgDisableVerify": false,
  "gpgProvider": "gpg2",
  "downloadSourcePackages": false,
  "skipLegacyPool": true,
  "ppaDistributorID": "ubuntu",
  "ppaCodename": "",
  "skipContentsPublishing": false,
  "FileSystemPublishEndpoints": {},
  "S3PublishEndpoints": {},
  "SwiftPublishEndpoints": {}
}
EOF

if [ ! -e "gpg/repo_private.key" ]; then
  echo -e "please put repo private key"
  exit 1
fi

gpg --import gpg/repo_private.key

cp gpg/*.gpg /etc/apt/trusted.gpg.d/

cat >/etc/nginx/conf.d/repo.conf<<EOF
server {
  listen 80;
  server_name tos-repo;
  root /var/spool/aptly/public;

  location / {
    autoindex on;
  }
}
EOF
rm /etc/nginx/sites-enabled/*
service nginx start

echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
service ssh start

while true
do
  sleep 30
done
