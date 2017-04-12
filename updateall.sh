#!/bin/bash

# faust compiler
echo "Update faust compiler"
cd ~/FaustInstall/faust
git pull
make
make httpd
sudo make install

# faustservice (remote compiler)
echo "Update faustservice remote compiler"
cd ~/FaustInstall/faustservice
git pull
make
sudo make install

# faust website
echo "Update faust website"
cd ~/FaustInstall/faustwebsite
git pull
./bin/refreshFaustWebsite . ~/www

# faust online compiler
echo "Update faust online compiler"
cd ~/www/onlinecompiler
git pull

# faust playground
echo "Update faust playground"
cd ~/www/faustplayground
git pull

echo "Update DONE"


