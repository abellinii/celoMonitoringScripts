#!/bin/bash
# based script originally made for TGCSO at https://gist.github.com/yourcodesucks/374c30454ec1d93af028c153baae3bed


#Script to monitor a validators uptime looking at how many blocks have been signed the last nth blocks
#   - Set variables for the correct amount of blocks and for the sensitivity of the alert and restart
#   - Run the lines (line1 and line2)
#   - Evaluate the condition of the validator, log and send message via twilio if there are issues


# get local env vars
source ~/.bash_profile

#Set path
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/ubuntu/celoMonitoringScripts:/Users/wadeabel/celo-accounts-node:~/celo-accounts-node:/Users/wadeabel/.nvm/versions/node/v10.17.0/bin/celocli:/Users/wadeabel/.nvm/versions/node/v10.17.0/bin/:/Users/wadeabel/.nvm/versions/node/v10.17.0/bin/npx



# original short was 50 and med 200
# original thresholds were 10 (zed1) and 3 (zed2)
# by observation, setting zed1=75, zed2=15
mu1=50    #number of blocks to look back for short time period
mu2=200   #number of blocks to look back for medium time period
zed1=75   #if short is less than this percentage, alert
zed2=15    #if medium minus short is greater than this percentage, alert


validatorAddress=$CELO_VALIDATOR_RG_ADDRESS


# a line looks like
# 0xe67a310436b8a3A23A994E4A0B29e8D82721bE7c {Name of your validator} 0xe12B4fe7D0050B1d852b28568b45fFAc548Cc6D4 true    true        0        98%        

# to test if variable is a number, see
# https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
re='^[0-9]+$'  # this is from the above URL


line1=` celocli validator:status --validator $validatorAddress --lookback $mu1 | tail -1` 
line2=` celocli validator:status --validator $validatorAddress --lookback $mu2 | tail -1` 
elected=`awk '{print $(NF - 3)}' <<< $line2`

shortrate=`awk '{print $(NF)}' <<< $line1 | cut -d "%" -f1`
medrate=`awk '{print $(NF)}' <<< $line2 | cut -d "%" -f1`




timestamp=`TZ=":America/Vancouver" date '+%a %b %d %Y %I:%M:%S %p %Z'`
#once in a while we get bad values from celocli, if shortrate or medrate are not numbers, try again
! [[ "$shortrate" =~ ^[0-9]+$ ]] && echo "MAINNET V1: bad shortrate :$shortrate: - trying again at $timestamp" >> ~/monitoringTools/logs/logger.log
! [[ "$shortrate" =~ ^[0-9]+$ ]] && echo "MAINNET V1: bad line is:$line1:" >> ~/monitoringTools/logs/logger.log
! [[ "$shortrate" =~ ^[0-9]+$ ]] && at now + 1 minutes <<< "monitorMainnet.sh" && exit
! [[ "$medrate" =~ ^[0-9]+$ ]] && echo "MAINNET V1: bad medrate :$medrate: - trying again at $timestamp" >> ~/monitoringTools/logs/logger.log
! [[ "$medrate" =~ ^[0-9]+$ ]] && echo "MAINNET V1: bad line is:$line2:" >> ~/monitoringTools/logs/logger.log
! [[ "$medrate" =~ ^[0-9]+$ ]] && at now + 1 minutes <<< "monitorMainnet.sh" && exit
if [ "$elected" = "true" ]
then
  delta=$(($medrate-$shortrate))
  echo "MAINNET V1 $mu2-block rate: $medrate, $mu1-block rate: $shortrate, delta: $delta at $timestamp" >> ~/monitoringTools/logs/logger.log

#restart due to low message signing over last $mu1 blocks
  [ "$shortrate" -lt $zed1 ] && echo "MAINNET V1 ALERT: $mu1-block rate at $timestamp: $shortrate" >> ~/monitoringTools/logs/logger.log
#  [ "$shortrate" -lt $zed1 ] && at now + 1 minutes <<< "monitorMainnet.sh" && exit

#comment out next 4 if there are issues, and comment-in above line
  [ "$shortrate" -lt $zed1 ] && msg="MAINNET V1 RESTART at $timestamp"
  [ "$shortrate" -lt $zed1 ] && echo "$msg" >> ~/monitoringTools/logs/logger.log && twilio.sh "$msg"
  [ "$shortrate" -lt $zed1 ] && at now <<< "restart-1"
  [ "$shortrate" -lt $zed1 ] && at now + 10 minutes <<< "monitorMainnet.sh" && exit
#restart due to rapidly decreasing signing rate ($delta)
  [ "$delta" -gt $zed2 ] && echo "MAINNET V1 ALERT: delta at $timestamp: $medrate, $shortrate, $delta" >> ~/monitoringTools/logs/logger.log
#  [ "$delta" -gt $zed2 ] && at now + 1 minutes <<< "monitorMainnet.sh" && exit
#comment out next 4 if there are issues, and comment-in above line
  [ "$delta" -gt $zed2 ] && msg="MAINNET V1 RESTART at $timestamp"
  [ "$delta" -gt $zed2 ] && echo "$msg" >> ~/monitoringTools/logs/logger.log && twilio.sh "$msg"
  [ "$delta" -gt $zed2 ] && at now <<< "restart-1"
  [ "$delta" -gt $zed2 ] && at now + 10 minutes <<< "monitorMainnet.sh" && exit
  at now + 1 minutes <<< "monitorMainnet.sh" && exit   #otherwise wait a minute and do this again
else  # not elected
  at now + 5 minutes <<< "monitorMainnet.sh" && exit
fi
