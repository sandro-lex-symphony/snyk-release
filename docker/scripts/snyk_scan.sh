#!/bin/bash
set -e

openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -in ${HOME}/snyk-token -out ${HOME}/snyk-token.txt -k $SECRET 
echo "snyk auth ..."                                                                                                                                                                                                                                                                      
snyk auth $(cat ${HOME}/snyk-token.txt)                                                                                                                                                                                                                                                                              
rm ${HOME}/snyk-token.txt 

PARAMS=''
if [ "$JAVA_PARAMS" != "filler" ]
then
    PARAMS=" -- ${JAVA_PARAMS} "
fi
                                                                                                                                                                                                                                                                                          
if [ "$SNYK_SCAN" = "monitor" ]                                                                                                                                                                                                                                                           
then                                                                                                                                                                                                                                                                                      
    echo "Snyk Scan..."                                                                                                                                                                                                                                                                   
    snyk monitor --all-projects --org=$SNYK_ORG $PARAMS || true                                                                                                                                                                                                     
elif [ "$SNYK_SCAN" = "test" ]                                                                                                                                                                                                                                                            
then                                                                                                                                                                                                                                                                                      
    snyk test --all-projects --json-file-output=${HOME}/data/${PRJ}.json $PARAMS || true                                                                                                                                                                                                       
else                                                                                                                                                                                                                                                                                      
    echo "Skiping Snyk Scan ..."                                                                                                                                                                                                                                                          
fi