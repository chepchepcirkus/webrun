#!/usr/bin/env bash
# Nodejs library management

function install_node() {

    # Check installation
    HAS_NODE=`command -v node | wc -c`
    if [[ $HAS_NODE -ne 0 ]]
    then
        chk_echo "node is already present : $(node -v)" error
        chk_echo "Please first remove the installation" error
        chk_echo_empty
        exit 1;
    fi

    # Check wanted version
    chk_echo "Enter the url of the version you want to install :"
    chk_echo "list of version available here : https://nodejs.org/dist/" warning
    read VERSION_URL
    HEADER=$(HEAD $VERSION_URL | head -n1 | awk '{ print $1 }')

    while [ ! $HEADER == "200" ]
    do
         chk_echo "The version is not correct..." error
         chk_echo "Enter the version you want to install :"
         read VERSION
         HEADER=$(HEAD $VERSION_URL | head -n1 | awk '{ print $1 }')
    done

    TEMP_PATH=/tmp
    cd $TEMP_PATH

    chk_echo_empty
    chk_echo " > Downloading $VERSION in /tmp directory"

    TEMP_NAME=web_run_node_$(cat /proc/sys/kernel/random/uuid)
    mkdir $TEMP_NAME

    curl $VERSION_URL | tar xz --directory /tmp/ -C $TEMP_NAME

    TEMP_PATH=$(ls -d $TEMP_PATH/$TEMP_NAME/*/|head -n 1)
    echo $TEMP_PATH

    # Check structure of archive downloaded
    if [ ! -d $TEMP_PATH/lib/node_modules ]||[ ! -d $TEMP_PATH/include/node ]||[ ! -f $TEMP_PATH/bin/node ]
    then
        chk_echo_empty
        chk_echo "lib/node_modules/ or include/node/ or bin/node are not found in downloaded archive" error
        exit 1;
    fi

    chk_echo_empty
    chk_echo " > Set current user owner of /usr/local/"

    # On s'ajoute au group afin d'avoir acces à /usr/local/bin
    ME=$(whoami)
    sudo chown -R $ME /usr/local

    chk_echo_empty
    chk_echo " > Copy lib/node_modules from archive to /usr/local/lib/"
    # Copie des modules node
    cp -r $TEMP_PATH/lib/node_modules/ /usr/local/lib/

    chk_echo_empty
    chk_echo " > Copy include/node from archive to /usr/local/include/"
    cp -r $TEMP_PATH/include/node /usr/local/include/

    if [ -f $TEMP_PATH/share/man/man1/node.1 ]
    then
        # Mise en place de la commande man pour node
        chk_echo_empty
        chk_echo " > Set man command for node"
        if [ ! -d /usr/local/man/man1 ]
        then
            mkdir /usr/local/man/man1
        fi
        cp $TEMP_PATH/share/man/man1/node.1 /usr/local/man/man1/
    fi

    # Copie de l'executable node
    chk_echo_empty
    chk_echo " > Copy of node executable"
    cp $TEMP_PATH/bin/node /usr/local/bin/

    chk_echo_empty
    chk_echo " > Set symbolic link to use npm"
    # Mise en place du lien symbolique pour npm (qui est un module de node)
    cd /usr/local/bin/
    ln -s "/usr/local/lib/node_modules/npm/bin/npm-cli.js" /usr/bin/npm

    chk_echo_empty
    chk_echo "Node => $(node -v)" warning

    chk_echo_empty
    chk_echo "Npm => $(npm -v)" warning

    rm -rf $TEMP_PATH

    chk_echo_empty
    chk_echo "Installation of node is done" success
    chk_echo_empty

    exit 0
}

function remove_node() {
    path_to_remove=`cat $chk_module_d/node/node_path.txt`;
    while read p
    do
        if [ -d $p ]||[ -f $p ];
        then
            sudo rm -rf $p
            chk_echo $p ''
        fi
    done <<< "$path_to_remove"
    chk_echo "Node/Npm directories and files above has been successfully removed" success

    exit 0
}

#@name Nodejs library management
#@desc
# You can do the following action:
# do a fresh install of node and npm
# or clean all node component from your environement
#@desc
function nodejsMenu() {
    chk_echo "Nodejs : " '' separator
    chk_echo " > (i) Install"
    chk_echo " > (r) Remove"

    read choice

    case $choice in
        # add
        i) install_node ;;
        # remove
        r) remove_node ;;
    esac
}

nodejsMenu