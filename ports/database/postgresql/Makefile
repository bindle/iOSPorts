#
#  iOS Ports Library
#  Copyright (C) 2013 Bindle Binaries
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
PACKAGE_NAME				= PostgreSQL
PACKAGE_TARNAME				= postgresql
PACKAGE_VERSION				= 9.2.4
PACKAGE_DIR				= $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)
PACKAGE_FILEEXE				= tar.bz2
PACKAGE_FILE				= $(PACKAGE_DIR).$(PACKAGE_FILEEXE)
PACKAGE_MD5				= $(PACKAGE_FILE).md5
PACKAGE_URL				= http://ftp.postgresql.org/pub/source/v9.2.4/$(PACKAGE_FILE)
PACKAGE_WEBSITE				= http://www.postgresql.org/
PACKAGE_LICENSE_FILE			= build-aux/COPYRIGHT


SRCROOTDIR = ../../..
INCLUDEDIR = $(SRCROOTDIR)/include
include $(SRCROOTDIR)/build-aux/Makefile-package


INCLUDES				= $(INCLUDEDIR)/libpq-fe.h \
					  $(INCLUDEDIR)/postgres_ext.h


CUSTFILES				= postgresql/src/include/pg_config.h \
					  postgresql/src/include/pg_config_os.h \
					  postgresql/src/include/utils/probes.h \
					  postgresql/src/port/pg_config_paths.h


$(CUSTFILES): $(PACKAGE_TARNAME)
	cp build-aux/${@} ${@}


$(INCLUDEDIR)/libpq-fe.h: postgresql/src/interfaces/libpq/libpq-fe.h
	@mkdir -p $(INCLUDEDIR)
	cp postgresql/src/interfaces/libpq/libpq-fe.h $(@)


$(INCLUDEDIR)/postgres_ext.h: postgresql/src/include/postgres_ext.h
	@mkdir -p $(INCLUDEDIR)
	cp postgresql/src/include/postgres_ext.h $(@)


extra-prep: $(CUSTFILES) $(INCLUDES)


clean-local:
	/bin/rm -Rf $(INCLUDES)


distclean-local:


# end of Makefile
