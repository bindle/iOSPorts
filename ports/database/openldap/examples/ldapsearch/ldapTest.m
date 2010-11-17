/*
 *  ldap.m
 *  ldapsearch
 *
 *  Created by David Syzdek on 11/2/10.
 *  Copyright 2010 David M. Syzdek. All rights reserved.
 *
 */

#include "ldapTest.h"
#include <stdlib.h>
#include <string.h>

void test_all_ldap()
{
   test_simple_ldap(
      LDAP_VERSION3,          // LDAP protocol version
      "ldap://10.0.1.3",      // LDAP URI
      "cn=Directory Manager", // LDAP bind DN
      "drowssap",             // LDAP bind password
      "o=test",               // LDAP search base DN
      "(objectclass=*)",      // LDAP search filter
      LDAP_SCOPE_SUB          // LDAP search scope
   );

   return;
}

void test_simple_ldap(int version, const char * ldapURI, const char * bindDN,
   const char * bindPW, const char * baseDN, const char * filter, int scope)
{
   int              i;
   int              err;
   char           * attribute;
   LDAP           * ld;
   BerValue         cred;
   BerValue       * servercredp;
   BerElement     * ber;
   const char     * dn;
   LDAPMessage    * res;
   LDAPMessage    * entry;
   struct berval ** vals;

   vals            = NULL;
   servercredp     = NULL;
   dn              = "cn=Directory Manager";

   NSLog(@"initialzing LDAP...");
   ldapURI = ldapURI ? ldapURI : "ldap://127.0.0.1";
   err = ldap_initialize(&ld, ldapURI);
   if (err != LDAP_SUCCESS)
   {
      printf("ldap_initialize(): %s\n", ldap_err2string(err));
      return;
   };

   if (version)
   {
      NSLog(@"setting protocol version %i...", version);
      err = ldap_set_option(ld, LDAP_OPT_PROTOCOL_VERSION, &version);
      if (err != LDAP_SUCCESS)
      {
         printf("ldap_set_option(): %s\n", ldap_err2string(err));
         ldap_unbind_ext_s(ld, NULL, NULL);
         return;
      };
   };

   NSLog(@"binding to LDAP server...");
   cred.bv_val = bindPW ? bindPW : NULL;
   cred.bv_len = bindPW ? (size_t) strlen("drowssap") : 0;
   err = ldap_sasl_bind_s(ld, bindDN, LDAP_SASL_SIMPLE, &cred, NULL, NULL, &servercredp);
   if (err != LDAP_SUCCESS)
   {
      NSLog(@"ldap_sasl_bind_s(): %s", ldap_err2string(err));
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };

   NSLog(@"initiating lookup...");
   if ((err = ldap_search_ext_s(ld, baseDN, scope, filter, NULL, 0, NULL, NULL, NULL, -1, &res)))
   {
      NSLog(@"ldap_search_ext_s(): %s", ldap_err2string(err));
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };

   NSLog(@"checking for results...");
   if (!(ldap_count_entries(ld, res)))
   {
      NSLog(@"no entries found.");
      ldap_msgfree(res);
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };
   NSLog(@"%i entries found.", ldap_count_entries(ld, res));

   NSLog(@"retrieving results...");
   if (!(entry = ldap_first_entry(ld, res)))
   {
      NSLog(@"ldap_first_entry(): %s", ldap_err2string(err));
      ldap_msgfree(res);
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };

   while(entry)
   {
      NSLog(@" ");
      NSLog(@"   dn: %s", ldap_get_dn(ld, entry));

      attribute = ldap_first_attribute(ld, entry, &ber);
      while(attribute)
      {
         if ((vals = ldap_get_values_len(ld, entry, attribute)))
         {
            for(i = 0; vals[i]; i++)
               NSLog(@"   %s: %s", attribute, vals[i]->bv_val);
            ldap_value_free_len(vals);
         };
         ldap_memfree(attribute);
         attribute = ldap_next_attribute(ld, entry, ber);
      };

      // skip to the next entry
      entry = ldap_next_entry(ld, entry);
   };
   NSLog(@" ");

   NSLog(@"unbinding from LDAP server...");
   ldap_unbind_ext_s(ld, NULL, NULL);
	
	return;


}

