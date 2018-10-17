#!/bin/bash

SETTING=`plutil -key pgsql_Enabled /var/mobile/Library/Preferences/pgsql.plist`
echo "SETTING=$SETTING" > /var/log/stop_pgsql.log
if [ $SETTING -eq 0 ]; then
          echo "Done" >> /var/log/stop_pgsql.log
         /usr/local/libexec/pgsql-server stop
fi

