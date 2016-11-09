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

# Loader
# TODO implements
chepk_loader () {
	i=1
    sp="/-\|"
    echo -n ' '
    while true
    do
        sleep 0.1
        printf "\b${sp:i++%${#sp}:1}"
    done
}

function ProgressBar {
# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:
# 1.2.1.1 Progress : [########################################] 100%
printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%\r"

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
