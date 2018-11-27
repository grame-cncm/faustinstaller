# faustinstaller
A set of scripts to build faust.grame.fr on an Ubuntu 16.04 machine, that is to install faust, all targets SDKs (but macOS), website, onlinecompiler, faustservice, faustplayground and editor.

- `install.compiler.sh`: installs the Faust compiler
- `install.sdk.sh`: most of the required development packages
- `install.latex.sh`: installs latex for the automatic doc
- `install.android.sh`: installs what is needed to compile for android
- `install.faustwebsite.sh`: installs apache2, jekyll and the main faust website
- `install.https.sh`: installs what is needed for https
- `install.faustservice.sh`: installs everything to have faustservice running
- `install.onlinecompiler.sh`: installs PHP and the online compiler inside the website
- `install.faustplayground.sh`: installs faustplayground 
- `install.editor.sh`: installs the online editor 
- `install.all.sh`: do all the previous steps in one script 
- `updateall.sh`: once everything is installed, it pulls and updates all git repositories

Two directories are created:

- `~/FaustInstall`: were all gits and resources are placed
- `~/www`: were the web pages are installed

# Installing everything on a virtual machine

- `git clone https://github.com/grame-cncm/faustinstaller.git`
- 