#! /usr/bin/env bash

#@title-1 Webrun
#@intro Webrun is a library of bash script usefull for repititive web developpement tasks of everyday.

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

## GLOBAL VARIABLES
chk_cli=0

# Detect cli execution
if [ "$1" == "-cli" ]
then
    chk_cli=1
fi

## LOAD FUNCTIONS LIBRARY
source $chk_lib_d/functions.sh

## TEST FUNCTION ##
function ftest() {
    directories=$(find $path -type d)
    fileOrdered=()
    for i in $directories
    do
        if [ -d $i ]
        then
           filesToParse=$(find $i -maxdepth 1 -name '*.sh' | cat | sort)
           for j in $filesToParse
           do
                fileOrdered=("${fileOrdered[@]}" "$j")
           done
        fi
    done
    for i in ${fileOrdered[@]}
    do
        echo $i
    done
}

## MAIN MENU ##
function main() {
    chk_echo "Choose an action : " '' separator
    modules=$(find $chk_module_d/* -maxdepth 2 -name 'runner.sh')
    count=0
    for i in $modules
    do
       command[count]=$i
       module=$(head -2 $i | tail -1)
       chk_echo " $count > ${module#*[[:space:]]}"
       count=$((count + 1))
    done

    read choice;

    if [ "${command[$choice]}" == "" ]
    then
        chk_echo "This is not an available action, please retry..." error
        main
    else
        source ${command[$choice]}
    fi
}

echo 'Author : s.servanton@gmail.com
 _       __          __             ____
| |     / /  ___    / /_           / __ \  __  __   ____
| | /| / /  / _ \  / __ \         / /_/ / / / / /  / __ \
| |/ |/ /  /  __/ / /_/ /        / _, _/ / /_/ /  / / / /
|__/|__/   \___/ /_.___/        /_/ |_|  \__,_/  /_/ /_/
'

# Detect test function
if [ "$1" == "test" ]
then
    ftest
    exit 0
fi

# Execute cli / main function
if [ "$chk_cli" == "1" ]
then
    if [ -e $chk_module_d/$2/runner.sh ]
    then
        source $chk_module_d/$2/runner.sh $3 $4 $5
    else
        chk_echo $2" unknown module name" error
    fi
else
    main
fi

exit 0