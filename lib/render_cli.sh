#!/usr/bin/env bash

#@title Cli Render Functions
#@intro These functions will be available in all module executed in cli to render output in a log file
#@intro Fill free to add all your tips functions here ;)

#@name chk_echo
#@desc
# Custom echo function, handle state as message prefix
#@desc
#
#@args string : string to echo | state : error, warning, success | separator : "separator" add a separator at the top
function chk_echo () {
	chk_prefix=""
    case $2 in
        # Error state
        error) chk_prefix="[ ERROR ] " ;;
        # Warning state
        warning) chk_prefix="[ WARNING ] " ;;
        # Success state
        success) chk_prefix="[ SUCCESS ] " ;;
    esac
    echo $chk_prefix $1 >> $chk_var_d/cli.log
}

function render_chk_echo () {
    return 0
}

function chk_echo_empty () {
    return 0
}

function chk_echo_separator () {
    return 0
}

function chk_progressBar () {
 return 0
}