#!/bin/bash

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log
mkdir -p $LOGS_FOLDER
echo "script started executed at : $(date)"
SOURCE_DIR=/home/ec2-user/app-logs

fi [ ! -d $SOURCE_DIR ];then
echo -e "ERROR:: $SOURCE_DIR dose not exist"
exit 1
fi
files_to_delete=$(find $SOURCE_DIR -name "*.log" -mtime +4)

while IFS=read -r filepath
do 
   echo "deleting the file: $filepath"
   rm -rf $filepath 

done <<< $files_to_delete