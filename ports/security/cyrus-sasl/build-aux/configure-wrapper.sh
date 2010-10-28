#!/bin/sh

PATH=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin:${PATH}

./configure --host=arm-apple-darwin10 \
   CC="/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/llvm-gcc-4.2" \
   CFLAGS="-arch armv6 -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.1.sdk" \
   --prefix=/tmp/iosports --enable-static --disable-shared \
   --with-openssl=../../../../ --disable-java --disable-gssapi \
   $@ || exit $?


gcc -o include/makemd5 include/makemd5.c || exit $?
