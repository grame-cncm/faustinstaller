FROM ubuntu:16.04
RUN groupadd -r faust
RUN useradd --create-home --gid faust faust

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y install git-core vim-common lsb-core
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends sudo libgtk2.0-dev libjack-jackd2-dev liblo-dev libportmidi-dev libpulse-dev

#USER faust
RUN cd /home/faust; git clone https://github.com/grame-cncm/faustinstaller.git; cd faustinstaller;  ./install.docker.sh
