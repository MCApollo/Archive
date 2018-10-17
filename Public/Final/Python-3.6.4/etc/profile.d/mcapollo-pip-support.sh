#!/bin/bash

# Needed a way to set enviroment variables for pip.
# Due to sandbox, we and dlopen can't use /private/var/tmp
# so this is a dirty way to change it.

# If you don't know why the hell this here, read the description of the Python 3 package

# Check for pip3
if [ -f /usr/local/bin/pip3 ] ; then
	# Set TMPDIR for pip
	export TMPDIR=/usr/tmp
	if [ ! -f $HOME/.mcapollo-pip-support ] ; then
		# Set Colors
		SCRIPTBLUE='\033[0;34m'
		SCRIPTNC='\033[0m'
		SCRIPTGRAY='\033[0;37m'
		SCRIPTCYAN='\033[1;36m'
		SCRIPTLIGHTRED='\033[1;31m'
		SCRIPTYELLOW='\033[1;33m'
		# End Colors

		# Talk to User
		echo
		echo -e "/etc/profile.d/mcapollo-pip-support.sh: ${SCRIPTCYAN}Congrats on installing pip3!${SCRIPTNC}"
		echo -e "  Run '${SCRIPTGRAY}bash /usr/local/lib/python3.6/install_certificates.command${SCRIPTNC}' to install ssl-certs."
		echo
		echo -e "  You need ${SCRIPTLIGHTRED}LLVM+Clang (64 Bit)${SCRIPTNC} and ${SCRIPTLIGHTRED}LD64${SCRIPTNC} to be able to use pip fully."
		echo -e "  Also, ${SCRIPTLIGHTREDRED}You need a iOS SDK.${SCRIPTNC} Rename the iPhoneOS--SDK to 'SDK' and put it in ${SCRIPTYELLOW}/usr/${SCRIPTNC}. \n  ${SCRIPTLIGHTRED}You should end up with /usr/SDK/usr.${SCRIPTNC}"
		echo -e "  Then, you need to symlink system libraries: '${SCRIPTGRAY}ln -s /usr/SDK/usr/lib/lib* /usr/lib/${SCRIPTNC}'"
		echo
		# End

		# Make a new hidden file.
		touch $HOME/.mcapollo-pip-support
		# End
	fi
	# You can set these if you need.
	# export CFLAGS=
	# export LDFLAGS=
 fi
