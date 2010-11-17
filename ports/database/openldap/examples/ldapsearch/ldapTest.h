/*
 *  ldap.h
 *  ldapsearch
 *
 *  Created by David Syzdek on 11/2/10.
 *  Copyright 2010 David M. Syzdek. All rights reserved.
 *
 */
#include <ldap.h>

typedef struct my_ldap_auth MyLDAPAuth;
struct my_ldap_auth
{
   char * mech;
   char * authuser;
   char * user;
   char * realm;
   char * passwd;
};

void test_all_ldap(void);

void test_simple_ldap(int version, const char * ldapURI, const char * bindDN,
   const char * bindPW, const char * baseDN, const char * filter, int scope);

void test_sasl_ldap(int version, const char * ldapURI, const char * user,
   const char * realm, const char * pass, const char * mech,
   const char * baseDN, const char * filter, int scope);

int my_ldap_sasl_interact_proc(LDAP *ld, unsigned flags, void *defaults,
   void *sasl_interact);
