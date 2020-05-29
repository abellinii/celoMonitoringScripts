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
    - Attestation
        - ATTESTATION_SERVICE_SWITCH
        
### Install Celo cli

[Install the Celo cli](https://docs.celo.org/command-line-interface/introduction#prerequisites)

### Install this package

On the machine you have your env variables and the celo cli installed
    - mkdir monitoringTools && cd monitoringTools
    - wget https://github.com/abellinii/celoMonitoringScripts.git
    - Set cronjob to run every minute by $ crontab -e and " *  *  *  *  *   /home/ubuntu/celoMonitoringScripts/monitor.sh  >> /home/ubuntu/celoMonitoringScripts/mainnetjob.log 2>&1 "
        - this will also provide a log to help with debugging

### Settings

Set the Attestation service logging to on by setting ATTESTATION_SERVICE_SWITCH=1 and ATTESTATION_SERVICE_SWITCH=0 to turn it off

# Includes

## Terraform Celo Validator Stack 

### Overview

Inital setup forked from (Celo Repo)[https://github.com/celo-org/celo-monorepo/tree/master/packages/terraform-modules-public/aws] and modified

[Terraform](https://www.terraform.io) is a tool by Hashicorp that allows developers to treat _"infrastructure as code"_, easying the management and repeatibility of the
infrastructure.
Infrastructure and all kind of cloud resources are defined in modules, and Terraform creates/changes/destroys when changes are applied.

Inside the [testnet](./testnet) folder you will find a module (and submodules) to create the setup for running a Celo Validator on Google Cloud Platform. The next logic resources can be created:

- `proxy` module for creating a Geth Proxy connected to a validator
- `validator` module for deploying a Validator
- `tx-node` for deploying a transaction node (also known as full-node), thought to expose the rpc interface and allows interaction with the network easily
- `attestation-service` for deploying the Attestation Service (https://docs.celo.org/getting-started/baklava-testnet/running-a-validator#running-the-attestation-service)

The proxy, validator and tx-node services includes the [geth-exporter](https://github.com/status-im/geth_exporter) service to export geth metrics for Prometheus. Serving at port 9200, you can configure your Prometheus server to collect the metrics at endpoint http://<instance>:9200/metrics

## Requirements

Inside the [example](./example) folder you can find an example tf to use the module. We recommend you to use that tf as base file for your deployment, modifying the account variables used for your convenience.
Alternatively you can take that tf files as base for customizing your deployment. Please take care specially about the VPC network configuration. The validators nodes deployed have not a public IP so the access to them is restricted. In order to provide outbound connection of these nodes the VPC network has to be configured with a NAT service allowing external traffic.




## Useful documents

- [Celo Docs](https://docs.celo.org/)

- [Running Celo Validator](https://docs.celo.org/getting-started/baklava-testnet/running-a-validator-in-baklava)

- [Rewards and Slashing](https://docs.celo.org/celo-codebase/protocol/proof-of-stake/epoch-rewards/validator-rewards)


