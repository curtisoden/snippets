#/bin/bash

#This example shows how to create a crontab for the current user that runs a python script every minute. 
#Running script on a schedule can be very useful for retrieving updated configuration data, checking health 
#of other systems, sending health status to other systems, 
#or even periodically pulling the latest app code from your get repo and deploying it to your app server.

#While traditional sysadmins like to edit crontabl manually with contrab -e, 
#we DevOps folks prefer repeatable scripts. 

#Ansible has a great crontab module, but bash is a workable method when Ansible isn't available.

#The particular example assumes "/usr/local/bin/myscript.py" is already on the system, 
#and we're using the python version supplied by conda to execute, 
#logging the scripts output to /var/log/myscript.log

#USEAGE: sh crontab_deply.sh 

#create a temporary crontab file
crontab -l > democrontab
#echo the cron formatted command to the crontab (this sets it to once a minute every day
# - you can't run a cron more than once a minute - and long running jobs will back up, so be careful, write time outs)
echo "*/1 * * * * /opt/conda/bin/python /usr/local/bin/myscript.py >> /var/log/myscript.log 2>&1" >> democrontab

#Chart illustrating what all those ********'s mean in the crontab command:

# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  *  command to be executed


#add the democrontab to the user's current crontab
crontab democrontab
#remove the temporary crontab
rm -f democrontab
#TODO: Running this script multiple time could add multiple copies of of the cron line to the cron tab.
#Future iterations should remove the script from the existing crontab.

exit 0

