#!/bin/bash
# this script will restart v1 and p1
# the only way I could figure out to restart a remote screen is to use the -dmS flag to create the screen
# then use the -X stuff to inject the startup script into the screen session
# following was helpful:
# https://stackoverflow.com/questions/6534386/how-can-i-script-gnu-screen-to-start-with-a-program-running-inside-of-it-so-that/6655931#6655931
#### JLH order is important!!!!
echo 'stopping V1...'
ssh qoor-v1 './stop-v'
echo 'stopping P1...'
ssh qoor-p1 './stop-p'
echo 'starting P1...'
ssh qoor-p1 screen -dmS celo
ssh qoor-p1 screen -S celo -p 0 -X stuff "./start-p$(printf \\r)"
sleep 10
echo 'starting V1...'
ssh qoor-v1 screen -dmS celo
ssh qoor-v1 screen -S celo -p 0 -X stuff "./start-v$(printf \\r)"
echo "done"