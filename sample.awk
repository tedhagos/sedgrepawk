BEGIN { FS=","; print "Hello sample"}
# This is a comment

/produce/ {print}
/grocery/ {print $2}

END {print "TOTAL RECORDS : " NR}
