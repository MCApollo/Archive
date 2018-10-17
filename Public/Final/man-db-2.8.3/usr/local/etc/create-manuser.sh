#!/bin/bash
# Create the user man for mandb
# MCApollo - PM if I messed up.

echo -e "\n\033[1;37mMCApollo's \"Create the user man\" script.\033[0m \n Contact if something went wrong.\n"

if ! [ $(id -u) = 0 ]; then # Copy and pasted because I'm a lazy boy.
   echo "Needs to be run as root." # https://askubuntu.com/questions/15853/how-can-a-script-check-if-its-being-run-as-root
   exit 1
fi

FILES="/etc/master.passwd /etc/passwd /etc/group"

for i in $FILES ; do
# **Make sure we haven't done this.**
 if $(grep "mandb" $i &>/dev/null) ; then # The anti "fuck up" check.
	echo -e "\033[1;31m[Error]\033[0m $i already has been edited! Bailing out..."
 exit 1; fi
# ----------------------------------
	echo -e "\033[1;37mAppending to \033[0;37m$i \033[0m" && OUTPUT="$OUTPUT\n$i"

		if [ "$i" = "/etc/group" ] ; then # Special case for /etc/groups
			echo "man:*:600:man" >> $i && OUTPUT="$OUTPUT\n$i"
		break ; fi

	echo "man:*:600:600::0:0:mandb:/var/cache/man:/bin/false" >> $i # Create the user with id and group 600.
done # Note to self: "::0:0" in passwd causes man to have no name, so good job me. (Mission failed, we'll get em' next time.)

echo -e "\n \033[1;31mIf you remove manpages, make sure you remove the man user.\033[0m \n\nHey! Remember these files: \n$OUTPUT (they have been edited!) \n"

echo "Making directories..."
mkdir -p /var/cache/man/fsstnd
echo "Done."

echo -e "\nWould you like to run mandb?"
read -r -p "[y/N] --> " response # Another copy and paste, still a lazy boy.
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]] # https://stackoverflow.com/questions/3231804/in-bash-how-to-add-are-you-sure-y-n-to-any-command-or-alias
then
    mandb
fi
echo "Goodbye!"
