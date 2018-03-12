#!/bin/bash
set -e

log=install.log

####################################################
# install faust and associated services
./install.compiler.sh
echo
./install.sdk.sh
echo
./install.latex.sh
echo
./install.android.sh
echo
./install.faustwebsite.sh
echo
./install.https.sh
echo
./install.faustservice.sh
echo
./install.onlinecompiler.sh
echo
./install.faustplayground.sh
echo
./install.editor.sh
echo "Faust services installation done"
echo -n "Faust services installed on " >> $log
date >> $log
