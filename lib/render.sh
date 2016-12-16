#!/usr/bin/env bash


#@title-3 Render Functions
#@intro Render custom output with state color
#@intro Fill free to add all your tips functions here ;)

#@name chk_echo
#@desc
# Custom echo function, handle state by color
#@desc
#@args string : string to echo | state : error, warning, success | separator : "separator" add a separator at the top
function chk_echo () {
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
			error) render_chk_echo "$1" "31m" $separator ;;
			# Warning state
			warning) render_chk_echo "$1" "33m" $separator ;;
			# Success state
			success) render_chk_echo "$1" "32m" $separator ;;
		esac
	else
		render_chk_echo "$1" "36m" $separator
	fi
}

function render_chk_echo () {
    if [ "$chk_cli" == "0" ]
    then
        echo -e $3"\e["$2 $1 "\e[0m\r"
    else
        chk_prefix=""
        case $1 in
            # Error state
            "31m") chk_prefix="[ ERROR ] " ;;
            # Warning state
            "33m") chk_prefix="[ WARNING ] " ;;
            # Success state
            "32m") chk_prefix="[ SUCCESS ] " ;;
        esac
        echo $chk_prefix $1 >> $chk_var_d/cli.log
    fi
}

## Empty LINE ##
function chk_echo_empty () {
	echo -e ''
}

## SEPARATOR ##
function chk_echo_separator () {
	echo '\e[36m#####################################################\e[0m\r\n'
}


#@name chk_progressBar
#@description display a progress bar
#@description call this function for each step throw a while or a for loop
#@args current step : integer | total steps : integer
function chk_progressBar () {
    progress=$(((${1}*100/${2}*100)/100 ))
	done=$(((${progress}*4)/10))
    left=$((40-$done))
    fill=$(printf "%${done}s")
    empty=$(printf "%${left}s")
	printf "\rProgress : [${fill// /=}${empty// /.}] ${progress}%%\r"
	sleep 0.1
}