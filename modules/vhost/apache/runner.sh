#!/usr/bin/env bash
# Set up a vhost

## parameters ##
rootDir=$3
owner=$(who am i | awk '{print $1}')
email='webmaster@localhost'
sitesEnable='/etc/apache2/sites-enabled/'
sitesAvailable='/etc/apache2/sites-available/'
userDir='/var/www/'

## Add vhost ##
function addApacheVhost () {
    chk_echo " >> Set up a new virtualhost" '' separator
    chk_echo_empty

    chk_echo "Project name (without space) :" warning
    read project
    chk_echo_empty

    chk_echo "FQDN :" warning
    read fqdn
    chk_echo_empty

    if [ -d /var/www/$project ];
    then
      chk_echo "Error : Folder already existing" error
      chk_echo "What do you want to do ?"
      chk_echo "	> remove folder (r) / exit (e)"
      read choice
      case $choice in
        # Exit
        e) chk_echo "Bye Bye" success separator
        exit 1
        ;;
        # remove folder
        r) rm -rf /var/www/$project
        chk_echo " > /var/www/$project has been removed"
        ;;
      esac
    fi

    ## FOLDER CREATION ##
    chk_echo " > Create project folder"
    chk_echo_empty
    mkdir /var/www/$project

    #cp -r ./skel/* /var/www/$project

    chown -R www-data /var/www/$project
    chgrp -R www-data /var/www/$project
    chmod -R 775 /var/www/$project

    chk_echo " > Permissions set for www:www to 775 for /var/www/$project folder"

    #awk '{sub("VAR_PROJECT_NAME", "'$project'"); print}' /root/tools/skel/public/index.php > /home/www/$project/public/index.php

    ## APACHE ##
    chk_echo " > Apache configuration begin..."
    chk_echo_empty

    awk '{sub("VAR_SERVERNAME", "'$fqdn'"); sub("VAR_PROJECT", "'$project'"); print}' $chk_module_d/vhost/vhost.skel > /etc/apache2/sites-available/$project

    a2ensite $project
    service apache2 restart

    chk_echo_empty
    chk_echo " > Apache configuration done with success !" success
    chk_echo_empty

    ## GIT INITIALISATION ##
    chk_echo "Would you like to initialize project with git ? ( y / n )"
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
    chk_echo_empty
    echo "127.0.1.1    $fqdn $project" >> /etc/hosts 
    chk_echo " > 127.0.1.1    $fqdn $project" warning
    chk_echo " > above line added to /etc/hosts file"
    chk_echo_empty

    addr=$(ifconfig eth0 | awk '$1 == "inet" { split($2,Trunc,":"); print Trunc[2] }')
    chk_echo " > $addr   $fqdn" warning
    chk_echo " > if you are working with virtual machine, copy above line in your client /etc/hosts file"
    chk_echo_empty
    chk_echo "Virtualhost and folder tree has been done with success" success
    chk_echo_empty
}

## Remove vhost ##
function removeApacheVhost() {
    chk_echo " >> Remove an existing virtualhost" '' separator
    chk_echo_empty

    chk_echo "vhost to remove :" warning
    read vhost
    chk_echo_empty

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
            chk_echo $documentRoot" has been deleted"
            # remove root folder
            rm -rf $documentRoot
            # remove vhost
            chk_echo '/etc/apache2/sites-available/$vhost has been deleted'
            rm -rf /etc/apache2/sites-available/$vhost
            # restart apache
            service apache2 restart
        else
            chk_echo "Document root folder is missing in vhost file" error
        fi
        
    else
        chk_echo "virtualhost does not exists." error
        chk_echo_empty
        vhostMenu
    fi
}

## VHOST MENU ##
function vhostMenu() {
    chk_echo "Vhost management : " '' separator
    chk_echo " > (v) add a new vhost"
    chk_echo " > (r) remove a vhost"

    read choice;

    case $choice in
        # add
        a) addApacheVhost ;;
        # remove
        r) removeApacheVhost ;;
    esac    
}

vhostMenu
