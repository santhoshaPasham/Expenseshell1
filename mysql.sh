#!/bin/bash


source ./common.sh

Check_root

echo "Please enter password"
read root_password

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing mysql-server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting mysql server"

mysql -h db.daws9.online -uroot -p${root_password} -e 'SHOW DATABASES;' &>>$LOGFILE
if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass $root_password &>>$LOGFILE
    VALIDATE $? "Root password setup"
else 
    echo -e "MYSQL root password is already setup....$Y SKIPPING $N"
fi 






