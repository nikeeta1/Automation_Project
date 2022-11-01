#!/bin/bash

echo “The script for task 2 is executing”

echo “Script now updating the package information”
apt update -y


echo “Checking if apache2 service is Installed”

status=$(apache2 -v)

if [[ $status == *"Server version"* ]]; then
 echo "apache2 is Installed"
else echo "apache2 is not installed..Starting the installation now"
	sudo apt install apache2 -y
       
fi

echo “Checking if apache2 service is running”

servicestatus=$(service apache2 status)

if [[ $servicestatus == *"active (running)"* ]]; then
  echo "process is running"
else echo "process is not running"
	service apache2 start
	echo "started the service"
fi

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

timestamp=$(date '+%d%m%Y-%H%M%S')

myname="nikeeta"

s3_bucket="upgrad-nikeeta"

echo "Creating tar file for logs under /var/log/apache2"


cd /var/log/apache2

tar -cvf ${myname}-httpd-logs-${timestamp}.tar *.log && rm *.log
mv *.tar /tmp/

echo "Moving tar to now S3"
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

