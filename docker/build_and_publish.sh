#!/bin/bash
set -e

#buildah bud -f docker/Dockerfile -t snyk-release docker/

#docker build -f docker/Dockefile -t snyk-release docker/
DOCKER_BUILDKIT=1 docker build -f docker/Dockerfile --no-cache --secret id=master,src=master.txt --secret id=org_token_plain,src=token.txt  -t snyk-release docker/
#docker tag snyk-release artifact.symphony.com/slex-reg-test/snyk-release:experimental
#docker push artifact.symphony.com/slex-reg-test/snyk-release:experimental






