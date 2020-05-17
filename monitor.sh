#!/bin/bash

#Set path 
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/ubuntu/monitoringTools


#Get current minute
minute=$(TZ=":America/Vancouver" date +"%M");
attestMinute="$(($minute % 10))"

#Get day and time to delete logs
day=$(TZ=":America/Vancouver" date +"%d");
hour=$(TZ=":America/Vancouver" date +"%I")
day="$(($day % 7))"




#Check validator
#monitorMainnet.sh

echo $day 
echo $hour
echo $attestMinute
echo $minute

#Check attestation every 5 minutes
[[ $attestMinute = "0" || $attestMitute = "5" ]] && monitorAttestationService.sh


#Delete logs for the week
[[ $day = "0" && $hour = "07"  && $minute = "01" ]] && "$(sudo  rm ~/monitoringTools/mainnetjob.log && sudo  rm ~/monitoringTools/logs/logger.log )"