#!/usr/bin/env bash

#@name restore_database
#@description Restore a database from a sql file
#@args username : database_username | password : database_password | database name : database_name | path of file to import : absolute path | mysql host : by default 127.0.0.1 | mysql port : by default 3306
#@return 0 : success | 1 : database information incorrect | 2 : sql file path incorrect
fct_restore_db='function restore_db() {
    mysql -h $5 -port$6 -u $1 -p$2 $3 < $4;
	return 0;
}';
function restore_database(){
	if [ ! -f $4 ]; then
	    #sql file path incorrect
		return 2
	fi
	if [ "$7" == '' ] && [ "$8" == '' ]
    then
        #local
        $fct_restore_db;
        restore_db $*
        return 0
    else
        file_path=$4
        path=${file_path%/*}
        file_name=${file_path##*/}
    	tar -cf /tmp/$file_name.tar.gz $4;

    	ssh_command=$8@$9
        if [ ! "$9" == "" ]
        then
            ssh_command="-i $9 $ssh_command"
        fi
        rsync -zr -e ssh /tmp/$file_name.tar.gz $ssh_command:/tmp/
        ssh -T $ssh_command <<+
$fct_restore_db;
tar -xf /tmp/$file_name.tar.gz;
restore_db "$1" "$2" "$3" "/tmp/$file_name" "$5" "$6";
rm -f /tmp/$file_name.tar.gz;
+
    rm -rf /tmp/$file_name.tar.gz
    fi
}
