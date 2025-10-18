#!/bin/bash

count=$1
echo "count down....."
while [ $count -gt 0 ]
do
echo " time left ::..$1"
count=$($count -1)
done
echo "time is up"