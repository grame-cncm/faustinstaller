#!/bin/bash
set -e

installfaustplayground() {
	SUDO=`which sudo`

	echo "########################### Installing Faust Playground"

	# Check requirements
	if [ ! -d ~/FaustInstall ]; then
		echo "Please install faust before by running install.developer.sh"
		exit 1
	fi
	if [ ! -d ~/www ]; then
		echo "Please install faustwebsite before by running install.faustwebsite.sh"
		exit 1
	fi

	if [ ! -d ~/www/faustplayground ]; then
		cd ~/www/
		echo "########################### Clone faustplayground"
		git clone https://github.com/grame-cncm/faustplayground.git
	fi

	echo "########################### Update faustplayground"
	cd ~/www/faustplayground
	git pull
	git submodule update --init 
	
	echo "Installation Done!"
}

installfaustplayground
