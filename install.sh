#!/bin/bash
set -e

log=install.log

####################################################
# install faust and associated services
./install.faust.sh
echo
./install.faustwebsite.sh
echo
./install.faustservice.sh
echo
./install.onlinecompiler.sh
echo
./install.faustplayground.sh
echo "Faust services installation done"
echo -n "Faust services installed on " >> $log
date >> $log
