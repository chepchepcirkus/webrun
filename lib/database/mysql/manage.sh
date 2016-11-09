#!/bin/bash

function create_db_config_file () {
	chepk_echo "Enter database name : "
	read databaseName
	chepk_echo "Enter user name : "
	read userName
	chepk_echo "Enter password : "
	read password
	chepk_echo "Enter host of database : "
	read db_host
	db_user_host=''
	db_identify_file_host=''
	
	chepk_echo "is the database stand on a remote server ? (y/n)"
	read is_remote_db
	
	if [ $is_remote_db == "y" ]
	then
		chepk_echo "Enter user on remote server : "
		read db_user_host
		
		chepk_echo "Enter identify key file path : "
		read db_identify_file_host
	fi
	awk '{sub("VAR_DATABASE", "'$databaseName'"); sub("VAR_USERNAME", "'$userName'"); sub("VAR_PASSWORD", "'$password'"); sub("VAR_HOST", "'$db_host'"); sub("VAR_HOST_USER", "'$db_user_host'"); sub("VAR_HOST_IDENTIFY_KEY_PATH", "'$db_identify_file_host'"); print}' $chepk_libd/database/config/config.skel > $chepk_libd/database/config/$databaseName.cfg
	chepk_echo " > $databaseName configuration file created !" success
	databaseMenu
}

function databaseMenu() {
	chepk_echo_empty
	chepk_echo " >> Database management" '' separator
	chepk_echo "Choose an action : " '' separator
	chepk_echo " > (s) set up new database configuration"
	chepk_echo " > (d) dump a database"
	chepk_echo " > (r) restore a database"
	chepk_echo " > (dr) dump and restore a database"
	chepk_echo " > (e) exit"

	read choice;

	case $choice in
		# set up new database configuration
		s) create_db_config_file ;;
		# dump a database
		d) source $chepk_libd/database/mysql/dump.sh 
			chepk_echo "Wich database would you want to dump : " '' separator
			ls $chepk_libd/database/config/*.cfg | awk -F'.' '{splitCount=split($2,splitName,"/"); print splitName[splitCount]}'
			read configFile
			if [ -f $chepk_libd/database/config/$configFile.cfg ]
			then
				source $chepk_libd/database/config/$configFile.cfg
				chepk_echo " > Dump of $database_name begin"
				dump_database $db_username $db_password $db_name dump_perso
				chepk_echo " > Dump of $db_name created" success
			else
				chepk_echo "$chepk_libd/database/config/$configFile.cfg doesn't exists... Please retry..."
				databaseMenu
			fi
		;;
		# restore a database
		r) chepk_echo "restore work in progress" ;;
		# dump and restore a database
		dr) chepk_echo "dump and restore work in progress"
			source $chepk_libd/database/mysql/dump.sh
			dump_db_remote_host $chepk_libd/database/config/poldol.cfg
			# choose source config file
			# choose destination config file
			# check if source is on remote host SOURCE_REMOTE_HOST_FLAG
			# check if dest is on remote host DEST_REMOTE_HOST_FLAG
			
			## if SOURCE_REMOTE_HOST_FLAG
			## connect
			# dump source
			# restore
		;;
		# exit
		e) main ;;
		*) chepk_echo "This is not an available action, please retry..." error
		main ;;
	esac
}

databaseMenu
