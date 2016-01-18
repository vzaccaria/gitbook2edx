FROM    ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -qq update
RUN apt-get install -y nodejs npm
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
# 1 --
RUN mkdir /src
RUN apt-get install -y git

RUN echo "try n. 1"
RUN git clone https://github.com/vzaccaria/gitbook2edx.git
RUN cd /gitbook2edx; npm install LiveScript@1.3.1;
RUN cd /gitbook2edx; npm install babel@4.7.16;
RUN cd /gitbook2edx; npm install newmake;
RUN cd /gitbook2edx; npm install;
RUN cd /gitbook2edx; npm install browserify;
RUN cd /gitbook2edx; ./node_modules/.bin/lsc ./makefile.ls; make clean; make
