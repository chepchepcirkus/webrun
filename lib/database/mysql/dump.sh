#!/bin/bash

#@name dump_database
#@description Dump database
#@args username | password | database name | output file name
#@return 0 success | 1 database information incorrect

function_var_dump_database='function dump_database() { 
	RESULT=`mysqlshow -v --user=$1 --password=$2 $3| grep -v Wildcard | grep -o $3`;
	if [ "$RESULT" == $3 ]
	then
		mysqldump -u $1 -p$2 $3 > /tmp/$4.sql;
		return 0;
	else
		return 1;
	fi
}'
eval $function_var_dump_database

function dump_db_remote_host() {
	# check if config file exists $1
	source $1
	ssh -T $db_host_user@$db_host <<+
$function_var_dump_database;
dump_database $db_username $db_password $db_name dump_by_shh
+
}
