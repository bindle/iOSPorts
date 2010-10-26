#!/bin/sh

PATH=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin:${PATH}

./configure --host=arm-apple-darwin10 \
   CC=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/arm-apple-darwin10-gcc-4.2.1 \
   LD=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/ld \
   LIBTOOL=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/libtool  \
   LDFLAGS=-L/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.1.sdk/usr/lib \
   CPPFLAGS=-I/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.1.sdk/usr/include \
   --prefix=/tmp/iosports --enable-static --disable-shared \
   $@ || exit $?

