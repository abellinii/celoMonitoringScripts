# Celo Monitoring Tools

## Overview

Set of tools to monitor all needs for being a validator on the [Celo network](https://www.celo.org).

Running a validator consists of running at least three seperate machines. A proxy that is connect to the internet,  a validator that is connect via a private network  communicating with the proxy and an attestation service for mapping mobile phone numbers to cryptographic addresses. These scripts monitor the health of the validator and the attestation service. For the time being they DO NOT manage the health of the machines that these services are running on.


## Instructions

Set environment variables so the scripts can read information securely.

### LINUX
- source ~/.bash_profile
- set env variables
    - Attestation 
        - CELO_ATTESTATION_IP
        - CELO_ATTESTATION_ERRORS
        - CELO_UNEXPECTED_ERRORS 
    - Twilio
        - TWILIO_ACCOUNT_SID
        - TWILIO_AUTH_TOKEN
        - TWILIO_NUMBER_TO_SEND 
        - TWILIO_NUMBER 
    - Validator
        - CELO_VALIDATOR_RG_ADDRESS

### Install Celo cli

[Install the Celo cli](https://docs.celo.org/command-line-interface/introduction#prerequisites)

### Install this package

On the machine you have your env variables and the celo cli installed
    - mkdir monitoringTools && cd monitoringTools
    - wget https://github.com/abellinii/celoMonitoringScripts.git
    - Set cronjob to run every minute by $ crontab -e and " *  *  *  *  *   /home/ubuntu/monitoringTools/monitor.sh  >> /home/ubuntu/monitoringTools/mainnetjob.log 2>&1 "
        - this will also provide a log to help with debugging




## Useful documents

- [Celo Docs](https://docs.celo.org/)

- [Running Celo Validator](https://docs.celo.org/getting-started/baklava-testnet/running-a-validator-in-baklava)

- [Rewards and Slashing](https://docs.celo.org/celo-codebase/protocol/proof-of-stake/epoch-rewards/validator-rewards)


