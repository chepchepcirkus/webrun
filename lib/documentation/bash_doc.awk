{ 
    if( $1 == "#@main") {
        print "# " $2 " #"; print "\r"
    }
}
{ 
    if( $1 == "#@intro") {
        print substr($0,9); print "\r"
    }
}
{ 
    if( $1 == "#@name") {
        print "## " $2 " ##"; print "\r"
    }
}
{
    if($1 == "#@description") {
        print "> "substr($0,15); print "\r"
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
        print "\r\nExample:\r\n"
        print " >"substr($0,10)
    }
}
