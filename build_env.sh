#!/bin/bash
#This script has ONLY to be run at FIRST container startup

#Now let's start to build proper env
echo "***********************************"
echo "***** Final git compile steps *****"
echo "***********************************"
cd /opt/workdir/game-and-watch-flashloader
make GCC_PATH=/opt/xpack-arm-none-eabi-gcc-10.3.1-2.3/bin/
cd /opt/workdir/game-and-watch-retro-go
make clean && git pull
chmod a+x scripts/*.sh
cd /opt/workdir/game-and-watch-patch
make download_sdk && make clean
echo "*************************"
echo "***** END OF SCRIPT *****"
echo "*************************"
