#!/bin/bash

ami_id="ami-09c813fb71547fc4f"
sg_id="sg-0836adfedd0b81ee5"
domain_name="aws45.fun"
hosted_zone="Z0240592U12NCJ6BG5HL"
 for instance in $@ #instance=  fronend , backend , databases and $@= 
 do 
      INSTANCE_ID=$(aws ec2 run-instances --image-id $ami_id --instance-type t3.micro --security-group-ids $sg_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)

     if [ $instance != "frontend" ]; then

     IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
       # RECORD_NAME="$instance.$DOMAIN_NAME" # mongodb.daws86s.fun
    else 
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
       # RECORD_NAME="$DOMAIN_NAME" # daws86s.fun
     fi

    echo "$instance: $IP"

   
 done 