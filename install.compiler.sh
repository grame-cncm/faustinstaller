#!/bin/bash
set -e

####################################################
# various settings are here
####################################################
#FAUSTBRANCH=master-dev
FAUSTBRANCH=faust-server
FAUSTDEPENDS="build-essential git cmake libmicrohttpd-dev"


####################################################
installfaust() {
	# Install 'Installation directory' if needed
	[ -d ~/FaustInstall ] || mkdir ~/FaustInstall
	cd ~/FaustInstall

	# for some reason which sudo doesn't work with Docker Ubuntu 16.04
	#SUDO=`which sudo`
	if [ -e /usr/bin/sudo ]; then
		SUDO=/usr/bin/sudo
	fi

	$SUDO apt-get update
	$SUDO apt-get install -y $FAUSTDEPENDS

	# Install Faust if needed
	echo "###################### Install faust..."
	[ -d "faust" ] || git clone https://github.com/grame-cncm/faust.git

	# Update and compile Faust
	cd faust
	git checkout $FAUSTBRANCH
	git pull
	make
	make httpd
	#$SUDO make newinstall 
	$SUDO make install 
	faust -v
	cd ..

	echo "Installation Done!"
}

installfaust
