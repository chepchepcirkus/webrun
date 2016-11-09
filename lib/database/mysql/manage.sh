#!/bin/bash
function databaseMenu() {
	chepk_echo "Choose an action : " '' separator
	chepk_echo " > set up new database configuration (s)"
	chepk_echo " > dump a database (d)"
	chepk_echo " > restore a database (r)"
	chepk_echo " > dump and restore a database (dr)"
	chepk_echo " > exit (e)"

	read choice;

	case $choice in
		# set up new database configuration
		s) 
			chepk_echo "Enter database name : "
			read databaseName
			chepk_echo "Enter user name : "
			read userName
			chepk_echo "Enter password : "
			read password
			awk '{sub("VAR_DATABASE", "'$databaseName'"); sub("VAR_USERNAME", "'$userName'"); sub("VAR_PASSWORD", "'$password'"); print}' $chepk_libd/database/config/config.skel > $chepk_libd/database/config/$databaseName.cfg
			chepk_echo " > $databaseName configuration file created !" success
			databaseMenu
			;;
		# dump a database
		d) source $chepk_libd/database/mysql/dump.sh 
			chepk_echo "Wich database would you want to dump : " '' separator
			ls $chepk_libd/database/config/*.cfg | awk -F'.' '{splitCount=split($2,splitName,"/"); print splitName[splitCount]}'
			read configFile
			if [ -f $chepk_libd/database/config/$configFile.cfg ]
			then
				source $chepk_libd/database/config/$configFile.cfg
				chepk_echo " > Dump of $database_name begin"
				dump_database $database_username $database_password $database_name dump_perso
				chepk_echo " > Dump of $database_name created" success
			else
				chepk_echo "$chepk_libd/database/config/$configFile.cfg doesn't exists... Please retry..."
				databaseMenu
			fi
		;;
		# restore a database
		r) chepk_echo "restore work in progress" ;;
		# dump and restore a database
		dr) chepk_echo "dump and restore work in progress" ;;
		# exit
		e) main ;;
		*) chepk_echo "This is not an available action, please retry..." error
		main ;;
	esac
}

chepk_echo_empty
chepk_echo " >> Database management" '' separator
databaseMenu
