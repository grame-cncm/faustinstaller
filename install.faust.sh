	#!/bin/bash
set -e

####################################################
# various settings are here
####################################################
FAUSTBRANCH=master-dev
FAUSTDEPENDS="build-essential g++-multilib pkg-config git libmicrohttpd-dev llvm-3.6 llvm-3.6-dev libssl-dev ncurses-dev libsndfile-dev libedit-dev libcurl4-openssl-dev vim-common"
FAUSTSDKDEPENDS="libgtk2.0-dev libasound2-dev libqrencode-dev portaudio19-dev libjack-jackd2-dev qjackctl qt4-default libcsound64-dev dssi-dev lv2-dev puredata-dev supercollider-dev wget unzip libboost-dev inkscape graphviz"

####################################################
# Install QT5 (for faust2faustvst)
function install_qt5 {
    $SUDO apt-get install -y qtbase5-dev qt5-qmake libqt5x11extras5-dev
	if [ ! -e /usr/bin/qmake-qt5 ]; then
    	$SUDO ln -s /usr/lib/x86_64-linux-gnu/qt5/bin/qmake /usr/bin/qmake-qt5
	fi
}

####################################################
# Install faust2pd from Albert Greaf Pure-lang PPA
function install_faust2pd {
	$SUDO apt-get install -y software-properties-common
	$SUDO add-apt-repository -y ppa:dr-graef/pure-lang.xenial
	$SUDO apt-get -y update
	$SUDO apt-get install -y faust2pd faust2pd-extra
}

####################################################
# Install pd.dll needed to cross compile pd externals for windows
function install_pd_dll {
    if [ ! -d /usr/include/pd/pd.dll ]; then
        wget http://faust.grame.fr/pd.dll || wget http://ifaust.grame.fr/pd.dll
        $SUDO mv pd.dll /usr/include/pd/
    fi
}

####################################################
# Install VST SDK
function install_vst_sdk {
    if [ ! -d /usr/local/include/vstsdk2.4 ]; then
        wget http://www.steinberg.net/sdk_downloads/vstsdk365_12_11_2015_build_67.zip
        unzip vstsdk365_12_11_2015_build_67.zip
        $SUDO mv "VST3 SDK" /usr/local/include/vstsdk2.4
    fi
}

####################################################
# Install MaxMSP SDK
function install_max_sdk {
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
function install_ros {
	$SUDO sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'
	$SUDO apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
	$SUDO apt-get -y update
	$SUDO apt-get install -y ros-kinetic-ros
}

####################################################
# Install Bela
function install_bela {
	$SUDO apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
    if [ ! -d /usr/local/beaglert ]; then
        git clone https://github.com/BelaPlatform/Bela.git
        $SUDO mv Bela /usr/local/beaglert
    fi

    if [ ! -d /usr/arm-linux-gnueabihf/include/xenomai ]; then
        # install xenomia (should be downloaded from an official place)
        wget http://faust.grame.fr/xenomai.tgz || wget http://ifaust.grame.fr/xenomai.tgz
        tar xzf xenomai.tgz
        $SUDO mv xenomai /usr/arm-linux-gnueabihf/include/
    fi
}

####################################################
# Install Android
function install_android {
	## install java 8
    $SUDO apt install -y openjdk-8-jdk

	## install android sdk
    if [ ! -d /opt/android ]; then
        $SUDO install -d /opt/android

        if [ ! -f android-sdk_r24.4.1-linux.tgz ]; then
            wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
        fi
        if [ ! -d /opt/android/sdk ]; then
            tar -xzf android-sdk_r24.4.1-linux.tgz
            $SUDO mv android-sdk-linux/ /opt/android/sdk
        fi
		export ANDROID_HOME="/opt/android/sdk"

        ## install android ndk
        if [ ! -f android-ndk-r12-linux-x86_64.zip ]; then
            wget https://dl.google.com/android/repository/android-ndk-r12-linux-x86_64.zip
        fi

        if [ ! -d /opt/android/ndk ]; then
            unzip -q android-ndk-r12-linux-x86_64.zip
            $SUDO mv android-ndk-r12 /opt/android/ndk
        fi

        export PATH="/opt/android/sdk/tools:/opt/android/sdk/platform-tools:/opt/android/ndk:$PATH"
        echo y |

		# install missing cmake for android
		wget https://github.com/Commit451/android-cmake-installer/releases/download/1.1.0/install-cmake.sh
		chmod +x install-cmake.sh
		$SUDO ./install-cmake.sh
    fi
}

####################################################
function installfaust {
	# Install 'Installation directory' if needed
	[ -d ~/FaustInstall ] || mkdir ~/FaustInstall
	cd ~/FaustInstall

	# for some reason which sudo doesn't work with Docker Ubuntu 16.04
	#SUDO=`which sudo`
	if [ -e /usr/bin/sudo ]; then
		SUDO=/usr/bin/sudo
	fi

	echo "Updating packages..."
	$SUDO apt-get -y update
	echo "Installing Faust dependencies..."
	echo yes | $SUDO apt install -y jackd2
	$SUDO apt-get install -y $FAUSTDEPENDS

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

	# Install Android development tools
	install_android

	# Install Latex
    $SUDO apt-get install -y texlive-full

	# Install Faust if needed
	[ -d "faust" ] || git clone https://github.com/grame-cncm/faust.git

	# Update and compile Faust
	cd faust
	git checkout $FAUSTBRANCH
	git pull
	make world
	$SUDO make install
	cd ..

	echo "Installation Done!"
}

installfaust
