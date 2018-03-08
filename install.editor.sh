#!/bin/bash
set -e

installfausteditor() {
	SUDO=`which sudo`

	echo "Installing Faust Editor"

	# Check requirements
	if [ ! -d ~/FaustInstall ]; then
		echo "Please install faust before by running install.developer.sh"
		exit 1
	fi
	if [ ! -d ~/www ]; then
		echo "Please install faustwebsite before by running install.faustwebsite.sh"
		exit 1
	fi

	if [ ! -d ~/www/editor ]; then
		cd ~/www/
		echo "Clone editor"
		git clone https://github.com/grame-cncm/fausteditorweb.git editor
	fi

	echo "Update editor"
	cd ~/www/editor
	git pull
    git submodule init 
    git submodule update
	
	echo "Installation Done!"

}

installfausteditor
