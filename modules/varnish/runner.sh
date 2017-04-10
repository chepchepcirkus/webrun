#!/usr/bin/env bash
# Varnish

function desactivate_varnish() {

    chk_echo " > Vhosts Modification"
	
    enabled_vhosts_path=/etc/apache2/sites-enabled
    availabled_vhosts_path=/etc/apache2/sites-available
    enabled_vhosts=$(ls $enabled_vhosts_path)

    for i in $enabled_vhosts
    do
		if [ -f $availabled_vhosts_path/$i ]
		then
			availabled_vhosts_path=/etc/apache2/sites-available
			original="$(sudo cat $availabled_vhosts_path/$i)"
			freshfile=${original/"<VirtualHost *:8080>"/"<VirtualHost *:80>"}
			sudo chmod 777 $availabled_vhosts_path/$i
			sudo echo "$freshfile" > $availabled_vhosts_path/$i
			sudo chmod 644 $availabled_vhosts_path/$i
		else
			chk_echo_empty
			chk_echo "$availabled_vhosts_path/$i is not present" warning
		fi
    done

    chk_echo_empty
    chk_echo " > Vhosts Modification DONE" success

    chk_echo_empty
    chk_echo " > Apache ports modification"
    
	apache_ports_conf=/etc/apache2/ports.conf
    original="$(sudo cat $apache_ports_conf)"
	freshfile="${original/NameVirtualHost *:8080/NameVirtualHost *:80}"
	freshfile=${freshfile/Listen 8080/Listen 80}
	sudo chmod 777 $apache_ports_conf
	sudo echo "$freshfile" > $apache_ports_conf
	sudo chmod 644 $apache_ports_conf
	
    chk_echo_empty
    chk_echo " > Apache ports modification DONE" success
    chk_echo_empty
    
    chk_echo " > Reloading Apache service"
    chk_echo_empty
    sudo service apache2 restart
    chk_echo_empty
    chk_echo " > Reloading Varnish service"
    sudo service varnish stop
    chk_echo_empty
    return 0
}

function activate_varnish() {
    # Check installation
#    if [ $(command -V varnishd | wc -c) -ne 0 ]
#    then
#        chk_echo "varnish is not present : $(sudo varnishd -V)" error
#        chk_echo "Please first remove the installation" error
#        chk_echo_empty
#        exit 1;
#    fi

	chk_echo " > Vhosts Modification"

    enabled_vhosts_path=/etc/apache2/sites-enabled
    availabled_vhosts_path=/etc/apache2/sites-available
    enabled_vhosts=$(ls $enabled_vhosts_path)

    for i in $enabled_vhosts
    do
		if [ -f $availabled_vhosts_path/$i ]
		then
			availabled_vhosts_path=/etc/apache2/sites-available
			original="$(sudo cat $availabled_vhosts_path/$i)"
			freshfile=${original/"<VirtualHost *:80>"/"<VirtualHost *:8080>"}
			#freshfile=${original/<VirtualHost *:8080>/"<VirtualHost *:80>"}
			sudo chmod 777 $availabled_vhosts_path/$i
			sudo echo "$freshfile" > $availabled_vhosts_path/$i
			sudo chmod 644 $availabled_vhosts_path/$i
		else
			chk_echo "$availabled_vhosts_path/$i is not present" warning
		fi
    done

    chk_echo_empty
    chk_echo " > Vhosts Modification DONE" success
    
    chk_echo_empty
    chk_echo " > Apache ports modification"
    
	apache_ports_conf=/etc/apache2/ports.conf
    original="$(sudo cat $apache_ports_conf)"
	freshfile="${original/NameVirtualHost *:80/NameVirtualHost *:8080}"
	freshfile=${freshfile/Listen 80/Listen 8080}
	sudo chmod 777 $apache_ports_conf
	sudo echo "$freshfile" > $apache_ports_conf
	sudo chmod 644 $apache_ports_conf
	
    chk_echo_empty
    chk_echo " > Apache ports modification DONE" success
    chk_echo_empty

    chk_echo " > Reloading Apache service"
    chk_echo_empty
    sudo service apache2 restart
    chk_echo_empty
    chk_echo " > Reloading Varnish service"
    sudo service varnish restart
    chk_echo_empty
    return 0
}

function varnishMenu() {
    chk_echo "Varnish : " '' separator
    chk_echo " > (1) Activate"
    chk_echo " > (0) Desactivate"

    read choice

    case $choice in
        # activate
        1) activate_varnish ;;
        # desactivate
        0) desactivate_varnish ;;
        e) main ;;
    esac
}

varnishMenu
