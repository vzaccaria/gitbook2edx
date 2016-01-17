FROM    ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -qq update
RUN apt-get install -y nodejs npm
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
# 1 --
COPY . /src
RUN cat /src/package.json
RUN cd /src; rm -rf node_modules;
RUN cd /src; npm install LiveScript@1.3.1;
RUN cd /src; npm install babel@4.7.16;
RUN cd /src; npm install;
RUN cd /src; npm test;
