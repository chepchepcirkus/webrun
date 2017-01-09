#!/bin/awk -f
BEGIN{}
{
    if( $1 ~ /#@title-/) {
        nTime=substr($1,9)
        for(c=0;c<nTime;c++) printf "#"
        printf substr($0,10) " "
        for(c=0;c<nTime;c++) printf "#"
        print ""
    }
}
{ 
    if( $1 == "#@intro") {
        print substr($0,9);
    }
}
{ 
    if( $1 == "#@name") {
        print "#### " $2 " ####";
    }
}
{
    if(lock == "desc" && $1 != "#@desc") {
		lock="desc";
		print "> "substr($0,2);
    }

	if($1 == "#@desc" && lock == "desc") {
		lock="";
		print ""
	}
	else if($1 == "#@desc" && lock == "") {
		lock="desc";
	}
}
{
    if($1 == "#@args") {
        print "| Arguments | Description / Example |"
        print "| --------- | --------------------- |"
        arg=""
        for (i=2; i<=NF; i++) {
            if( $i == "|")
            {
                if( substr(arg,0,2) != "|") {
                  arg="| "arg
                }
                print arg"| "
                arg="| "
            }
            else if($i == ":")
            {
                arg=arg" | "
            }
            else
            {
                arg=arg" "$i
            }
        }
        
        if(arg) {
            print arg"| "
        }
        arg=""
    }
}
{
    if(lock == "example" && $1 != "#@example") {
		lock="example";
		print "> "substr($0,2);
    }

	if($1 == "#@example" && lock == "example") {
		lock="";
		print ""
	}
	else if($1 == "#@example" && lock == "") {
		lock="example";
		print "Example : "
	}
}
END{}