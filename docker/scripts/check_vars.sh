#!/bin/bash 

# check presense of all mandatory vars
# exit 1 if fail

STATUS=0
# check vars
if [ -z ${GIT_REPO+x} ] || [ "$GIT_REPO" = "filler" ]
then
    echo "ERROR: GIT_REPO env var not set"
    STATUS=1
fi

if [ -z ${GIT_USER+x} ] || [ "$GIT_USER" = "filler" ]
then
    echo "ERROR: GIT_USER env var not set"
    STATUS=1
fi

if [ -z ${GIT_PASS+x} ]  || [ "$GIT_PASS" = "filler" ]
then
    echo "ERROR: GIT_PASS env var not set"
    STATUS=1
fi

if [ -z ${GIT_HASH+x} ]  || [ "$GIT_HASH" = "filler" ]
then
    echo "ERROR: GIT_HASH env var not set"
    STATUS=1
fi

if [ -z ${PRJ_TYPE+x} ]  || [ "$PRJ_TYPE" = "filler" ]
then
    echo "ERROR: PRJ_TYPE env var not set"
    STATUS=1
fi

if [ -z ${MVN_PASS+x} ]  || [ "$MVN_PASS" = "filler" ]
then
    echo "ERROR: MVN_PAS env var not set"
    STATUS=1
fi

if [ -z ${NPM_PASS+x} ]  || [ "$NPM_PAS" = "filler" ]
then
    echo "ERROR: NPM_PASS env var not set"
    STATUS=1
fi

if [ -z ${SECRET+x} ]  || [ "$SECRET" = "filler" ]
then
    echo "ERROR: SECRET env var not set"
    STATUS=1
fi

exit $STATUS
