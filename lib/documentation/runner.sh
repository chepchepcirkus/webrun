#!/usr/bin/env bash
# Build documentation

#@name buildDoc
#@description This will automatically build the README.md with all functions name with respective arguments and descriptions. 
#@description Respect the following convention to have the right output : 
#@description   #@main main name
#@description   #@intro introduction for main programm
#@description   #@name function name
#@description   #@description function description
#@description   #args argument label and description separated by : then previous argument group separated by |
#@description   #@example an example of your function in use
buildDoc() {
    
    chepk_echo "From wich language would you build the documentation : " '' separator
    chepk_echo " > sh / bash (sh)"
    chepk_echo " > php (php)"
    read language
    
    chepk_echo "Enter the path of your project : "
    read path
    
    while [ ! -d $path ]
    do
         chepk_echo "The path is not correct..." error
         chepk_echo "Enter the path of your project : "
         read path
    done
    
    chepk_echo "Enter the name of documentation file : "
    chepk_echo "(if the file already exists, it will overwrite)"
    read docFileName
    
    if [ -f $path/$docFileName.md ]
    then
        rm $path/$docFileName.md
    fi
    
    case $language in
        # bash / sh
        sh)
            filesToParse=$(find $path -name '*.sh' | cat | sort -r)
            chepk_echo " > Your documentation file is under construction..."
            chepk_echo_empty
            count=0
            total=$(($(echo "$filesToParse" | wc -l) + 1 ))
            for i in $filesToParse
            do
                if [ -f $i ]
                then
                    count=$((count + 1))
                    chepk_progressBar count total
                    awk -f $chepk_libd/documentation/bash_doc.awk $i >> $path/$docFileName.md
                fi  
            done
            count=$((count + 1))
            chepk_progressBar count total
            ;;
        # php
        php) chepk_echo "php documentation file (work in progress...)" ;;
        *) chepk_echo "This is not an available language, please retry..." error
        buildDoc ;;
    esac
    
    # success
    chepk_echo_empty
    chepk_echo_empty
    chepk_echo "$count files have been parsed ."
    chepk_echo_empty
    chepk_echo "$path/$docFileName.md has been successfully created." success
    chepk_echo_empty
    
    return 0
}

chepk_echo " >> Build documentation of your project" '' separator
buildDoc
