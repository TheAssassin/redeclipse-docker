#! /bin/sh

cd /redeclipse

echo "### UPDATING... ###"
git pull --rebase
git submodule update -- data/maps

exec ./redeclipse_server.sh
