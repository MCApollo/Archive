#!/bin/bash
# Usage: sign_configure_file.sh path/to/configure
# Part of pip-support

grep "ldid \-S/usr/local/lib/python3.6/sign" $1 >> /dev/null && echo "pip-support: Already patched the configure script!" && exit 0

sed --in-place '/(eval "$ac_try")/i\
  eval "ldid -S/usr/local/lib/python3.6/sign ./conftest$ac_cv_exeext"' $1
