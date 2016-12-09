#!/usr/bin/env bash
# Manage your database

function create_db_config_file () {
	chk_echo "Enter database name : "
	read databaseName
	chk_echo "Enter user name : "
	read userName
	chk_echo "Enter password : "
	read password
	chk_echo "Enter host of database : "
	read db_host
	db_user_host=''
	db_identify_file_host=''
	
	chk_echo "is the database stand on a remote server ? (y/n)"
	read is_remote_db
	
	if [ $is_remote_db == "y" ]
	then
		chk_echo "Enter user on remote server : "
		read db_user_host
		
		chk_echo "Enter identify key file path : "
		read db_identify_file_host
	fi
	awk '{sub("VAR_DATABASE", "'$databaseName'"); sub("VAR_USERNAME", "'$userName'"); sub("VAR_PASSWORD", "'$password'"); sub("VAR_HOST", "'$db_host'"); sub("VAR_HOST_USER", "'$db_user_host'"); sub("VAR_HOST_IDENTIFY_KEY_PATH", "'$db_identify_file_host'"); print}' $chk_module_d/database/config/config.skel > $chk_module_d/database/config/$databaseName.cfg
	chk_echo " > $databaseName configuration file created !" success
	databaseMenu
}

function databaseMenu() {
	chk_echo_empty
	chk_echo " >> Database management" '' separator
	chk_echo "Choose an action : " '' separator
	chk_echo " > (s) set up new database configuration"
	chk_echo " > (d) dump a database"
	chk_echo " > (r) restore a database"
	chk_echo " > (dr) dump and restore a database"
	chk_echo " > (e) exit"

	read choice;

	case $choice in
		# set up new database configuration
		s) create_db_config_file ;;
		# dump a database
		d) source $chk_module_d/database/mysql/dump.sh
			chk_echo "Wich database would you want to dump : " '' separator
			ls $chk_module_d/database/config/*.cfg | awk -F'.' '{splitCount=split($2,splitName,"/"); print splitName[splitCount]}'
			read configFile
			if [ -f $chk_module_d/database/config/$configFile.cfg ]
			then
				source $chk_module_d/database/config/$configFile.cfg
				chk_echo " > Dump of $database_name begin"
				dump_database $db_username $db_password $db_name dump_perso
				chk_echo " > Dump of $db_name created" success
			else
				chk_echo "$chk_module_d/database/config/$configFile.cfg doesn't exists... Please retry..."
				databaseMenu
			fi
		;;
		# restore a database
		r) chk_echo "restore work in progress" ;;
		# dump and restore a database
		dr) chk_echo "dump and restore work in progress"
			source $chk_module_d/database/mysql/dump.sh
			
			# choose source config file
			# choose destination config file
			# check if source is on remote host SOURCE_REMOTE_HOST_FLAG
			dump_db_remote_host $chk_module_d/database/config/poldol.cfg
			if []
			# check if dest is on remote host DEST_REMOTE_HOST_FLAG
			get_dump_from_remote_host 
			# restore
		;;
		# exit
		e) main ;;
		*) chk_echo "This is not an available action, please retry..." error
		main ;;
	esac
}

databaseMenu
