FROM    ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -qq update
RUN apt-get install -y nodejs npm
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
# 1 --
RUN mkdir /src
RUN apt-get install -y git

RUN git clone https://github.com/vzaccaria/gitbook2edx.git
WORKDIR /gitbook2edx
RUN npm install LiveScript@1.3.1;
RUN npm install babel@4.7.16;
RUN npm install newmake;
RUN npm install;
RUN npm install browserify;
RUN npm install verb verb-cli;
RUN ./node_modules/.bin/lsc ./makefile.ls; make clean; make
