#!/bin/bash

set -e 

build_node() {
    set -e 
    INSTALLED_NODE_VERSION=$(node --version)
    echo "Installed nodejs version: ${INSTALLED_NODE_VERSION}"

    if [ "$NODE_VERSION" != "$INSTALLED_NODE_VERSION" ]
    then
        echo "Have to change Nodejs version ..."
        NVM_DIR="${HOME}/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        nvm install $NODE_VERSION
    fi

    # replace artifactory password in npmrc file
    sed -i s/xxx/${NPM_PASS}/g ${HOME}/.npmrc

    echo "Install npm deps ..."
    cd $(basename $GIT_REPO .git)
    npm install

    rm ${HOME}/.npmrc
}

build_java() {
    set -e 
    if [ "$JAVA_VERSION" = "8" ]
    then
        update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
    elif [ "$JAVA_VERSION" = "11" ]
    then
        update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java
    fi
    
    echo "Using Java Version"
    java -version

    # replace artifactory password in mvn settings file
    sed -i "s/xxx/${MVN_PASS}/g" ${HOME}/.m2/settings.xml

    # specific usage for rtc-media-bridge
    export ARTIFACTORY_USERNAME=dev-services
    export ARTIFACTORY_PASSWORD=${MVN_PASS}

    cd $(basename $GIT_REPO .git)
    echo "Building maven prj ..."
    if [ "$JAVA_PARAMS" = "filler" ]
    then
        PARAMS=''
    else
        PARAMS=$JAVA_PARAMS
    fi

    mvn clean install -U -B -ntp $PARAMS
}

if [ "$PRJ_TYPE" = "nodejs" ]
then
    echo "Going to nodejs project ..."
    build_node
else
    echo "Going to build java projects ..."
    build_java
fi


