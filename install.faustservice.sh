#!/bin/bash
set -e

function installfaustservice {
	SUDO=`which sudo`

	echo "Installing faustservice (remote compilation service)"

	$SUDO apt install -y libarchive-dev libboost-all-dev apache2

	# Check requirements
	if [ ! -d ~/FaustInstall ]; then
		echo "Please install faust before by running install.developer.sh"
		exit 1
	fi

	if [ ! -d ~/FaustInstall/faustservice ]; then
		cd ~/FaustInstall
		git clone https://github.com/grame-cncm/faustservice.git
	fi

	echo "Update faustservice"
	cd ~/FaustInstall/faustservice
	git pull
	make
	$SUDO make install

	echo "Installation Done! (but service not started: run ./faustweb)"

}

installfaustservice
