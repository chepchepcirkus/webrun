## FUNCTIONS #####

#@name chepk_echo
#@description Custom echo function, handle state by color
#@args string to echo | state : error, warning, success | add a separator at the top
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
	echo '\e[36m#####################################################\e[0m\r\n'
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

#@name chepk_progressBar
#@description display a progress bar
#@description call this function for each step throw a while or a for loop
#@args current step | total steps
chepk_progressBar () {
    progress=$(((${1}*100/${2}*100)/100 ))
	done=$(((${progress}*4)/10))
    left=$((40-$done))
    fill=$(printf "%${done}s")
    empty=$(printf "%${left}s")
	printf "\rProgress : [${fill// /=}${empty// /.}] ${progress}%%\r"
	sleep 0.1
}

# Trim var
# remove leading whitespace characters
# remove trailing whitespace characters
trim() {
    var="$*"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}
