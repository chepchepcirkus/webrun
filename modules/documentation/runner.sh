#!/usr/bin/env bash
# Build documentation

#@name buildDoc
#@desc
# This will automatically build the README.md with all functions name with respective arguments and descriptions.
# Respect the following convention to have the right output :
#
#    #@main main name
#    #@intro introduction for main programm
#    #@name function name
#    #@desc
#    # function description
#    #@desc
#    #args argument label and description separated by : then previous argument group separated by |
#    #@example an example of your function in use
#@desc
buildDoc() {
    if [ "$chk_cli" == "0" ]
    then
        chk_echo "From wich language would you build the documentation : " '' separator
        chk_echo " > sh / bash (sh)"
        chk_echo " > php (php)"
        read language

        chk_echo "Enter the path of your project : "
        read path

        while [ ! -d $path ]
        do
             chk_echo "The path is not correct..." error
             chk_echo "Enter the path of your project : "
             read path
        done

        chk_echo "Enter the name of documentation file : "
        chk_echo "(if the file already exists, it will overwrite)"
        read docFileName
    else
        language=$1
        path=$2
        docFileName=$3
    fi

    if [ -f $path/$docFileName.md ]
    then
        rm $path/$docFileName.md
    fi

    case $language in
        # bash / sh
        "sh")
            filesToParse=$(find $path -name '*.sh' | cat | sort -r)
            chk_echo " > Your documentation file is under construction..."
            chk_echo_empty
            count=0
            total=$(($(echo "$filesToParse" | wc -l) + 1 ))
            for i in $filesToParse
            do
                if [ -f $i ]
                then
                    count=$((count + 1))
                    chk_progressBar count total
                    awk -vlock="" -f $chk_module_d/documentation/bash_doc.awk $i >> $path/$docFileName.md
                fi  
            done
            count=$((count + 1))
            chk_progressBar count total
            ;;
        # php
        "php") chk_echo "php documentation file (work in progress...)" ;;
        *) chk_echo "This is not an available language, please retry..." error
        buildDoc ;;
    esac
    
    # success
    chk_echo_empty
    chk_echo_empty
    chk_echo "$count files have been parsed ."
    chk_echo_empty
    chk_echo "$path/$docFileName.md has been successfully created." success
    chk_echo_empty
    
    return 0
}

chk_echo " >> Build documentation of your project" '' separator
buildDoc $1 $2 $3
