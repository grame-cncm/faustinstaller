	#!/bin/bash
set -e

####################################################
# install faust
sh install.faustservice.sh
sh install.faust.sh
sh install.faustwebsite.sh
sh install.onlinecompiler.sh
sh install.faustplayground.sh
