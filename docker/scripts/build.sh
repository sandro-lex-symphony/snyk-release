#!/bin/bash

set -e 

replace_secrets() {
    # replace artifactory password in npmrc file
    sed -i s/xxx/${NPM_PASS}/g ${HOME}/.npmrc

    # replace artifactory password in mvn settings file
    sed -i "s/xxx/${MVN_PASS}/g" ${HOME}/.m2/settings.xml
}


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

    if [ "$YARN_VERSION" != "" ]
    then
        echo "Going to install yarn version $YARN_VERSION "
	.  ~/.yvm/yvm.sh
	yvm install $YARN_VERSION
	yvm use $YARN_VERSION

	echo "Install npm deps ..."
	cd $(basename $GIT_REPO .git)
	yarn install
    else 

        echo "Install npm deps ..."
        cd $(basename $GIT_REPO .git)
        npm install
    fi

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
    
    echo "Using Java Version:"
    java -version

    # specific usage for rtc-media-bridge
    export ARTIFACTORY_USERNAME=dev-services
    export ARTIFACTORY_PASSWORD=${MVN_PASS}

    cd $(basename $GIT_REPO .git)
    echo "Building maven prj ..."

    if [ "$JAVA_BUILD_CMD" == "filler" ]
    then
        JAVA_BUILD_CMD="mvn clean package -U -B -ntp"
    fi

    if [ "$JAVA_PARAMS" = "filler" ]
    then
        PARAMS=''
    else
        PARAMS=$JAVA_PARAMS
    fi

    echo "[COMMAND]: $JAVA_BUILD_CMD $PARAMS"
    $JAVA_BUILD_CMD $PARAMS
}

echo "XXXXXX ${BUILD_NUMBER} XXXXX"
replace_secrets

if [ "$PRJ_TYPE" = "nodejs" ]
then
    echo "Going to build nodejs project ..."
    build_node
else
    echo "Going to build java projects ..."
    build_java
fi


