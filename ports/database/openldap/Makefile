#
#  iPhone OS OpenLDAP Library
#  Copyright (C) 2010 Bindle Binaries
#
#  @BINDLE_BINARIES_LICENSE_START@
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110 USA
#
#  @BINDLE_BINARIES_LICENSE_END@
#
#  Makefile -- automate downloading OpenLDAP
#

# OpenLDAP Information
OPENLDAP_VERSION			= 2.4.22
OPENLDAP_DIR				= openldap-$(OPENLDAP_VERSION)
OPENLDAP_FILE				= $(OPENLDAP_DIR).tgz
OPENLDAP_MD5				= $(OPENLDAP_FILE).md5
OPENLDAP_URL				= ftp://ftp.OpenLDAP.org/pub/OpenLDAP/openldap-release/$(OPENLDAP_FILE)


# common targets
all: openldap

clean:
	/bin/rm -f  $(OPENLDAP_MD5)
	/bin/rm -fR $(OPENLDAP_DIR)
	/bin/rm -fR openldap


# openldap download targets
openldap: $(OPENLDAP_DIR)
	@/bin/rm -Rf openldap
	/bin/ln -s $(OPENLDAP_DIR) openldap
	@/usr/bin/touch openldap

$(OPENLDAP_DIR): $(OPENLDAP_MD5)
	@/bin/rm -Rf $(OPENLDAP_DIR)
	/usr/bin/tar -xzf $(OPENLDAP_FILE)
	@/usr/bin/touch $(OPENLDAP_DIR)

$(OPENLDAP_MD5): Makefile $(OPENLDAP_FILE)
	/sbin/md5 $(OPENLDAP_FILE) > $(OPENLDAP_MD5)
	/usr/bin/diff $(OPENLDAP_MD5) build-aux/$(OPENLDAP_FILE).md5 > /dev/null \
		|| { /bin/rm -f $(OPENLDAP_MD5); exit 1; };
	@/usr/bin/touch $(OPENLDAP_MD5)

$(OPENLDAP_FILE):
	/usr/bin/curl -O ${OPENLDAP_URL} -o $(OPENLDAP_FILE) -s
	@/usr/bin/touch $(OPENLDAP_FILE)

# end of Makefile
