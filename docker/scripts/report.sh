#!/bin/bash

# configure snykctl 

# descrypt snyk token
openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -in ${HOME}/snyk-token -out ${HOME}/snyk-token.txt -k $SECRET 

SNYK_TOKEN=$(cat ~/token.txt)
echo "[DEFAULT]" > ~/.snykctl
echo "group_token = $SNYK_TOKEN" >> ~/.snykctl
echo "group_id = $SNYK_ORG"  >> ~/.snykctl
                                       
# gather issues data from snyk server
TABLE = $(snykctl issue-count $SNYK_ORG)

MESSAGE="<messageML>$TABLE</messageML>"

# decrypt webhook if
openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -in ${HOME}/webhook-id -out ${HOME}/webhook-id.txt -k $SECRET 
WEBHOOKID = $(cat ~/webhook-id.txt)

URL = "https://corporate.symphony.com/integration/v1/whi/simpleWebHookIntegration/$WEBHOOKID"

curl -X POST -d "payload=$MESSAGE" $URL

# cleanup
rm ~/token.txt
rm ~/webhook-id.txt
rm ~/.snykctl