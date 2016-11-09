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
ftest() {
    chepk_echo 'this is a test'
    filesToParse=$(find /var/www/webrun -name '*.sh')
    total=$(echo "$filesToParse" | wc -l)
    echo $total
}

## MAIN MENU ##
main() {
    chepk_echo "Choose an action : " '' separator
    chepk_echo " > set up a vhost (v)"
    chepk_echo " > manage database (bdd)"
    chepk_echo " > build documentation (b)"

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
