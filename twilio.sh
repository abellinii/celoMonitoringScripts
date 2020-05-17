#!/bin/bash

PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/ubuntu/monitoringTools

# usage: twilio.sh 'Hi there, your new phone number is working.'
# load env variables and use for security

#message given to send
msg=$1
account_sid=$TWILIO_ACCOUNT_SID
auth_token=$TWILIO_AUTH_TOKEN
wades_number=$TWILIO_WADES_NUMBER
twilio_number=$TWILIO_NUMBER


    
    
   

#send to wade
curl --silent --output /dev/null -X POST -d "Body=${msg}" \
    -d "From=${twilio_number}" -d "To=${wades_number}" \
    "https://api.twilio.com/2010-04-01/Accounts/${account_sid}/Messages" \
    -u "${account_sid}:${auth_token}"

