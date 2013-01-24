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
PACKAGE_NAME				= Cyrus SASL
PACKAGE_TARNAME				= cyrus-sasl
PACKAGE_VERSION				= 2.1.25
PACKAGE_DIR				= $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)
PACKAGE_FILEEXE				= tar.gz
PACKAGE_FILE				= $(PACKAGE_DIR).$(PACKAGE_FILEEXE)
PACKAGE_MD5				= $(PACKAGE_FILE).md5
PACKAGE_URL				= http://ftp.andrew.cmu.edu/pub/cyrus-mail/$(PACKAGE_FILE)
PACKAGE_WEBSITE				= http://asg.web.cmu.edu/sasl/
PACKAGE_LICENSE_FILE			= build-aux/COPYING

SRCROOTDIR = ../../..
include $(SRCROOTDIR)/build-aux/Makefile-package

HEADERPREFIX    = ../../../include/sasl
HEADERTIMESTAMP = $(HEADERPREFIX)/.timestamp
INSTALLHEADERS	= $(HEADERPREFIX)/hmac-md5.h \
		  $(HEADERPREFIX)/md5.h \
		  $(HEADERPREFIX)/md5global.h \
		  $(HEADERPREFIX)/sasl.h \
		  $(HEADERPREFIX)/saslplug.h \
		  $(HEADERPREFIX)/saslutil.h \
		  $(HEADERPREFIX)/prop.h

$(HEADERTIMESTAMP): $(PACKAGE_TARNAME)
	mkdir -p `dirname ${@}`
	touch ${@}

$(HEADERPREFIX)/hmac-md5.h: $(HEADERTIMESTAMP)
	cp cyrus-sasl/include/hmac-md5.h ${@};

$(HEADERPREFIX)/md5.h: $(HEADERTIMESTAMP)
	cp cyrus-sasl/include/md5.h ${@};

$(HEADERPREFIX)/md5global.h: $(HEADERTIMESTAMP)
	cp cyrus-sasl/include/md5global.h ${@};

$(HEADERPREFIX)/sasl.h: $(HEADERTIMESTAMP)
	cp cyrus-sasl/include/sasl.h ${@};

$(HEADERPREFIX)/saslplug.h: $(HEADERTIMESTAMP)
	cp cyrus-sasl/include/saslplug.h ${@};

$(HEADERPREFIX)/saslutil.h: $(HEADERTIMESTAMP)
	cp cyrus-sasl/include/saslutil.h ${@};

$(HEADERPREFIX)/prop.h: $(HEADERTIMESTAMP)
	cp cyrus-sasl/include/prop.h ${@};

cyrus-sasl/config.h: $(PACKAGE_TARNAME)
	cp build-aux/config.h cyrus-sasl/

extra-prep: cyrus-sasl/config.h $(INSTALLHEADERS)

clean-local:
	/bin/rm -Rf ../../../include/sasl

distclean-local:
	/bin/rm -Rf build

# end of Makefile
