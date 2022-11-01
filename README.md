# Automation_Project
upgrad project related
#This project hosts the script that is created as automation.sh
#The script performs a number of tasks as follows
#Performs an update of the package details and the package list at the start of the script.
#Installs the apache2 package if it is not already installed. 
#Ensures that the apache2 service is running. 
#Ensures that the apache2 service is enabled. 
#Creates a tar archive of apache2 access logs and error logs that are present in the /var/log/apache2/ directory and place the tar into the /tmp/ directory. Creates a tar of only the .log files (for example access.log) and not any other file type (For example: .zip and .tar) that are already present in the /var/log/apache2/ directory. 
#The name of tar archive have following format:  <your _name>-httpd-logs-<timestamp>.tar. For example: Ritik-httpd-logs-01212021-101010.tar                                                             Hint : use timestamp=$(date '+%d%m%Y-%H%M%S') )
#The script runs the AWS CLI command and copy the archive to the s3 bucket. 
