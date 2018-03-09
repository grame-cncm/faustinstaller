#!/bin/bash
set -e

installonlinecompiler() {
	SUDO=`which sudo`

	echo "########################### Installing Faust Online Compiler"

	# Check requirements
	if [ ! -d ~/FaustInstall ]; then
		echo "Please install faust before by running install.faust.sh"
		exit 1
	fi
	if [ ! -d ~/www ]; then
		echo "Please install faustwebsite before by running install.faustwebsite.sh"
		exit 1
	fi

	if [ ! -d ~/www/onlinecompiler ]; then
		cd ~/www/
		echo "########################### Clone onlinecompiler"
		git clone https://github.com/grame-cncm/onlinecompiler.git
	fi

	echo "########################### Update onlinecompiler"
	cd ~/www/onlinecompiler
	git pull

	if [ ! -d tmp ]; then
		echo "########################### Create tmp directory for sessions"
		mkdir tmp
	fi
	
	echo "########################### Install PHP and qrencode"
	$SUDO apt-get install -y php libapache2-mod-php qrencode highlight
	
	echo "Installation Done!"
}

installonlinecompiler


