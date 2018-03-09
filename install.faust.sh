#!/bin/bash
set -e

####################################################
# various settings are here
####################################################
FAUSTBRANCH=master-dev
FAUSTDEPENDS="build-essential g++-multilib pkg-config git libmicrohttpd-dev llvm-3.8 llvm-3.8-dev libssl-dev ncurses-dev libsndfile-dev libedit-dev libcurl4-openssl-dev vim-common cmake"
FAUSTSDKDEPENDS="libgtk2.0-dev libasound2-dev libqrencode-dev portaudio19-dev libjack-jackd2-dev qjackctl libcsound64-dev dssi-dev lv2-dev puredata-dev supercollider-dev wget unzip libboost-dev inkscape graphviz"


####################################################
# Install QT5 (for faust2faustvst)
install_qt5() {
	echo "###################### Install QT5..."
    $SUDO apt-get install -y qtbase5-dev qt5-qmake libqt5x11extras5-dev
	if [ ! -e /usr/bin/qmake-qt5 ]; then
    	$SUDO ln -s /usr/lib/x86_64-linux-gnu/qt5/bin/qmake /usr/bin/qmake-qt5
	fi
}

####################################################
# Install faust2pd from Albert Greaf Pure-lang PPA
install_faust2pd() {
	echo "###################### Install faust2pd..."
	$SUDO apt-get install -y software-properties-common
	$SUDO add-apt-repository -y ppa:dr-graef/pure-lang.xenial
	$SUDO apt-get -y update
	$SUDO apt-get install -y faust2pd faust2pd-extra
}

####################################################
# Install pd.dll needed to cross compile pd externals for windows
install_pd_dll() {
	echo "###################### Install pd dll..."
	if [ ! -d /usr/lib/i686-w64-mingw32/pd/pd.dll ]; then
 # don't fetch the dll from the faust website any more
 # it fails regularly and will especially fail if the faust site is not available 
 #       wget http://faust.grame.fr/pd.dll || wget http://ifaust.grame.fr/pd.dll
        $SUDO cp $INSTALLDIR/rsrc/pd.dll /usr/include/pd/
    fi
}

####################################################
# Install VST SDK
install_vst_sdk() {
 	echo "###################### Install VST SDK..."
   if [ ! -d /usr/local/include/vstsdk2.4 ]; then
        wget http://www.steinberg.net/sdk_downloads/vstsdk365_12_11_2015_build_67.zip
        unzip vstsdk365_12_11_2015_build_67.zip
        $SUDO mv "VST3 SDK" /usr/local/include/vstsdk2.4
    fi
}

####################################################
# Install MaxMSP SDK
install_max_sdk() {
 	echo "###################### Install Max/MSP SDK..."
	if [ ! -d /usr/local/include/c74support ]; then
		if [ ! -f max-sdk-7.1.0.zip ]; then
			wget https://cycling74.com/download/max-sdk-7.1.0.zip
		fi
		unzip max-sdk-7.1.0.zip
		$SUDO cp -r max-sdk-7.1.0/source/c74support /usr/local/include/
	fi
}

####################################################
# Install ROS Jade, see $(lsb_release -sc) instead of xenial
install_ros() {
 	echo "###################### Install ROS..."
	$SUDO sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'
	$SUDO apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
	$SUDO apt-get -y update
	$SUDO apt-get install -y ros-kinetic-ros
}

####################################################
# Install Bela
install_bela() {
 	echo "###################### Install Bela..."
	$SUDO apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
    if [ ! -d /usr/local/beaglert ]; then
        git clone https://github.com/BelaPlatform/Bela.git
        $SUDO mv Bela /usr/local/beaglert
    fi

    if [ ! -d /usr/arm-linux-gnueabihf/include/xenomai ]; then
        # install xenomia (should be downloaded from an official place)
#        wget http://faust.grame.fr/xenomai.tgz || wget http://ifaust.grame.fr/xenomai.tgz
		currentdir=$(pwd)
        cd $INSTALLDIR/rsrc
        tar xzf xenomai.tgz
        $SUDO mv xenomai /usr/arm-linux-gnueabihf/include/
        cd $currentdir
    fi
}

####################################################
# make world recovery 
try_llvm() {
 	echo "###################### try to use LLVM_CONFIG..."
	# find llvm-config
	if [ -x /usr/bin/llvm-config ] 
	then
		LLVM_CONFIG=llvm-config 
	else
		LLVM_CONFIG=$(find /usr/bin -name 'llvm-config*' | sed -e 's/\/usr\/bin\///')
	fi
	which $LLVM_CONFIG > /dev/null || (echo "cannot find llvm-config (or derived)"; exit 1)
	
	cd build/faustdir && cmake .. -DUSE_LLVM_CONFIG=on -DLLVM_CONFIG=$LLVM_CONFIG
	cd ../..
	make world
}

####################################################
installfaust() {
	# Install 'Installation directory' if needed
	[ -d ~/FaustInstall ] || mkdir ~/FaustInstall
	cd ~/FaustInstall

	# for some reason which sudo doesn't work with Docker Ubuntu 16.04
	#SUDO=`which sudo`
	if [ -e /usr/bin/sudo ]; then
		SUDO=/usr/bin/sudo
	fi

	echo "###################### Updating packages..."
	$SUDO apt-get -y update
	echo "###################### Installing Faust dependencies..."
	$SUDO apt-get install -y $FAUSTDEPENDS
	[ -f /usr/bin/llvm-config ] || $SUDO ln -s /usr/bin/llvm-config-3.8 /usr/bin/llvm-config

	# Install all the needed SDK
	$SUDO apt-get install -y $FAUSTSDKDEPENDS

    # install QT5 for faust2faustvst
    install_qt5

	# Install faust2pd from Albert Greaf Pure-lang PPA
	install_faust2pd

	# Install pd.dll needed to cross compile pd externals for windows
    install_pd_dll

	# Install VST SDK
    install_vst_sdk

	# Install cross-compiler
	$SUDO apt-get install -y g++-mingw-w64

	# Install MaxMSP SDK
	install_max_sdk

	# Install ROS Jade, see $(lsb_release -sc) instead of xenial
	install_ros

	# Install Bela
	install_bela

	# Install Latex
    $SUDO apt-get install -y texlive-full

	# Install Faust if needed
	echo "###################### Install faust..."
	[ -d "faust" ] || git clone https://github.com/grame-cncm/faust.git

	# Update and compile Faust
	cd faust
	git checkout $FAUSTBRANCH
	git pull
	make world || try_llvm
	$SUDO make newinstall  # will be install once 'newinstall' is validated by packagers
	faust -v
	cd ..

	echo "Installation Done!"
}

installfaust
