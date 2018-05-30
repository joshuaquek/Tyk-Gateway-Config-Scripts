#!/bin/bash

REGION=`sudo curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r`

INSTANCEID=`sudo curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .instanceId -r`

sudo -i aws configure set region $REGION

sudo -i aws configure

EC2PUBLICIPADDRESS=`sudo -i aws ec2 describe-instances --instance-ids $INSTANCEID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text`

sudo /opt/tyk-dashboard/install/bootstrap.sh $EC2PUBLICIPADDRESS