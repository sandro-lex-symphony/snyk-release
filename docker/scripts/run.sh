#!/bin/bash
set -e

# check vars
check_vars.sh

# exec git
git_checkout.sh 

# build prj
build.sh

# exec snyk
snyk_scan.sh


