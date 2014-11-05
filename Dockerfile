FROM ubuntu:14.04.1
MAINTAINER Sean Parsons

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install cmake
RUN apt-get -y install git
RUN apt-get -y install libusb-1.0-0-dev
RUN apt-get -y install haskell-platform
RUN apt-get -y install libv4l-dev
RUN apt-get -y install v4l-utils
RUN apt-get -y install python-pip
RUN apt-get -y install usbutils
RUN pip install awscli --upgrade
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
RUN cabal update
RUN cabal install cabal-install
RUN /home/doorbell/.cabal/bin/cabal update
RUN git clone https://github.com/seanparsons/watcher.git && cd ./watcher && git checkout 2aa5422aa2e7ad65651e76dee9a16e9be3c54430
WORKDIR /home/doorbell/watcher
RUN git checkout master
RUN /home/doorbell/.cabal/bin/cabal sandbox init
RUN /home/doorbell/.cabal/bin/cabal install --only-dependencies
RUN /home/doorbell/.cabal/bin/cabal build
RUN echo "export PATH=/home/doorbell/.local/bin:$PATH" > /home/doorbell/.bashrc
RUN echo "export PATH=/home/doorbell/.local/bin:$PATH" > /home/doorbell/.bash_profile
