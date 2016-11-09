#! /bin/bash

## parameters ##
rootDir=$3
owner=$(who am i | awk '{print $1}')
email='webmaster@localhost'
sitesEnable='/etc/apache2/sites-enabled/'
sitesAvailable='/etc/apache2/sites-available/'
userDir='/var/www/'

## Add vhost ##
addVhost () {
    chepk_echo " >> Set up a new virtualhost" '' separator
    chepk_echo_empty

    chepk_echo "Project name (without space) :" warning
    read project
    chepk_echo_empty

    chepk_echo "FQDN :" warning
    read fqdn
    chepk_echo_empty

    if [ -d /var/www/$project ];
    then
      chepk_echo "Error : Folder already existing" error
      chepk_echo "What do you want to do ?" 
      chepk_echo "	> remove folder (r) / exit (e)"
      read choice
      case $choice in
        # Exit
        e) chepk_echo "Bye Bye" success separator
        exit 1
        ;;
        # remove folder
        r) rm -rf /var/www/$project
        chepk_echo " > /var/www/$project has been removed"
        ;;
      esac
    fi

    ## FOLDER CREATION ##
    chepk_echo " > Create project folder"
    chepk_echo_empty
    mkdir /var/www/$project

    #cp -r ./skel/* /var/www/$project

    chown -R www-data /var/www/$project
    chgrp -R www-data /var/www/$project
    chmod -R 775 /var/www/$project

    chepk_echo " > Permissions set for www:www to 775 for /var/www/$project folder"

    #awk '{sub("VAR_PROJECT_NAME", "'$project'"); print}' /root/tools/skel/public/index.php > /home/www/$project/public/index.php

    ## APACHE ##
    chepk_echo " > Apache configuration begin..."
    chepk_echo_empty

    awk '{sub("VAR_SERVERNAME", "'$fqdn'"); sub("VAR_PROJECT", "'$project'"); print}' $chepk_libd/vhost/vhost.skel > /etc/apache2/sites-available/$project

    a2ensite $project
    service apache2 restart

    chepk_echo_empty
    chepk_echo " > Apache configuration done with success !" success
    chepk_echo_empty

    ## GIT INITIALISATION ##
    chepk_echo "Would you like to initialize project with git ? ( y / n )"
    read choice
    case $choice in
        y) 
            cd /var/www/$project
            git init
            ;;
        n) 
            ;;
    esac

    ## LOCAL HOST ##
    chepk_echo_empty
    echo "127.0.1.1    $fqdn $project" >> /etc/hosts 
    chepk_echo " > 127.0.1.1    $fqdn $project" warning
    chepk_echo " > above line added to /etc/hosts file" 
    chepk_echo_empty

    addr=$(ifconfig eth0 | awk '$1 == "inet" { split($2,Trunc,":"); print Trunc[2] }')
    chepk_echo " > $addr   $fqdn" warning
    chepk_echo " > if you are working with virtual machine, copy above line in your client /etc/hosts file"
    chepk_echo_empty
    chepk_echo "Virtualhost and folder tree has been done with success" success
    chepk_echo_empty
}

## Remove vhost ##
removeVhost() {
    chepk_echo " >> Remove an existing virtualhost" '' separator
    chepk_echo_empty

    chepk_echo "vhost to remove :" warning
    read vhost
    chepk_echo_empty

    if [ -f /etc/apache2/sites-available/$vhost ];
    then
        # disable vhost 
        a2dissite $vhost
        # read vhost file
        # grep root folder from vhost file
        documentRootLine=$(trim "$(sudo cat /etc/apache2/sites-available/$vhost | grep 'DocumentRoot')")
        documentRoot=${documentRootLine##*[[:space:]]}
        
        if [ -d $documentRoot ] && [ $documentRoot != "/var/www/" ]
        then
            chepk_echo $documentRoot" has been deleted"
            # remove root folder
            rm -rf $documentRoot
            # remove vhost
            chepk_echo '/etc/apache2/sites-available/$vhost has been deleted'
            rm -rf /etc/apache2/sites-available/$vhost
            # restart apache
            service apache2 restart
        else
            chepk_echo "Document root folder is missing in vhost file" error
        fi
        
    else
        chepk_echo "virtualhost does not exists." error
        chepk_echo_empty
        vhostMenu
    fi
}

## VHOST MENU ##
vhostMenu() {
    chepk_echo "Vhost management : " '' separator
    chepk_echo " > add a new vhost (a)"
    chepk_echo " > remove a vhost (r)"

    read choice;

    case $choice in
        # add
        a) addVhost ;;
        # remove
        r) removeVhost ;;
    esac    
}

vhostMenu
