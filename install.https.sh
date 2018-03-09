	#!/bin/bash
set -e

if [ -e /usr/bin/sudo ]; then
	SUDO=/usr/bin/sudo
fi

####################################################
function installhttps {
	$SUDO apt-get install software-properties-common
	$SUDO add-apt-repository ppa:certbot/certbot
	$SUDO apt-get update
	$SUDO apt-get install python-certbot-apache 
	$SUDO certbot --apache
	$SUDO certbot renew --dry-run
	echo "Installation Done!"
}

installhttps
