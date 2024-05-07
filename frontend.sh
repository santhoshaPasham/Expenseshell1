#!/bin/bash 

source ./common.sh

check_root


dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Validate existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip  &>>$LOGFILE
VALIDATE $? "Downloading frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Unzipping frontend code"

cp /home/ec2-user/Expenseshell1/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Validate expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"


