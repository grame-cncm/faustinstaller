#!/bin/bash
set -e

	# for some reason which sudo doesn't work with Docker Ubuntu 16.04
#SUDO=`which sudo`
if [ -e /usr/bin/sudo ]; then
    SUDO=/usr/bin/sudo
fi

# Install Latex
$SUDO apt-get install -y texlive-full

echo "Latex Installation Done!"

