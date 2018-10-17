echo
echo "This is a lazy script"
echo " Meaning, I'm trusting that you have stuff installed right."
echo "  Hit CRTL-C if you fail to the do above."
echo

echo "Do you have clang from Coolstar's repo?"
clang -v &> /dev/null || exit $?
sleep 5
# I'm a lazy bastard and I doing this for you.
# TBH this would have better checks if I was not lazy.
echo "I hope you got everything right."
echo
echo "Check for gem..."
gem -v &> /dev/null || exit $?
echo "It would be weird if that failed..."
pushd /usr || cd /usr
rm -rf SDK
echo "extracting SDK"
tar xzvf /usr/SDK.tar.xz || exit $?
popd || cd $HOME
echo "nokogiri"
gem install nokogiri -- --use-system-libraries || exit $?
echo "pg"
gem install pg -v '0.20.0' -- --with-pg_config=/usr/local/pgsql/bin/pg_config || exit $?
echo "PCAPRUB, this is slient, don't worry."
gem install pcaprub -v '0.12.4' &> /dev/null
echo "DON'T EXIT; FIXING PCAPRUB"
sleep 5 # L U L  W A S  H E R E
	pushd /usr/local/lib/ruby/gems/2.5.0/gems/pcaprub-0.12.4/ext/pcaprub_c || cd /usr/local/lib/ruby/gems/2.5.0/gems/pcaprub-0.12.4/ext/pcaprub_c
	cp /usr/lib/libpcap.a ./
	ld -demangle -lto_library /usr/share/llvm/lib/libLTO.dylib -dynamic -arch arm64 -bundle -dynamic -iphoneos_version_min 5.0.0 -syslibroot /usr/SDK -o pcaprub_c.bundle -L. -L/usr/local/lib -L/opt/local/lib -L/usr/local/lib -L/usr/lib -L. -L/usr/SDK/usr/lib -L/usr/lib -L/usr/local/lib -L/lib pcaprub.o -multiply_defined suppress -lruby.2.5.1 -lpthread -ldl -lobjc -lSystem -lpcap
	rm ./libpcap.a
	echo "Make!"
	make "DESTDIR=" install || exit $?
	pushd /usr/local/lib/ruby/gems/2.5.0/gems/pcaprub-0.12.4/ || cd /usr/local/lib/ruby/gems/2.5.0/gems/pcaprub-0.12.4/
	gem spec ../../cache/pcaprub-0.12.4.gem --ruby > ../../specifications/pcaprub-0.12.4.gemspec
echo "####################################"
echo "Done."
echo "CD into /opt and into the metasploit framework directory."
echo "Run ./msfconsole to finish up the last part of the install."
echo "Lastly, run this: (You'll need ldid)"
echo "find /usr/local/lib/ruby/gems/2.5.0/gems -iname '*.bundle' -exec ldid -S {} \;"
echo "After you finish the bundle install."
echo "gem install rails"
which setupmsf.sh
echo " Remove me. You don't need me."
echo
