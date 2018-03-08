	#!/bin/bash
set -e

log=install.log

####################################################
# install faust
sh install.faustservice.sh
sh install.faust.sh
sh install.faustwebsite.sh
sh install.onlinecompiler.sh
sh install.faustplayground.sh
echo -n "Faust services installed on " >>$log
date >> $log
