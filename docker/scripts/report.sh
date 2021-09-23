#!/bin/bash

# configure snykctl 
openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -in ${HOME}/snyk-token -out ${HOME}/snyk-token.txt -k $SECRET 
SNYK_TOKEN=$(cat ~/token.txt)
echo "[DEFAULT]" > ~/.snykctl
echo "group_token = $SNYK_TOKEN" >> ~/.snykctl
echo "group_id = $SNYK_ORG"  >> ~/.snykctl
                                       
# gather issues data from snyk server
snykctl issue-count $SNYK_ORG

# cleanup
rm ~/token.txt
rm ~/.snykctl