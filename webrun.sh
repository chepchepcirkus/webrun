#! /bin/bash

#@main Webrun
#@intro Webrun is a library of bash script usefull for repititive of everyday web developpement tasks

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

## TEST FUNCTION ##
function ftest() {
    chepk_echo 'this is a test'
    count=0
    total=10
    while [ ! $count = $total ]
    do
		sleep 0.5
		count=$(( count + 1))
		chepk_progressBar $count $total
    done
}

## MAIN MENU ##
function main() {
    chepk_echo "Choose an action : " '' separator
    chepk_echo " > (v) set up a vhost"
    chepk_echo " > (bdd) manage database"
    chepk_echo " > (d) build documentation"

    read choice;

    case $choice in
        # vhost
        v) source $chepk_libd/vhost/vhost.sh ;;
        # Bdd management
        bdd) source $chepk_libd/database/mysql/manage.sh ;;
        # Deploy
        d) chepk_echo "Deploy" ;;
        # Build doc
        b) source $chepk_libd/documentation/buildDoc.sh ;;
        *) chepk_echo "This is not an available action, please retry..." error
        main ;;
    esac
}

chepk_echo 'Author : s.servanton@gmail.com 
 _       __          __             ____                 
| |     / /  ___    / /_           / __ \  __  __   ____ 
| | /| / /  / _ \  / __ \         / /_/ / / / / /  / __ \
| |/ |/ /  /  __/ / /_/ /        / _, _/ / /_/ /  / / / /
|__/|__/   \___/ /_.___/        /_/ |_|  \__,_/  /_/ /_/ 
                                                         ' success separator
if [[ $1 = "test" ]]
then
    ftest
else
    main
fi
