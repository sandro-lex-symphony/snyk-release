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


# Parameter list
| VAR          | DESCRIPTION                                         | 
|--------------|-----------------------------------------------------|
| GIT_USER.    | Github username                                     |
| GIT_PASS.    | Github password                                     | 
| GIT_REPO.    | Github repo                                         |
| GIT_HASH.    | Git tab / hash                                      |
| SECRET.      | Master secret                                       |
| MVN_PASS.    | Artifactory maven password for user dev-services.   |
| NPM_PASS.    | Artifactory npm password                            |
| SNYK_ORG.    | Snyk org-id                                         |
| SNYK_SCAN.   | Snyk Scan mode [test|monitor]                       |
| PRJ_TYPE.    | Project Type [java|nodejs]                          |
| JAVA_VERSION | Java version [8|11]                                 |
| JAVA_PARAMS  | Java additional parameters for mvn build            |
| NODE_VERSION | Nodejs version                                      |


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
