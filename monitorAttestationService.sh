#!/bin/bash
#Scipt for monitoring an attestation service on the Celo network. Documentation can be found here: https://docs.celo.org/getting-started/baklava-testnet/running-a-validator-in-baklava#running-the-attestation-service-1
#Breakdown of script
#   - load local env variables form ~/.bash_profile 
#       - CELO_ATTESTATION_IP
#       - CELO_ATTESTATION_ERRORS
#       - CELO_UNEXPECTED_ERRORS 

#   - CELO_UNEXPECTED_ERRORS and CELO_ATTESTATION_ERRORS hold the state to compare the current value and previous values
#   - Get times to work with and time to send the morning update msg.
#   - Attestation service has prometheus metrics exposed at /metrics. Get and parse the values to see if any errors have occured in the last 5 minutes
#       - Prometheus documentation can be found here https://prometheus.io/
#       - Celo Blockchain inherits [go-ethereum's metrics](https://github.com/ethereum/go-ethereum/wiki/Metrics-and-Monitoring) system
#   - Log output and send message to twilio service if there is an error
#   - Send a daily massage to keep track of the metrics
#       -  This is used so you expect when you do recieve an update there is an issue with your monitoring service 



#
# get local env vars
source ~/.bash_profile

# Set path
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/ubuntu/monitoringTools


# Set IP of Attestation service
IP=$CELO_ATTESTATION_IP
timestamp=`TZ=":America/Vancouver" date '+%a %b %d %Y %I:%M:%S %p %Z'`
timeToLog=`TZ=":America/Vancouver" date +'%H:%M'`
fullLog="$(curl -s -N $IP/metrics | sed -n -e '3 p' -e '7 p' -e '11 p' -e '15 p' -e '19 p' -e '23 p' -e '27 p' -e '31 p' -e '35 p' -e '39 p')"


#Get prometheus metrics

# HELP attestation_requests_failed_to_send_sms Counter for the number of sms that failed to send
# TYPE attestation_requests_failed_to_send_sms counter
attestationErrorsFull="$( curl -s -N $IP/metrics | grep attestation_requests_attestation_errors | sed -n '3 p')"
attestationErrors="$( curl -s -N $IP/metrics | grep attestation_requests_attestation_errors | sed -n '3 p' | cut -d' ' -f2)"
[[ $attestationErrors = $CELO_ATTESTATION_ERRORS ]] && echo "$attestationErrorsFull" >> ~/monitoringTools/logs/logger.log
[[ $attestationErrors != $CELO_ATTESTATION_ERRORS ]] && msg="ATTESTATION SERVICE: Attestation failed error at $timestamp"
[[ $attestationErrors != $CELO_ATTESTATION_ERRORS ]] && echo "$msg" >> ~/monitoringTools/logs/logger.log &&  twilio.sh "$msg"




# HELP attestation_requests_attestation_errors Counter for the number of requests for which producing the attestation failed
# TYPE attestation_requests_attestation_errors counter
unexpectedErrors="$( curl -s -N $IP/metrics | grep attestation_requests_unexpected_errors | sed -n '3 p' | cut -d' ' -f2)"
unexpectedErrorsFull="$( curl -s -N $IP/metrics | grep attestation_requests_unexpected_errors | sed -n '3 p' )"

[[ $unexpectedErrors = $CELO_UNEXPECTED_ERRORS ]] && echo "$unexpectedErrorsFull" >> ~/monitoringTools/logs/logger.log
[[ $unexpectedErrors != $CELO_UNEXPECTED_ERRORS ]] && msg="ATTESTATION SERVICE: Attestation failed with an unexpected error at $timestamp"
[[ $unexpectedErrors != $CELO_UNEXPECTED_ERRORS ]] && echo "$msg" >> ~/monitoringTools/logs/logger.log && twilio.sh "$msg"

# Full log every morning to check service is script is operating and get stats
[[ $timeToLog == "07:30" ]] && twilio.sh "$fullLog"


