#! /bin/bash

## Error Handling
set -e

## INIT CONFIG
if [ -e ./config.cfg ]
then
	source config.cfg
else
	echo "There is no local config.cfg file ..."
	exit 0 
fi

## LOAD FUNCTIONS LIBRARY
source $chepk_libd/functions.sh

chepk_echo 'Author : s.servanton@gmail.com 
 _       __          __             ____                 
| |     / /  ___    / /_           / __ \  __  __   ____ 
| | /| / /  / _ \  / __ \         / /_/ / / / / /  / __ \
| |/ |/ /  /  __/ / /_/ /        / _, _/ / /_/ /  / / / /
|__/|__/   \___/ /_.___/        /_/ |_|  \__,_/  /_/ /_/ 
                                                         ' success separator

chepk_echo "Choose an action : " '' separator
chepk_echo " > set up a vhost (v)"
chepk_echo " > manage database (bdd)"

read choice;

case $choice in
	# vhost
	v) source $chepk_libd/vhost/vhost.sh ;;
	# Bdd management
	bdd) echo -e "Bdd management work in progress" ;;
	# Bdd management
	d) echo -e "Deploy" ;;
esac

