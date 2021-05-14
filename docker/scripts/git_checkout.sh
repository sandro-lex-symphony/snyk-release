#/bin/bash

set -e

echo "Cloning repo ..."
git clone https://${GIT_USER}:${GIT_PASS}@${GIT_REPO}

cd $(basename $GIT_REPO .git)

echo "Chekout tag ..."
git checkout $GIT_HASH
