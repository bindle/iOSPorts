#!/bin/sh

PATH=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin:${PATH} \

#./configure --host=arm-apple-darwin10 \
#   CC=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/arm-apple-darwin10-gcc-4.2.1 \
#   LD=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/ld \
#   LIBTOOL=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/libtool  \
#   LDFLAGS="-L/tmp/iosports/lib -L/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.1.sdk/usr/lib" \
#   CPPFLAGS="-I/tmp/iosports/include -I/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.1.sdk/usr/include" \
#   --prefix=/tmp/iosports --enable-static --disable-shared \
#   --with-yielding-select --disable-slapd --with-cyrus-sasl \
#   --disable-digest $@ || exit $?

./configure --host=arm-apple-darwin10 \
   CC="/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/llvm-gcc-4.2" \
   CFLAGS="-arch armv6 -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.1.sdk" \
   CPPFLAGS=-I../../../../include LDFLAGS=-L../../../../lib \
   --prefix=/tmp/iOSPorts --enable-static --disable-shared \
   --with-yielding-select --disable-slapd \
   $@ || exit $?



