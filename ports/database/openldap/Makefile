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
#  Makefile -- automate downloading OpenLDAP
#

# Package Information
PACKAGE_NAME				= OpenLDAP
PACKAGE_TARNAME				= openldap
PACKAGE_VERSION				= 2.4.33
PACKAGE_DIR				= $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)
PACKAGE_FILEEXE				= tgz
PACKAGE_FILE				= $(PACKAGE_DIR).$(PACKAGE_FILEEXE)
PACKAGE_MD5				= $(PACKAGE_FILE).md5
PACKAGE_URL				= ftp://ftp.OpenLDAP.org/pub/OpenLDAP/openldap-release/$(PACKAGE_FILE)
PACKAGE_WEBSITE				= http://www.openldap.org/
PACKAGE_LICENSE_FILE			= build-aux/LICENSE

SRCROOTDIR = ../../..
include $(SRCROOTDIR)/build-aux/Makefile-package

INCLUDES = ../../../include/ldap.h \
           ../../../include/ldap_cdefs.h \
           ../../../include/ldap_features.h \
           ../../../include/ldap_schema.h \
           ../../../include/ldap_utf8.h \
           ../../../include/lber.h \
           ../../../include/lber_types.h

CUSTFILES	= openldap/include/lber_types.h \
		  openldap/include/ldap_config.h \
		  openldap/include/ldap_features.h \
		  openldap/include/portable.h \
		  openldap/libraries/liblber/version.c \
		  openldap/libraries/libldap/version.c \
		  openldap/libraries/libldap_r/version.c \
		  openldap/libraries/liblunicode/version.c \
		  openldap/libraries/liblutil/version.c \
		  openldap/libraries/librewrite/version.c

$(CUSTFILES): $(PACKAGE_TARNAME)
	cp build-aux/${@} ${@}

$(INCLUDES): $(CUSTFILES)
	@mkdir -p ../../../include
	cp openldap/include/`basename ${@}` ../../../include/

extra-prep: $(INCLUDES)

clean-local:
	/bin/rm -Rf $(INCLUDES)

distclean-local:

# end of Makefile
