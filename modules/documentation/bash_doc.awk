{ 
    if( $1 == "#@main") {
        print "# " substr($0,7) " #";
    }
}
{ 
    if( $1 == "#@title") {
        print "## " substr($0,8)  " ##";
    }
}
{ 
    if( $1 == "#@sub-title") {
        print "### " substr($0,12)  " ###";
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
	}
	else if($1 == "#@desc" && lock == "") {
		lock="desc";
	}
}
{
    if($1 == "#@args") {
        print "| Arguments | Description / Example |"
        print "| --------- | --------------------- |"

        for (i=NF; i>1; i--) {
            if( $i == "|")
            {
                print "| "arg
                arg="| "
            }
            else if($i == ":")
            {
                arg=" | "arg
            }
            else
            {
                arg=$i" "arg
            }
        }
        
        if(arg) {
            print "| "arg
        }
        arg=""
    }
}
{
    if( $1 == "#@example" ) {
        print "Example:"
        print " >"substr($0,10)
    }
}
