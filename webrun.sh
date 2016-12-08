#! /usr/bin/env bash

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
    modules=$(find $chepk_libd/* -maxdepth 2 -name 'runner.sh')
    count=0
    for i in $modules
    do
       command[count]=$i
       module=$(head -2 $i | tail -1)
       chepk_echo " $count > ${module#*[[:space:]]}"
       count=$((count + 1))
    done

    read choice;

    if [ "${command[$choice]}" = "" ]
    then
        chepk_echo "This is not an available action, please retry..." error
        main
    else
        source ${command[$choice]}
    fi
    exit 0
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
