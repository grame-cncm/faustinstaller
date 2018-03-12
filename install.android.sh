#!/bin/bash
set -e


####################################################
# Install Android
#
install_android() {

 	echo "###################### Install Android..."

	# for some reason which sudo doesn't work with Docker Ubuntu 16.04
	#SUDO=`which sudo`
	if [ -e /usr/bin/sudo ]; then
		SUDO=/usr/bin/sudo
	fi

	## install java 8
    $SUDO apt install -y openjdk-8-jdk

	if [ ! -d ~/FaustInstall/android ]; then
        install -d ~/FaustInstall/android
	fi
	
	# to avoid some warnings
	install -d $HOME/.android/repositories.cfg
	touch $HOME/.android/repositories.cfg

	cd ~/FaustInstall/android
	wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip

	unzip sdk-tools-linux-3859397.zip

	## install licenses
	yes | sudo ./tools/bin/sdkmanager --licenses
	
	./tools/bin/sdkmanager "build-tools;25.0.3" 
	./tools/bin/sdkmanager "cmake;3.6.4111459" 
	./tools/bin/sdkmanager "emulator" 					## needed ????
	./tools/bin/sdkmanager "extras;android;m2repository"
	./tools/bin/sdkmanager "ndk-bundle" 
	./tools/bin/sdkmanager "patcher;v4" 
	./tools/bin/sdkmanager "platform-tools"
	./tools/bin/sdkmanager "platforms;android-25" 
	./tools/bin/sdkmanager "platforms;android-27" 
	./tools/bin/sdkmanager "tools" 

	./tools/bin/sdkmanager --update 					## needed ????
	./tools/bin/sdkmanager --licenses

	## Setting required environment variables for faust2smartkeyb
	export ANDROID_HOME=$HOME/FaustInstall/android/
	export ANDROID_NDK_HOME=$HOME/FaustInstall/android/ndk-bundle/

	## Add these variables to .profile
	echo '# Settings for faust2android (added by install.android.sh) ' >> $HOME/.profile
	echo 'export ANDROID_HOME=$HOME/FaustInstall/android/' >> $HOME/.profile
	echo 'export ANDROID_NDK_HOME=$HOME/FaustInstall/android/ndk-bundle/' >> $HOME/.profile

	## This is required by faust2android
	$SUDO install -d /opt/android/
	$SUDO ln -s $ANDROID_HOME /opt/android/sdk
	$SUDO ln -s $ANDROID_NDK_HOME /opt/android/ndk
	
}


install_android