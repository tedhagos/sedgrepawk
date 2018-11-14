BEGIN { FS=","; print "Hello sample"}
# This is a comment

{
  print $1 "\t" $2 "\t" $3
  total = total + $3  
}

END {print "TOTAL " total}
