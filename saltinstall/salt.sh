#!/bin/sh
# Script made by Emiel Kok
# Arg 1 is master or minion, Arg 2 is master IP for minion
curl -L https://bootstrap.saltstack.com -o install_salt.sh

if [ "$1" != "master" ] && [ "$1" != "minion" ]; then
	echo "Kies master of minion"
elif [ "$1" = "master" ]
then
	sudo sh install_salt.sh -M
elif [ "$1" = "minion" ]
then
	sudo sh install_salt.sh -A $2
	
fi
