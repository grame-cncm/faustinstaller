#!/bin/bash
set -e

log=install.log
installfaustservice() {
	SUDO=`which sudo`

	echo "Installing faustservice (remote compilation service)"

	$SUDO apt install -y libarchive-dev libboost-all-dev

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
	#$SUDO make install

	echo "Installation Done! (but service not started: run ./faustweb)"

}



####################################################
# install faust and associated services
./install.compiler.sh
echo
./install.sdk.sh
echo
./install.latex.sh
echo
./install.android.sh
echo
# ./install.faustwebsite.sh
# echo
# ./install.https.sh
# echo

installfaustservice

# echo
# ./install.onlinecompiler.sh
# echo
# ./install.faustplayground.sh
# echo
# ./install.editor.sh
echo "Faust services installation done"
echo -n "Faust services installed on " >> $log
date >> $log
