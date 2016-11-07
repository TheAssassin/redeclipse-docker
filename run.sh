#! /bin/sh

cd /redeclipse

echo "### UPDATING... ###"
git pull --rebase
git submodule update

exec ./redeclipse_server.sh
