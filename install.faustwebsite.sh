#!/bin/bash
set -e

installserver() {
	# Install 'Installation directory' if needed
	if [ ! -d ~/FaustInstall ]; then
		mkdir ~/FaustInstall
	fi
	cd ~/FaustInstall

		# for some reason which sudo doesn't work with Docker Ubuntu 16.04
	#SUDO=`which sudo`
	if [ -e /usr/bin/sudo ]; then
		SUDO=/usr/bin/sudo
	fi
	
	MYHOME=$HOME
	MYSELF=`whoami`

	echo "############################ Updating packages and Installing Faust website dependencies..."
	$SUDO apt-get -y update
	$SUDO apt-get install -y -y build-essential git apache2 ruby ruby-dev nodejs

	echo "############################ Install Jekyll"
	$SUDO gem install jekyll

	# Install Faust if needed
	if [ ! -d "faustwebsite" ]; then
	echo "############################ clone faustwebsite"
		git --recursive clone https://github.com/grame-cncm/faustwebsite.git
	fi
	
	if [ ! -d ~/www ]; then
		mkdir ~/www
	fi

	# Update and refresh the Faust website	
	cd faustwebsite
	git pull
	./build -a -v
	./deploy

	$SUDO cp config-files/001-faust.conf /etc/apache2/sites-available/
	$SUDO sed -i s%HOME%$MYHOME%g /etc/apache2/sites-available/001-faust.conf
	$SUDO sed -i s%www-data%$MYSELF%g /etc/apache2/envvars

	# remove previous ANDROID definitions
	grep -v ANDROID_ /etc/apache2/envvars > tmp$$
	$SUDO mv -f tmp$$ /etc/apache2/envvars
	
	$SUDO cat <<!  >> /etc/apache2/envvars

## For Faust2Android ANDROID_XXX definitions (added by installer)
ANDROID_ROOT=/opt/android
ANDROID_HOME=/opt/android/sdk
ANDROID_SDK_ROOT=/opt/android/sdk
ANDROID_NDK_ROOT=/opt/android/ndk
ANDROID_NDK_HOME=/opt/android/ndk

!

	$SUDO a2ensite 001-faust.conf
	$SUDO a2dissite 000-default.conf
	cd ..

	$SUDO a2enmod headers proxy_http rewrite
	$SUDO apachectl stop
	$SUDO apachectl start

	echo "############################ Installation Done!"
}

installserver


