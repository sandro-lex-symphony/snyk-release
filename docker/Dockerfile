# syntax = docker/dockerfile:1.2
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
ENV GIT_REPO filler 
ENV GIT_USER filler
ENV GIT_PASS filler
ENV GIT_HASH filler
ENV MVN_PASS filler
ENV NPM_PASS filler
ENV PRJ_TYPE nodejs
ENV NODE_VERSION v10.21.0
ENV JAVA_VERSION 8
ENV JAVA_PARAMS filler
ENV SNYK_SCAN test
ENV SECRET filler
ENV BUILD_NUMBER filler

RUN apt-get update -y && \
	apt-get install -y openjdk-8-jdk:amd64 maven git vim wget unzip python3 python3-pip python \
	&& rm -rf /var/lib/apt/lists/*

# ubuntu defaults java11, have to force it to java8
RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# Node
RUN cd /opt && wget https://nodejs.org/dist/v10.21.0/node-v10.21.0-linux-x64.tar.xz && tar -xf node-v10.21.0-linux-x64.tar.xz --directory /usr/local --strip-components 1

# SNYK
RUN npm i -g snyk 

# python used for the Notification
RUN pip3 install requests

RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash

RUN mkdir -p /root/.m2
COPY conf/settings.xml /root/.m2/settings.xml
COPY conf/npmrc /root/.npmrc
COPY conf/snyk-token /root/snyk-token
WORKDIR /root
RUN mkdir /root/data
COPY scripts/*.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/run.sh"]