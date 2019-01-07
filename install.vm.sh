#!/bin/bash
set -e

log=install.log

####################################################
# Specila installation for cloud based VM
# install faust and associated services (but not faustservice)
./install.compiler.sh
echo
./install.faustwebsite.sh
echo
./install.faustplayground.sh
echo
./install.editor.sh
echo "Faust services installation done"
echo -n "Faust services installed on " >> $log
echo
./install.https.sh

date >> $log
