#!/bin/bash

echo "ec2 run-instances"
instanceId=$(aws ec2 run-instances --cli-input-json file://custom-ami.json --user-data file://userdata.txt --query "Instances[0].InstanceId" --output text)

echo "wait instance-status-ok - ${instanceId}"
aws ec2 wait instance-status-ok --instance-ids ${instanceId}

echo "wait instance-stopped - ${instanceId}"
aws ec2 wait instance-stopped --instance-ids ${instanceId}

echo "ec2 create-image"
imageId=$(aws ec2 create-image --instance-id ${instanceId} --name windows-ami-$(date "+%Y%m%d-%H%M%S") --query "ImageId" --output text)

echo "wait image-available - ${imageId}"
aws ec2 wait image-available --image-ids ${imageId}

echo "ec2 terminate-instances - ${instanceId}"
aws ec2 terminate-instances --instance-ids ${instanceId}