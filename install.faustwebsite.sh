#!/bin/bash
set -e

function installserver {
	# Install 'Installation directory' if needed
	if [ ! -d ~/FaustInstall ]; then
		mkdir ~/FaustInstall
	fi
	cd ~/FaustInstall

	SUDO=`which sudo`
	MYHOME=$HOME
	MYSELF=`whoami`

	echo "Updating packages and Installing Faust website dependencies..."
	###$SUDO apt-get -y update
	$SUDO apt-get install -y apache2 ruby ruby-dev nodejs

	echo "Install Jekyll"
	$SUDO gem install jekyll

	# Install Faust if needed
	if [ ! -d "faustwebsite" ]; then
		git clone https://github.com/grame-cncm/faustwebsite.git
	fi
	
	if [ ! -d ~/www ]; then
		mkdir ~/www
	fi

	# Update and refresh the Faust website	
	cd faustwebsite
	git pull
	./bin/refreshFaustWebsite . ~/www

	$SUDO cp config-files/001-faust.conf /etc/apache2/sites-available/
	$SUDO sed -i s%HOME%$MYHOME%g /etc/apache2/sites-available/001-faust.conf
	$SUDO sed -i s%www-data%$MYSELF%g /etc/apache2/envvars
	$SUDO a2ensite 001-faust.conf
	$SUDO a2dissite 000-default.conf
	cd ..

	$SUDO a2enmod headers proxy_http rewrite
	$SUDO apachectl stop
	$SUDO apachectl start


	echo "Installation Done!"
}

installserver


