# Overview

A container image that has all tools needed to build and Snyk scan any Symphony project.

There are no secret baked in the image, everything is passed as paramater during runtime 

# Build
In order to have more flexibility and use different snyk-api-token without having to update jenkins creds, the snyk-api-token is first encrypted using the master key, then the ciphertext of the token is baked into the container image. 
The Master key is then passed in runtime as a parameter, so that snyk-api-token can be decrypted and used during the container execution. 

Encrypt the secret

    openssl params
    docker build -t snyk-release . 


# Usage
    docker run --rm \
      -e GIT_USER=[username] \
      -e GIT_PASS=[password] \
      -e GIT_REPO=[repo] \
      -e GIT_HASH=[branch|tag] \
      -e SECRET=[master_secret] \
      -e MVN_PASS=[mvn password] \
      -e NPM_PASS=[npm password] \
      -e SNYK_ORG=[org-id] \
      -e SNYK_SCAN=[test|monitor] \
      -e PRJ_TYPE=[java|nodejs] \
      -e JAVA_VERSION=[8|11] \
      -e JAVA_PARAMS=[params] \
      -e NODE_VERSION=[version] \
      snyk-release


# Params
table


# Example.. new org
create org

create sa

encrypt secret

docker build
docker push

configure jenkins
