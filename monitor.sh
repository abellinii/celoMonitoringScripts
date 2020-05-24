#!/bin/bash

#Main entry point to be called from a cronjob 
#   - set cronjob by $ crobtab -e and adding " *  *  *  *  *   /home/ubuntu/monitoringTools/monitor.sh  >> /home/ubuntu/monitoringTools/mainnetjob.log 2>&1 "
#   - script execution
#       - run monitorMainet.sh to check validator signing health
#       - every 5 minutes run monitorAttestationService.sh to check the attestation service
#       - delete logs every 7 days 

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
monitorMainnet.sh



#Check attestation every 5 minutes
[[ $attestMinute = "0" || $attestMinute = "5" ]] && monitorAttestationService.sh


#Delete logs for the week
[[ $day = "0" && $hour = "07"  && $minute = "01" ]] && "$(sudo  rm ~/monitoringTools/mainnetjob.log && sudo  rm ~/monitoringTools/logs/logger.log )"