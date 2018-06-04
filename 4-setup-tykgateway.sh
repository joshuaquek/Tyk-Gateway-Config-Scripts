#!/bin/bash

sudo yum install pygpgme yum-utils wget

sudo touch /etc/yum.repos.d/tyk_tyk-gateway.repo

sudo echo "[tyk_tyk-gateway]
name=tyk_tyk-gateway
baseurl=https://packagecloud.io/tyk/tyk-gateway/el/7/\$basearch
repo_gpgcheck=1
gpgcheck=1
enabled=1
gpgkey=http://keyserver.tyk.io/tyk.io.rpm.signing.key
       https://packagecloud.io/tyk/tyk-gateway/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300" >> /etc/yum.repos.d/tyk_tyk-gateway.repo

sudo yum install -y epel-release

sudo yum update

sudo yum -q makecache -y --disablerepo='*' --enablerepo='tyk_tyk-gateway' --enablerepo=epel

sudo wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

sudo wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

sudo rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm

sudo yum install redis -y

sudo yum install -y redis tyk-gateway

sudo service redis start

sudo /opt/tyk-gateway/install/setup.sh --listenport=8080 --redishost=localhost --redisport=6379 --domain=""

sudo service tyk-gateway start

# CLEANUP
sudo rm -rf epel-release-6-8.noarch.rpm
sudo rm -rf remi-release-6.rpm