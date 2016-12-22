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

    cd /tmp
    chk_echo " > Downloading $VERSION in /tmp directory"
    curl $VERSION_URL | tar xz . temp_node

    TEMP_PATH=/tmp/temp_node
    cd $TEMP_PATH

    chk_echo " > Set current user owner of /usr/local/"

    # On s'ajoute au group afin d'avoir acces à /usr/local/bin
    ME=$(whoami)
    sudo chown -R $ME /usr/local

    chk_echo " > Copy lib/node_modules from archive to /usr/local/lib/"
    # Copie des modules node
    cp -r $TEMP_PATH/lib/node_modules/ /usr/local/lib/

    chk_echo " > Copy include/node from archive to /usr/local/include/"
    cp -r $TEMP_PATH/include/node /usr/local/include/

    # Mise en place de la commande man pour node
    chk_echo " > Set man command for node"
    mkdir /usr/local/man/man1
    cp $TEMP_PATH/share/man/man1/node.1 /usr/local/man/man1/

    # Copie de l'executable node
    chk_echo " > Copy of node executable"
    cp bin/node /usr/local/bin/

    chk_echo " > Set symbolic link to use npm"
    # Mise en place du lie symbolique pour npm (qui est un module de node)
    cd /usr/local/bin/
    ln -s "/usr/local/lib/node_modules/npm/bin/npm-cli.js" ../npm

    rm -rf /tmp/node-$VERSION /tmp/node-$VERSION.tar.gz
    chk_echo "Installation of node $VERSION is done" success

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