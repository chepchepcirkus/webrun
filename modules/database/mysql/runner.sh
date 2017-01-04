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
    db_host_user=''
    db_host_identify_key=''

    chk_echo "is the database stand on a remote server ? (y/n)"
    read is_remote_db

    if [ $is_remote_db == "y" ]
    then
        chk_echo "Enter user on remote server : "
        read db_user_host

        chk_echo "Enter identify key file path : "
        read db_host_identify_key
    fi
	awk '{sub("VAR_DATABASE", "'$databaseName'"); sub("VAR_USERNAME", "'$userName'"); sub("VAR_PASSWORD", "'$password'"); sub("VAR_HOST", "'$db_host'"); sub("VAR_USER_HOST", "'$db_user_host'"); sub("VAR_IDENTIFY_HOST_KEY_PATH", "'$db_host_identify_key'"); print}' $chk_module_d/database/config/config.skel > $chk_module_d/database/config/$databaseName.cfg
	chk_echo " > $databaseName configuration file created !" success
	databaseMenu
}

function databaseMenu() {
    if [ "$chk_cli" == "0" ]
        then
        chk_echo_empty
        chk_echo " >> Database management" '' separator
        chk_echo "Choose an action : " '' separator
        chk_echo " > (s) set up new database configuration"
        chk_echo " > (d) dump a database"
        chk_echo " > (r) restore a database"
        chk_echo " > (dr) dump and restore a database"
        chk_echo " > (e) exit"

	    read choice;
    else
        choice=$3;
    fi

	case $choice in
		# set up new database configuration
		s) create_db_config_file $*;;
		# dump a database
		d)  source $chk_module_d/database/mysql/dump.sh
		    if [ "$chk_cli" == "0" ]
            then
                chk_echo "Wich database would you want to dump : " '' separator
                ls $chk_module_d/database/config/*.cfg | awk -F'.' '{splitCount=split($2,splitName,"/"); print splitName[splitCount]}'
			    read configFile
			else
			    configFile=$4
			fi

			if [ -f $chk_module_d/database/config/$configFile.cfg ]
			then
				source $chk_module_d/database/config/$configFile.cfg
				chk_echo " > Dump of $db_name begin"
				date=`date +%Y-%m-%d-%H-%M-%S`
				dump_database $db_username $db_password $db_name $db_name-$date
				chk_echo " > Dump of $db_name created in /tmp/$db_name-$date.sql" success
			else
			    if [ "$chk_cli" == "0" ]
                then
                    chk_echo "$chk_module_d/database/config/$configFile.cfg doesn't exists... Please retry..."
                    databaseMenu
                else
                    exit 1
                fi
			fi
		;;
		# restore a database
		r)  source $chk_module_d/database/mysql/restore.sh
		    if [ "$chk_cli" == "0" ]
            then
                chk_echo "Wich database would you want to dump : " '' separator
                ls $chk_module_d/database/conf ig/*.cfg | awk -F'.' '{splitCount=split($2,splitName,"/"); print splitName[splitCount]}'
                read configFile

                chk_echo "sql file path to import :" '' separator
                read sql_file
			else
			    configFile=$4
			    sql_file=$5
			fi

			if [ ! -f $chk_module_d/database/config/$configFile.cfg ]
			then
			    if [ "$chk_cli" == "0" ]
                then
                    chk_echo "$chk_module_d/database/config/$configFile.cfg doesn't exists... Please retry..."
                    databaseMenu
                else
                    exit 1
                fi
			fi
			if [ ! -f $sql_file ]
			then
			    if [ "$chk_cli" == "0" ]
                then
                    chk_echo "$sql_file is not a valid file." error
                    databaseMenu
                else
                    exit 1
                fi
			fi

			source $chk_module_d/database/config/$configFile.cfg
            chk_echo " > Restore of $db_name begins"
            restore_database $db_username $db_password $db_name $sql_file
            chk_echo " > Done !" success
			;;
		yz) source $chk_module_d/database/mysql/dump.sh
			
			# choose source config file
			# choose destination config file
			if [ "$chk_cli" == "0" ]
            then
                chk_echo "Wich database would you want to dump : " '' separator
                ls $chk_module_d/database/config/*.cfg | awk -F'.' '{splitCount=split($2,splitName,"/"); print splitName[splitCount]}'
			    read configFile
			else
			    configFile=$2
			fi

            if [ -f $chk_module_d/database/config/$configFile.cfg ]
            then
                if [ "$chk_cli" == "0" ]
                then
                    chk_echo "$chk_module_d/database/config/$configFile.cfg file doesn't exists..." error
                    databaseMenu
                else
                    exit 1
                fi
            fi

            source $chk_module_d/database/config/$configFile.cfg
            dump_name=$db_name-`date +"%m-%d-%Y-%H-%M"`;

			# check if source is on remote host SOURCE_REMOTE_HOST_FLAG
			dump_db_remote_host $chk_module_d/database/config/$configFile.cfg $dump_name
			#if []
			# check if dest is on remote host DEST_REMOTE_HOST_FLAG
			#get_dump_from_remote_host dump_name
			# restore
		;;
		# exit
		e) main ;;
		*) chk_echo "This is not an available action, please retry..." error
		main ;;
	esac
}

databaseMenu $*
