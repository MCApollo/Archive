#!/bin/bash

##################################################
# *** Run this first, THEN derv.sh ***
##################################################
#
# this script starts pirni with basic settings
# - finds gatway (router) using netstat
#
# - accepts ip address as argument (TARGET) [optional]
#   \- if no argument (IP) is given, 
#       pirni will target entire network
#
# - tells pirni the output file and filter [tcp dst port 80]
#
##################################################
# This program is to be used with with derv.sh   #
# which filters the packets accordingly.         #
##################################################

# root check
if [ "$UID" != 0 ]; then
  echo "You must be logged in as root to use this script."
  echo "Type \'su\' to log in as root."
  exit
fi

# output file naming, also used by other .sh files 
file="log.pcap" # needs to be the same as in derv.sh

# get gateway via netstat
gway=$(netstat -rn|grep default|grep en0|awk '{print $2}')

# filter everything except tcp packets bound for port 80
fil="tcp dst port 80"

# filter for instant messages... NOT WORKING! >;O
# fil="(tcp dst port 80) or (tcp dst port 5190) or (tcp dst port 5050)"
#              WWW                     AIM               YAHOO             ...MSN?

# if there's an ip address in the argument, that's our target ($TAR)
if [[ "$1" == '' ]]; then
  tar=""
else
  tar="-d "$1" "
fi

# start pirni

pirni -s ${gway} ${tar}-f "${fil}" -o $file

exit 0