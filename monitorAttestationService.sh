#!/bin/bash

#Set path
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/ubuntu/monitoringTools


#Set IP of Attestation service
IP=3.94.31.159
timestamp=`TZ=":America/Vancouver" date '+%a %b %d %Y %I:%M:%S %p %Z'`
timeToLog=`TZ=":America/Vancouver" date +'%H:%M'`
fullLog="$(curl -s -N $IP/metrics | sed -n -e '3 p' -e '7 p' -e '11 p' -e '15 p' -e '19 p' -e '23 p' -e '27 p' -e '31 p' -e '35 p' -e '39 p')"
echo $timeToLog
echo $fullLog

#Get prometheus metrics

# HELP attestation_requests_failed_to_send_sms Counter for the number of sms that failed to send
# TYPE attestation_requests_failed_to_send_sms counter
unexpectedErrors="$( curl -s -N $IP/metrics | grep attestation_requests_unexpected_errors | sed -n '3 p' | cut -d' ' -f2)"
unexpectedErrorsFull="$( curl -s -N $IP/metrics | grep attestation_requests_unexpected_errors | sed -n '3 p' )"

# HELP attestation_requests_attestation_errors Counter for the number of requests for which producing the attestation failed
# TYPE attestation_requests_attestation_errors counter
attestationErrorsFull="$(sudo curl -s -N $IP/metrics | grep attestation_requests_attestation_errors | sed -n '3 p')"
attestationErrors="$(sudo curl -s -N $IP/metrics | grep attestation_requests_attestation_errors | sed -n '3 p' | cut -d' ' -f2)"
[[ $attestationErrors = $CELO_ATTESTATION_ERRORS ]] && echo "$attestationErrorsFull" > ~/monitoringTools/logs/logger.log
[[ $attestationErrors != $CELO_ATTESTATION_ERRORS ]] && msg="ATTESTATION SERVICE: Attestation failed error at $timestamp"
[[ $attestationErrors != $CELO_ATTESTATION_ERRORS ]] && echo "$msg" >> ~/monitoringTools/logs/logger.log &&  twilio.sh "$msg"


[[ $unexpectedErrors != $CELO_UNEXPECTED_ERRORS ]] && echo "$unexpectedErrorsFull" > ~/monitoringTools/logs/logger.log
[[ $unexpectedErrors != $CELO_UNEXPECTED_ERRORS ]] && msg="ATTESTATION SERVICE: Attestation failed with an unexpected error at $timestamp"
[[ $unexpectedErrors != $CELO_UNEXPECTED_ERRORS ]] && echo "$msg" >> ~/monitoringTools/logs/logger.log && twilio.sh "$msg"


[[ $timeToLog == "07:30" ]] && twilio.sh "$fullLog"


