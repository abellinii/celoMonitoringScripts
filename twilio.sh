#!/bin/bash

#Generic script to send messages to a mobile phone
#   - loads ENV variables for security purposes
#       - TWILIO_ACCOUNT_SID
#       - TWILIO_AUTH_TOKEN
#       - TWILIO_NUMBER_TO_SEND #number you want the message sent to 
#       - TWILIO_NUMBER #Number in your tewilio account
#   - Accepts 1 paramter that is the message you would like to send
#   - Send the message using twilio

#load env vars
source ~/.bash_profile

PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/ubuntu/monitoringTools



#message given to send
msg=$1
account_sid=$TWILIO_ACCOUNT_SID
auth_token=$TWILIO_AUTH_TOKEN
number=$TWILIO_NUMBER_TO_SEND
twilio_number=$TWILIO_NUMBER


    
    
   

#send text message
curl --silent --output /dev/null -X POST -d "Body=${msg}" \
    -d "From=${twilio_number}" -d "To=${number}" \
    "https://api.twilio.com/2010-04-01/Accounts/${account_sid}/Messages" \
    -u "${account_sid}:${auth_token}"

