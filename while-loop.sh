#!/bin/bash

count=$1
echo "count numbers increment....."
while [ $count -ne 25 ] #[ $count -gt 0  ]
do
echo " time left ::..$count"
#count=$((count -1)) #decrement the count
count=$((count+1)) #increment the count
done
echo "time is up"