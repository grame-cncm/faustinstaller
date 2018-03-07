#!/bin/bash
set -e

installonlinecompiler() {
	SUDO=`which sudo`

	echo "Installing Faust Online Compiler"

	# Check requirements
	if [ ! -d ~/FaustInstall ]; then
		echo "Please install faust before by running install.developer.sh"
		exit 1
	fi
	if [ ! -d ~/www ]; then
		echo "Please install faustwebsite before by running install.faustwebsite.sh"
		exit 1
	fi

	if [ ! -d ~/www/onlinecompiler ]; then
		cd ~/www/
		echo "Clone onlinecompiler"
		git clone https://github.com/grame-cncm/onlinecompiler.git
	fi

	echo "Update onlinecompiler"
	cd ~/www/onlinecompiler
	git pull

	echo "Create if needed tmp directory for sessions"
	if [ ! -d tmp ]; then
		mkdir tmp
	fi
	
	echo "Install PHP and qrencode"
	$SUDO apt-get install -y php libapache2-mod-php qrencode

	
	echo "Installation Done!"

}

installonlinecompiler


