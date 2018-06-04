#!/bin/bash

sudo yum install python34

sudo yum install pygpgme yum-utils wget

sudo yum install unzip

sudo yum install nano

sudo wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip

sudo unzip awscli-bundle.zip

sudo ./awscli-bundle/install -b ~/bin/aws

sudo echo $PATH | grep ~/bin

sudo export PATH=~/bin:$PATH

sudo wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64

sudo chmod +x ./jq

sudo cp jq /usr/bin

REGION=`sudo curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r`

INSTANCEID=`sudo curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .instanceId -r`

sudo -i aws configure set region $REGION

sudo -i aws configure

EC2PUBLICIPADDRESS=`sudo -i aws ec2 describe-instances --instance-ids $INSTANCEID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text`

sudo touch /etc/yum.repos.d/tyk_tyk-dashboard.repo

sudo echo "
[tyk_tyk-dashboard]
name=tyk_tyk-dashboard
baseurl=https://packagecloud.io/tyk/tyk-dashboard/el/7/\$basearch
repo_gpgcheck=1
gpgcheck=1
enabled=1
gpgkey=http://keyserver.tyk.io/tyk.io.rpm.signing.key
       https://packagecloud.io/tyk/tyk-dashboard/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
" >> /etc/yum.repos.d/tyk_tyk-dashboard.repo

sudo touch /etc/yum.repos.d/mongodb-org-3.0.repo

sudo echo "
[mongodb-org-3.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.0/x86_64/
gpgcheck=0
enabled=1
" >> /etc/yum.repos.d/mongodb-org-3.0.repo

sudo yum -q makecache -y --disablerepo='*' --enablerepo='tyk_tyk-dashboard'

sudo wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

sudo wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

sudo rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm

sudo yum install redis -y

sudo yum install -y mongodb-org tyk-dashboard redis

sudo service mongod start

sudo service redis start

sudo /opt/tyk-dashboard/install/setup.sh --listenport=3000 --redishost=localhost --redisport=6379 --mongo=mongodb://127.0.0.1/tyk_analytics --tyk_api_hostname=$HOSTNAME --tyk_node_hostname=http://localhost --tyk_node_port=8080--portal_root=/portal --domain="$EC2PUBLICIPADDRESS"

sudo service tyk-dashboard start

#CLEANUP
sudo rm -rf awscli-bundle
sudo rm -rf awscli-bundle.zip
sudo rm -rf epel-release-6-8.noarch.rpm
sudo rm -rf jq
sudo rm -rf remi-release-6.rpm

##  NextSteps
##  1. Go to http://yourhostname:3000/ and enter in your TYK license Key
##  2. Restart the TYK Gateway --> `sudo service tyk-dashboard restart`
##  3. Run `bootstrap.sh`