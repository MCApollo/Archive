#!/bin/bash

SETTING=`plutil -key pgsql_Enabled /var/mobile/Library/Preferences/pgsql.plist`
echo "SETTING=$SETTING" > /var/log/start_pgsql.log
if [ $SETTING -eq 1 ]; then
        echo "Done" >> /var/log/start_pgsql.log
        su - postgres -s /bin/sh -c "/usr/local/libexec/pgsql-server start"
fi

