#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
MONGODB_HOST=mongodb.aws45.fun
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log

mkdir -p $LOGS_FOLDER
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege"
    #exit 1 # failure is other than 0
fi

VALIDATE(){ # functions receive inputs through args just like shell script args
    if [ $1 -ne 0 ]; then
        echo -e " $2 ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e " $2 ... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}
dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "validate disbaling node js"
dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "checkinig  ebacle "
dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "installing NODEjs"

id roboshop
if [  $? -ne 0 ]; then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
VALIDATE $? "creating sysytem user"
else 
echo "user already exist ..$Y SKIPPING $N"
fi

mkdir -p /app  &>>$LOG_FILE
VALIDATE $? " creating appdirectoy"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOG_FILE
VALIDATE $? "downloading catalouge application"

cd /app
VALIDATE $? "changing to app direcoty"
rm -rf /app/*
VALIDATE  $? "removing existing code"

unzip /tmp/catalogue.zip &>>$LOG_FILE
VALIDATE $? "unzip catalogue"

npm install
VALIDATE $? " installing dependenies/packages"

# Copy systemd service file
cp /home/ec2-user/shell-roboshop/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "copying systemctl service"

systemctl daemon-reload

systemctl enable catalogue  &>>$LOG_FILE
VALIDATE $? " enabling catalougue"

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
VALIDATE $? "copy mongo repo "
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "istalling mongodb client"

mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
VALIDATE $? "load mongodb host"
systemctl restart catalogue &>>$LOG_FILE
VALIDATE $? "restarting catalogue"