#!/bin/bash

#@name dump_database
#@description Dump database
#@args username | password | database name | output file name
#@return 0 success | 1 database information incorrect

function dump_database() {		
	RESULT=`mysqlshow -v --user=$1 --password=$2 $3| grep -v Wildcard | grep -o $3`
	if [ "$RESULT" == $3 ]; then
		mysqldump -u $1 -p$2 $3 > /tmp/$4.sql
		return 0
	else 
		return 1
	fi
}
