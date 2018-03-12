#!/bin/bash

# faust compiler
echo "Updating faust compiler"
cd ~/FaustInstall/faust
git pull
make
make httpd
sudo make newinstall

# faustservice (remote compiler)
echo "Updating faustservice remote compiler"
cd ~/FaustInstall/faustservice
git pull
make
sudo make install

# faust website
echo "Updating faust website"
cd ~/FaustInstall/faustwebsite
git pull
./bin/refreshFaustWebsite . ~/www

# faust online compiler
echo "Updating faust online compiler"
cd ~/www/onlinecompiler
git pull

# faust playground
echo "Updating faust playground"
cd ~/www/faustplayground
git pull

# faust editor
echo "Updating faust editor"
cd ~/www/editor
git pull

echo "Update DONE"


