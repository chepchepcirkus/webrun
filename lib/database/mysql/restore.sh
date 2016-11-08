#!/bin/bash

#@name restore_database
#@description Restore a database from a sql file
#@args username | password | database name | existing dump path
#@return 0 success | 1 database information incorrect | 2 sql file path incorrect
function restore_database () {
	RESULT=`mysqlshow -v --user=$1 --password=$2 $3| grep -v Wildcard | grep -o $3`
	if [ "$RESULT" != $3 ]; then
		return 1
	fi
	
	if [ ! -f $4 ]; then
		return 1
	fi
}
