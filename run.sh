#! /bin/sh

cd /redeclipse

#echo "### UPDATING... ###"
#git pull --rebase
#git submodule update -- data/maps

export REDECLIPSE_BRANCH=inplace

exec ./redeclipse_server.sh
