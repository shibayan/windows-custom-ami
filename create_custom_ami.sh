#!/bin/bash

instanceId=$(aws ec2 run-instances --cli-input-json file://custom-ami.json --user-data file://userdata.txt | jq -r '.Instances[0].InstanceId')

aws ec2 wait instance-stopped --instance-ids ${instanceId}

aws ec2 create-image --instance-id ${instanceId} --name custom-ami