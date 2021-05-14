#!/bin/bash
set -e

#buildah bud -f docker/Dockerfile -t snyk-release docker/

docker build -f docker/Dockefile -t snyk-release docker/
docker tag snyk-release artifact.symphony.com/slex-reg-test/snyk-release:experimental
docker push artifact.symphony.com/slex-reg-test/snyk-release:experimental






