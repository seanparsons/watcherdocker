FROM ubuntu:14.04.1
MAINTAINER Sean Parsons

RUN apt-get update
RUN apt-get install -y wget
RUN wget -q -O- https://s3.amazonaws.com/download.fpcomplete.com/ubuntu/fpco.key | apt-key add -
RUN echo 'deb http://download.fpcomplete.com/ubuntu/trusty stable main' | sudo tee /etc/apt/sources.list.d/fpco.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install stack
RUN apt-get -y install cmake
RUN apt-get -y install git
RUN apt-get -y install libusb-1.0-0-dev
RUN apt-get -y install usbutils
RUN apt-get -y install rtl-sdr
RUN apt-get -y install librtlsdr-dev
RUN apt-get -y install pkg-config
RUN apt-get -y install mpg123
RUN apt-get -y install libtinfo-dev
RUN adduser --disabled-password -ingroup video doorbell
USER doorbell
ENV HOME /home/doorbell
ENV LANG C.UTF-8
WORKDIR /home/doorbell
RUN git clone https://github.com/merbanan/rtl_433.git
WORKDIR /home/doorbell/rtl_433
RUN mkdir build
WORKDIR /home/doorbell/rtl_433/build
RUN pwd
RUN cmake ../
RUN make
WORKDIR /home/doorbell
RUN git clone https://github.com/seanparsons/watcher.git && cd ./watcher && git checkout 82c4c7815a49383869cb593990b47e74c4731005
WORKDIR /home/doorbell/watcher
RUN stack setup
RUN stack build
RUN stack install
RUN echo "export PATH=/home/doorbell/.local/bin:$PATH" > /home/doorbell/.bashrc
RUN echo "export PATH=/home/doorbell/.local/bin:$PATH" > /home/doorbell/.bash_profile