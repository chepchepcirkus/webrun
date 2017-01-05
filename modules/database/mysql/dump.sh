#!/usr/bin/env bash

#@name dump_database
#@description Dump database
#@args username : database_username | password : database_password | database name : database_name | output file name : name of dump | path for output file : by default create in /tmp | mysql host : by default 127.0.0.1 | mysql port : by default 3306
#@return 0 success | 1 database information incorrect

fct_dump_db='function dump_db() {
    mysqldump -h $6 -port$7 -u $1 -p$2 $3 > $5/$4.sql;
	return 0;
}';

function dump_database() {
    if [ "$8" == '' ] && [ "$9" == '' ]
    then
        #local
        $fct_dump_db;
        dump_db $*
        return 0
    else
        ssh -T $8@$9 <<+
$fct_dump_db;
dump_db $*;
#echo "$?";
#if [ "$?" == "0" ];
#then
	tar -cf /tmp/$4.tar.gz /tmp/$4.sql;
	exit 0;
#else
#	exit 1;
#fi
+
        if [ "$?" == "0" ]
        then
            new_dump_name=$db_name-`date +"%m-%d-%Y-%H-%M"`
            rsync -zr -e ssh $8@$9:/tmp/$4.tar.gz /tmp/$new_dump_name.tar.gz
            tar -xf /tmp/$new_dump_name.tar.gz
            rm -f /tmp/$new_dump_name.tar.gz
        else
            chk_echo "dump_db_remote_host error"
        fi
    fi
}
