# Overview

A container image that has all tools needed to build and Snyk scan any Symphony project.

There are no secret baked in the image, everything is passed as paramater during runtime 

# Build
In order to have more flexibility and use different snyk-api-token without having to update jenkins creds, the snyk-api-token is first encrypted using the master key, then the ciphertext of the token is baked into the container image. 
The Master key is then passed in runtime as a parameter, so that snyk-api-token can be decrypted and used during the container execution.
Note: the master key is a credential var in Jenkins Server. 

Encrypt the secret
    cp [my-snyk-token-api-path] snyk-token.txt
    openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -in snyk-token.txt -out snyk-token -k [SECRET]
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


# Parametera list
| VAR          | DESCRIPTION                                         | MANDATORY | Type | Example |
|--------------|-----------------------------------------------------|-----------|------| --------|
| GIT_USER     | Github username                                     | Yes       | String | user   |
| GIT_PASS     | Github password                                     | Yes       | String | password123 | 
| GIT_REPO     | Github repo                                         | Yes       | String | github.com/SymphonyOSF/SBE.git |
| GIT_HASH     | Git tab / hash                                      | Yes       | String | 20.12 | 
| SECRET       | Master secret                                       | Yes       | String | master123 | 
| MVN_PASS     | Artifactory maven password for user dev-services.   | Only for java projects      | String | maven123 |
| NPM_PASS     | Artifactory npm password                            | Only for node projects | String base64(username:passwd) | abcde== |
| SNYK_ORG     | Snyk org-id                                         | Yes       | String | 123-123-123 |
| SNYK_SCAN    | Snyk Scan mode [test / monitor]                       | Default test | String | monitor | 
| PRJ_TYPE     | Project Type [java / nodejs]                          | Default nodejs | String | java |
| JAVA_VERSION | Java version [8 / 11]                                 | Default 8 | String | 11 |
| JAVA_PARAMS  | Java additional parameters for mvn build            | No | String | -DskipTests=true |
| NODE_VERSION | Nodejs version                                      | Default 10.21.0 | String | 14.16.1 |
| SNYK_EXCLUDE | Exclude directories from snyk scan                  | No | String | tests |


# Example usage
1. Create snyk org, get the org-id
2. Create a snyk service account in the org, get the api token
3. Ecnrypt the token using the master key

        openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -in snyk-token.txt -out snyk-token -k [SECRET]
4. Build container image

        docker build -t snyk-release . 
5. Tag container image using the org-id as tag

        docker tag snyk-release artifact.symphony.com/[repo]/snyk-release:[org-id]
    
6. Push tag to the registry

        docker push artifact.symphony.com/[repo]/snyk-release:[org-id]
      

7. Create a Jenkins job / with a Jenkinsfile pipeline that triggers the build (see /jobs for examples)
