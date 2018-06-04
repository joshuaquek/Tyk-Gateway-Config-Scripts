#!/bin/bash

sudo yum install pygpgme yum-utils wget

sudo touch /etc/yum.repos.d/tyk_tyk-pump.repo

sudo echo "[tyk_tyk-pump]
name=tyk_tyk-pump
baseurl=https://packagecloud.io/tyk/tyk-pump/el/7/\$basearch
repo_gpgcheck=1
gpgcheck=1
enabled=1
gpgkey=http://keyserver.tyk.io/tyk.io.rpm.signing.key
       https://packagecloud.io/tyk/tyk-pump/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300" >> /etc/yum.repos.d/tyk_tyk-pump.repo

sudo yum -q makecache -y --disablerepo='*' --enablerepo='tyk_tyk-pump'

sudo yum install -y tyk-pump

sudo /opt/tyk-pump/install/setup.sh --redishost=localhost --redisport=6379 --mongo=mongodb://127.0.0.1/tyk_analytics

sudo service tyk-pump start