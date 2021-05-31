# Snyk Release scanner

This project aims to automate OSS vuln scanning for Symphony Releases, leveraging jenkins pipelines

# Overview
### docker/
A container image is created with all tools needed to build and scan any Symphony project.

### jobs/executor
A Jenkinsfile used to create a Jenkins Pipeline execute each project scan. 

### jobs/orchestrator
A Jenkinsfile used to create a Release manifest, describing the list of projects and the parameters for each project

