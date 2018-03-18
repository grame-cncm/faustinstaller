FROM ubuntu:16.04
RUN groupadd -r faust
RUN useradd --create-home --gid faust faust

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y install git-core vim-common lsb-core
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends sudo libgtk2.0-dev jackd2 libjack-jackd2-dev liblo-dev libportmidi-dev libpulse-dev 
RUN apt-get install -y build-essential git cmake libmicrohttpd-dev
RUN apt-get install -y build-essential g++-multilib pkg-config git libmicrohttpd-dev llvm-3.8 llvm-3.8-dev libssl-dev ncurses-dev libsndfile-dev libedit-dev libcurl4-openssl-dev vim-common cmake
RUN apt-get install -y libgtk2.0-dev libqt4-dev libasound2-dev libqrencode-dev portaudio19-dev libjack-jackd2-dev libcsound64-dev dssi-dev lv2-dev puredata-dev supercollider-dev wget unzip libboost-dev inkscape graphviz
RUN apt-get install -y qtbase5-dev qt5-qmake libqt5x11extras5-dev
RUN apt-get install -y openjdk-8-jdk zip libarchive-dev libboost-all-dev


RUN ls -al

#USER faust
RUN cd /home/faust; git clone https://github.com/grame-cncm/faustinstaller.git; cd faustinstaller;  ./install.docker.sh
EXPOSE 8080
WORKDIR /root/FaustInstall/faustservice
CMD ./faustweb --port 8080
