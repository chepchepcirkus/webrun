#!/usr/bin/env bash

if [ "$chk_cli" == "0" ]
then
    source $chk_lib_d/render.sh
else
    source $chk_lib_d/render_cli.sh
fi

## Check / Lock directory ##
function chk_lock () {
	if [ -e $1/chepksync.lock ]
	then
		chk_echo "process already in use ..." error
		chk_echo "--- you can unlock the process by \n\r rm $1/chepksync.lock" info
		exit 0
	else
		touch $1/chepksync.lock
	fi
}

# Check / UnLock directory
function chk_unlock () {
	if [ -e $1/chepksync.lock ]
	then
		rm $currentd/chepksync.lock
	else
		chk_echo "no lock file found" warning
	fi
}


# Trim var
# remove leading whitespace characters
# remove trailing whitespace characters
function trim() {
    var="$*"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}
