#!/bin/bash 

source ./common.sh

check_root

echo "Please enter password"
read root_password



dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"


id expense &>>$LOGFILE

if [ $? -ne 0 ]
then 
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating user"
else
    echo -e "Already user exists $Y Skipping $N"
fi 

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating app directory"


curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading backend code"

cd /app


rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extracted backend code"

npm install &>>$LOGFILE
VALIDATE $? "Installing nodejs dependencies"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Coped backend service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon reload"

systemctl start backend &>>$LOGFILE
VALIDATE  $? "Starting backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Install mysql client"

mysql -h  db.daws9.online -uroot -p${root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restart backend"





