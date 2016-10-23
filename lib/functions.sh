## FUNCTIONS #####

# Custom echo function
# args
#	state
#	separator	
chepk_echo () {
	
	# Separator
	local separator=''
	if [[ -n $3 ]]
	then
		separator='\e[36m#####################################################\e[0m\r\n'
	fi
	
	# State	
	if [[ -n $2 ]]
	then
		case $2 in
			# Error state
			error) echo -e $separator"\e[31m $1 \e[0m" ;;
			# Warning state
			warning) echo -e $separator"\e[33m $1 \e[0m" ;;
			# Info state
			success) echo -e $separator"\e[32m $1 \e[0m" ;;
		esac
	else
		echo -e $separator"\e[36m $1 \e[0m"
	fi		
}

## Empty LINE ##
chepk_echo_empty () {
	echo -e ''
}

## SEPARATOR ##
chepk_echo_separator () {
	echo '#####################################################\r\n'
}

## Check / Lock directory ##
chepk_lock () {
	if [ -e $1/chepksync.lock ]
	then
		chepk_echo "process already in use ..." error
		chepk_echo "--- you can unlock the process by \n\r rm $1/chepksync.lock" info
		exit 0
	else
		touch $1/chepksync.lock
	fi
}

# Check / UnLock directory
chepk_unlock () {
	if [ -e $1/chepksync.lock ]
	then
		rm $currentd/chepksync.lock
	else
		chepk_echo "no lock file found" warning
	fi
}

# Trim var
trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}
