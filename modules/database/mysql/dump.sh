#!/usr/bin/env bash

#@name dump_database
#@description Dump database
#@args username : database_username | password : database_password | database name : database_name | output file name : name of dump | path of dump : by default create in /tmp | mysql host : by default 127.0.0.1 | mysql port : by default 3306
#@return 0 success | 1 database information incorrect

function_var_dump_database='function dump_database() {
    mysqldump -h$4 -u $1 -p$2 $3 > /tmp/$5.sql;
	return 0;
	RESULT=`mysqlshow -v --user=$1 --password=$2 $3| grep -v Wildcard | grep -o $3`;
	if [ "$RESULT" == $3 ]
	then
		mysqldump -u $1 -p$2 $3 > /tmp/$4.sql;
		return 0;
	else
		return 1;
	fi
}';
#eval $function_var_dump_database

function dump_database() {
    if [ "$5" == '' ]||[ ! -d $5 ]
    then
        dest="/tmp"
    else
        dest=$5
    fi

    host="127.0.0.1"
    port="3306"

    if [ ! "$6" == '' ]
    then
      $host=$6
    fi

    if [ ! "$7" == '' ]
    then
      $port=$7
    fi

    if [ "$8" == '' ] && [ "$9" == '' ]
    then
        #local
        mysqldump -u $1 -p$2 $3 -h $host -port $port > $dest/$4.sql
        return 0
    else
        ssh -T $8@$9 <<+
$function_var_dump_database;
dump_database $1 $db_password $db_name $dump_name '' $db_host $db_port;
if [ "$?" == "0" ]
then
	tar -cf /tmp/$dump_name.tar /tmp/$dump_name.sql;
	exit 0;
else
	exit 1;
fi
+
        if [ "$?" == "0" ]
        then
            new_dump_name=$db_name-`date +"%m-%d-%Y-%H-%M"`;
            rsync -zr -e ssh $db_host_user@$db_host:/tmp/$dump_name.tar /tmp/$new_dump_name.tar
        else
            chk_echo "dump_db_remote_host error"
        fi
    fi

    # FOLLOWING FAILED \=)
	RESULT=`mysqlshow -v --user=$1 --password=$2 $3| grep -v Wildcard | grep -o $3`
	if [ "$RESULT" == $3 ]
	then
		mysqldump -u $1 -p$2 $3 > $dest/$4.sql
		return 0
	else
		return 1
	fi
}

function dump_db_remote_host() {
	# check if config file exists $1
	source $1
	dump_name=$2
	ssh -T $db_remote_host_user@$db_remote_host <<+
$function_var_dump_database;
dump_database $db_username $db_password $db_name $dump_name '' $db_host $db_port;
if [ "$?" == "0" ]
then
	tar -cf /tmp/$dump_name.tar /tmp/$dump_name.sql;
	exit 0;
else
	exit 1;
fi
+
if [ "$?" == "0" ]
then
    new_dump_name=$db_name-`date +"%m-%d-%Y-%H-%M"`;
	rsync -zr -e ssh $db_host_user@$db_host:/tmp/$dump_name.tar /tmp/$new_dump_name.tar
else
    chk_echo "dump_db_remote_host error"
fi
}
