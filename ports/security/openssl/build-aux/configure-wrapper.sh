#!/bin/sh

./config --openssldir=/tmp/iOSPorts/ \
   no-threads no-shared no-asm no-zlib no-dso no-krb5  \
   $@ || exit $?

