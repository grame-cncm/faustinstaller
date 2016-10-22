# faustinstaller
A set of scripts to build faust.grame.fr on an Ubuntu 16.04 machine, that is to install faust2, all targets SDKs (but macOS), website, onlinecompiler, faustservice and faustplayground.

- `install.faust.sh`: installs all the dependencies to compile Faust2 as well as all the dependencies to compile Faust programs to all non macOS targets, including latex for the automatic documentation, and Android SDK and NDK.
- `install.faustservice.sh`: installs everything to have faustservice running
- `install.faustwebsite.sh`: installs apache2, jekyll and the main faust website
- `install.faustplayground.sh`: installs faustplayground inside the website
- `install.onlinecompiler.sh`: installs PHP and the online compiler inside the website
- `updateall.sh`: once everything is installed, it pulls and updates all git repositories

Two directories are created:

- `~/FaustInstall`: were all gits and resources are placed
- `~/www`: were the web pages are installed


