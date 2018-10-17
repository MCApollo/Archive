###########################################################################
##  Copyright (C) Wizardry and Steamworks 2013 - License: GNU GPLv3      ##
##  Please see: http://www.gnu.org/licenses/gpl.html for legal details,  ##
##  rights of fair usage, the disclaimer and warranty conditions.        ##
###########################################################################


# MCApollo's compiled, WASs launchdaemon and Settings Panel:
# Changes: This runs as root, so drop privs when running commands. 'su mobile' is kinda pointless, writing this now.
# Changes: Edit names to avoid conflict with the BigBoss Package.
# com.mc.tor.plist is chmod 600 and owned by mobile, can't be read as nobody.

STATUS=`ps -ax | grep '[t]or' | grep 'hush' | awk '{ print $1 }'`
SETTING=$(su mobile -s /bin/sh -c "plutil -key torEnabled /private/var/mobile/Library/Preferences/com.mc.tor.plist")

if [ $SETTING -eq 0 ]; then
  kill -s TERM $STATUS
else
   cd /tmp # remember that nobody REALLY has no perms or write access without giving it to him.
   su nobody -s /bin/sh -c "/usr/local/bin/tor --defaults-torrc --hush"
fi
