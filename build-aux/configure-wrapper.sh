#!/bin/sh

. `dirname $0`/iOS-buildenv.sh

./configure --host=arm-apple-darwin10 \
   PATH=${PATH} CC=${CC} LDFLAGS=${LDFLAGS} CPPFLAGS=${CPPFLAGS} $@

exit $?
