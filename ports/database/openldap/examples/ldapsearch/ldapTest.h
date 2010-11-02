/*
 *  ldap.h
 *  ldapsearch
 *
 *  Created by David Syzdek on 11/2/10.
 *  Copyright 2010 David M. Syzdek. All rights reserved.
 *
 */
#include <ldap.h>

void test_ldap(int version, const char * ldapURI, const char * bindDN,
   const char * bindPW, const char * baseDN, const char * filter, int scope);