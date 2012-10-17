#
#  iOS Ports Library
#  Copyright (C) 2011 Bindle Binaries
#  All rights reserved.
#
#  @BINDLE_BINARIES_BSD_LICENSE_START@
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are
#  met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Bindle Binaries nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
#  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
#  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BINDLE BINARIES BE LIABLE FOR
#  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
#  SUCH DAMAGE.
#
#  @BINDLE_BINARIES_BSD_LICENSE_END@
#

PACKAGE_VERSION = $(shell git describe --long --abbrev=7 HEAD |sed -e 's/^v//g' -e 's/-/./g')

SOURCES		= \
		  ports/database/openldap/pkgdata_openldap.m \
		  ports/devel/pcre/pkgdata_pcre.m \
		  ports/security/cyrus-sasl/pkgdata_cyrus-sasl.m \
		  ports/security/openssl/pkgdata_openssl.m \
		  ports/security/scrypt/pkgdata_scrypt.m \
		  ports/iOSPorts/pkgdata_iosports.m

DEPS		= \
		  ports/iOSPorts/iOSPorts/iOSPortsPackageData.h \
		  ports/iOSPorts/iOSPorts/iOSPortsPackageList.h

PKGINFOSOURCES	= \
		  ports/iOSPorts/other/iOSPorts-pkginfo.m \
		  ports/iOSPorts/iOSPorts/iOSPortsPackage.m \
		  ports/iOSPorts/iOSPorts/iOSPortsPackageData.m

PROGS		= \
		  build-aux/iOSPorts-geninfo \
		  build-aux/iOSPorts-genlist \
		  build-aux/iOSPorts-pkginfo

INCLUDES	= \
		  include/iOSPorts/iOSPorts.h \
		  include/iOSPorts/iOSPortsPackage.h \
		  include/iOSPorts/iOSPortsViewController.h

CFLAGS		= -W -Wall -Werror -Iinclude -framework Foundation -DPACKAGE_VERSION=\"$(PACKAGE_VERSION)\"
CC		= /usr/bin/cc

all: $(PROGS)

prog: $(PROGS)

include/iOSPorts:
	@mkdir -p ${@}

include/iOSPorts/iOSPorts.h: include/iOSPorts ports/iOSPorts/iOSPorts/iOSPorts.h
	cp ports/iOSPorts/iOSPorts/iOSPorts.h ${@};

include/iOSPorts/iOSPortsPackage.h: include/iOSPorts ports/iOSPorts/iOSPorts/iOSPortsPackage.h
	cp ports/iOSPorts/iOSPorts/iOSPortsPackage.h ${@};

include/iOSPorts/iOSPortsViewController.h: include/iOSPorts ports/iOSPorts/iOSPorts/iOSPortsViewController.h
	cp ports/iOSPorts/iOSPorts/iOSPortsViewController.h ${@};

$(SOURCES): build-aux/iOSPorts-geninfo build-aux/Makefile-package $(INCLUDES)
	$(MAKE) -C "`dirname ${@}`" license

ports/iOSPorts/iOSPorts/iOSPortsPackageData.h: $(SOURCES)
	@rm -f ${@}
	cat $(SOURCES) > ${@} || { rm -f ${@}; exit 1; }

ports/iOSPorts/iOSPorts/iOSPortsPackageList.h: build-aux/iOSPorts-genlist $(SOURCES)
	build-aux/iOSPorts-genlist -f -o ${@} $(SOURCES)

build-aux/iOSPorts-geninfo: ports/iOSPorts/other/iOSPorts-geninfo.m $(INCLUDES)
	$(CC) $(CFLAGS) -o ${@} ports/iOSPorts/other/iOSPorts-geninfo.m

build-aux/iOSPorts-genlist: ports/iOSPorts/other/iOSPorts-genlist.m $(INCLUDES)
	$(CC) $(CFLAGS) -o ${@} ports/iOSPorts/other/iOSPorts-genlist.m

build-aux/iOSPorts-pkginfo: $(PKGINFOSOURCES) $(INCLUDES) $(DEPS)
	$(CC) $(CFLAGS) -o ${@} $(PKGINFOSOURCES)

distclean: clean
	for PKG in $(SOURCES);do \
           PKGDIR="`dirname $${PKG}`"; \
	   echo "cleaning $${PKGDIR}..."; \
	   $(MAKE) -C $${PKGDIR} distclean; \
	   rm -Rf $${PKGDIR}/build; \
	done

clean:
	rm -Rf $(PROGS) $(SOURCES) $(DEPS)
	rm -Rf include/iOSPorts
	rm -Rf ports/iOSPorts/other/iOSPorts-data.c
	rm -Rf build/
	rm -Rf a.out *.o src/*.o ports/iOSPorts/other/*.o

