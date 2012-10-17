#
#  iOS Ports Library
#  Copyright (C) 2010 Bindle Binaries
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
#  Makefile -- automate downloading of package files
#

# Package Information
PACKAGE_NAME				= PCRE
PACKAGE_TARNAME				= pcre
PACKAGE_VERSION				= 8.31
PACKAGE_DIR				= $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)
PACKAGE_FILEEXE				= tar.bz2
PACKAGE_FILE				= $(PACKAGE_DIR).$(PACKAGE_FILEEXE)
PACKAGE_MD5				= $(PACKAGE_FILE).md5
PACKAGE_URL				= http://superb-sea2.dl.sourceforge.net/project/pcre/pcre/$(PACKAGE_VERSION)/$(PACKAGE_FILE)
PACKAGE_WEBSITE				= http://www.pcre.org/
PACKAGE_LICENSE_FILE			= build-aux/LICENCE

SRCROOTDIR = ../../..
include $(SRCROOTDIR)/build-aux/Makefile-package

PKGHEADERS = pcre/config.h

OTHERFILES = pcre/pcre_chartables.c pcre/pcre.h

INCLUDES = ../../../include/pcre.h

$(PKGHEADERS): $(PACKAGE_TARNAME)
	FILE="build-aux/`basename ${@}`"; cp $${FILE} ${@};

pcre/pcre.h: $(PACKAGE_TARNAME) pcre/pcre.h.generic
	cp pcre/pcre.h.generic pcre/pcre.h

../../../include/pcre.h: pcre/pcre.h
	mkdir -p ../../../include
	cp pcre/pcre.h ../../../include/pcre.h

pcre/pcre_chartables.c: $(PACKAGE_TARNAME) pcre/pcre_chartables.c.dist
	cp pcre/pcre_chartables.c.dist pcre/pcre_chartables.c

extra-prep: $(PKGHEADERS) $(OTHERFILES) $(INCLUDES)

clean-local:
	/bin/rm -Rf include
	/bin/rm -Rf $(INCLUDES)

distclean-local:
	/bin/rm -Rf build

# end of Makefile
