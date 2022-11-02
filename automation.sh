#!/bin/bash

echo “The script for task 2 is executing”

#the below part of script will update the existing packages

echo “Script now updating the package information”
apt update -y

# To check if apache2 is installed

echo “Checking if apache2 service is Installed”

#listing the version of apache2 which gives output only if installed
#the block of code checks if apache2 is installed and if not it installs it

status=$(apache2 -v)

if [[ $status == *"Server version"* ]]; then
 echo "apache2 is Installed"
else echo "apache2 is not installed..Starting the installation now"
	sudo apt install apache2 -y
       
fi

#to check if the service apache2 is running if not start it

echo “Checking if apache2 service is running”

servicestatus=$(service apache2 status)

if [[ $servicestatus == *"active (running)"* ]]; then
  echo "process is running"
else echo "process is not running"
	service apache2 start
	echo "started the service"
fi

#to check if apache2 is installed if not will install it

echo "checking if Apache2 is enabled"

servicestatus=$(systemctl status apache2)
if [[ $servicestatus == *"disabled"* ]]; then
  echo "Apache2 is disabled"
  echo "Enabling Apache2"
  systemctl enable apache2
  systemctl start apache2
else echo "Apache2 is Enabled on the system"
	systemctl start apache2
fi

#Creating tar in the given format for all log files in /var/log/apache2 folder
#stores this tar files at tmp location

timestamp=$(date '+%d%m%Y-%H%M%S')

myname="nikeeta"

s3_bucket="upgrad-nikeeta"

echo "Creating tar file for logs under /var/log/apache2"


cd /var/log/apache2

tar -cvf ${myname}-httpd-logs-${timestamp}.tar *.log && rm *.log
mv *.tar /tmp/
systemctl stop apache2
systemctl start apache2

#moving the tar from tmp to S3

echo "Moving tar to now S3"
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

#using crontab to schedule  CRON JOB to run the automation.sh script everyday at 2 AM
crontab -l > /etc/cron.d/automation

echo "0 2 * * * /bin/sh /root/Automation_Project/automation.sh" >> /etc/cron.d/automation

crontab automation
rm automation

# creating a bookkeeping for all tar files created in inventory.html file
#this code also created the file if this does not exist

File='/var/www/html/inventory.html'
BckupFile="$(ls  /tmp/*.tar | sort -V | tail -n1)"
echo $BckupFile
size=$(wc -c "$BckupFile" | awk '{print $1}')
echo $timestamp
echo $size
if test -f "$File"
then
echo "$File exist "
echo -e "httpd-logs\t\t$timestamp\t\ttar\t\t$size" >> $File
else
mkdir -p /var/www/html;
echo "filenotpresent"
echo -e 'Log Type\t\tTime Created\t\tType\t\tSize' >> $File
fi
#END OF CODE
#=====================================================================
