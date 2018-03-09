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
	cd ~/FaustInstall/android
	wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip

	unzip sdk-tools-linux-3859397.zip

	## install licenses
	mkdir licenses
	echo '601085b94cd77f0b54ff86406957099ebe79c4d6' > licenses/android-googletv-license
	echo 'd56f5187479451eabf01fb78af6dfcb131a6481e' > licenses/android-sdk-license
	echo '84831b9409646a918e30573bab4c9c91346d8abd' > licenses/android-sdk-preview-license
	echo '33b6a2b64607f11b759f320ef9dff4ae5c47d97a' > licenses/google-gdk-license
	echo 'e9acab5b5fbb560a72cfaecce8946896ff6aab9d' > licenses/mips-android-sysimage-license

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
	export ANDROID_HOME="/home/orlarey/FaustInstall/android/"
	export ANDROID_NDK_HOME="/home/orlarey/FaustInstall/android/ndk-bundle/"

	## Add these variables to .profile
	echo '# Settings for faust2android (added by install.android.sh) ' >> /home/orlarey/.profile
	echo 'export ANDROID_HOME="/home/orlarey/FaustInstall/android/"' >> /home/orlarey/.profile
	echo 'export ANDROID_NDK_HOME="/home/orlarey/FaustInstall/android/ndk-bundle/"' >> /home/orlarey/.profile


	## This is required by faust2android
	$SUDO install -d /opt/android/
	$SUDO ln -s $ANDROID_HOME /opt/android/sdk
	$SUDO ln -s $ANDROID_NDK_HOME /opt/android/ndk
	
}


install_android