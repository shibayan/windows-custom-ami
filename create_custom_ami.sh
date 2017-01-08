#!/bin/bash

instanceId=$(aws ec2 run-instances --cli-input-json file://custom-ami.json --user-data file://userdata.txt | jq -r '.Instances[0].InstanceId')

aws ec2 wait instance-status-ok --instance-ids ${instanceId}
aws ec2 wait instance-stopped --instance-ids ${instanceId}

imageId=$(aws ec2 create-image --instance-id ${instanceId} --name windows-ami-$(date "+%Y%m%d-%H%M%S") | jq -r '.ImageId')

aws ec2 wait image-available --image-ids ${imageId}

aws ec2 terminate-instances --instance-ids ${instanceId}