#!/bin/sh

PATH=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin:${PATH} \

BASEDIR=$(cd ../../../../; pwd)
LDIR="${BASEDIR}/lib"
IDIR="${BASEDIR}/include"

./configure --host=arm-apple-darwin10 \
   CC="/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/llvm-gcc-4.2" \
   CFLAGS="-arch armv7 -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.1.sdk -I${IDIR}" \
   LDFLAGS="-L${LDIR} -lssl -lcrypto -lsasl2" \
   --prefix=/tmp/iOSPorts --enable-static --disable-shared --disable-syslog \
   --disable-proctitle --disable-local --disable-slapd --with-yielding-select \
   --without-threads \
   $@ || exit $?

