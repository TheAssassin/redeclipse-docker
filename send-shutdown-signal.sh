#! /bin/bash

##############################################################################
# Sends a stop signal to the dockerized server which causes the container    #
# to restart (if docker-compose or the --restart=unless-stopped option is    #
# used.                                                                      #
##############################################################################


docker-compose exec re-server /bin/sh -c "/usr/bin/killall -sTERM redeclipse_server_linux"
