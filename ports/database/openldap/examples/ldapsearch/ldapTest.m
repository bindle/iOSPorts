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
#include <sasl/sasl.h>

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

   test_sasl_ldap(
      LDAP_VERSION3,          // LDAP Protocol Version
      "ldap://10.0.1.3",      // LDAP URI
      "syzdek",               // SASL User
      NULL,                   // SASL Realm
      "drowssap",             // SASL password
      "DIGEST-MD5",           // SASL mechanism
      "o=test",               // LDAP Search Base DN
      "(objectclass=*)",      // LDAP Search Filter
      LDAP_SCOPE_SUB          // LDAP Search Scope
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

   NSLog(@"attempting simple bind:");
   NSLog(@"   initialzing LDAP...");
   ldapURI = ldapURI ? ldapURI : "ldap://127.0.0.1";
   err = ldap_initialize(&ld, ldapURI);
   if (err != LDAP_SUCCESS)
   {
      NSLog(@"   ldap_initialize(): %s\n", ldap_err2string(err));
      return;
   };

   if (version)
   {
      NSLog(@"   setting protocol version %i...", version);
      err = ldap_set_option(ld, LDAP_OPT_PROTOCOL_VERSION, &version);
      if (err != LDAP_SUCCESS)
      {
         NSLog(@"   ldap_set_option(): %s\n", ldap_err2string(err));
         ldap_unbind_ext_s(ld, NULL, NULL);
         return;
      };
   };

   NSLog(@"   binding to LDAP server...");
   cred.bv_val = bindPW ? strdup(bindPW) : NULL;
   cred.bv_len = bindPW ? (size_t) strlen("drowssap") : 0;
   err = ldap_sasl_bind_s(ld, bindDN, LDAP_SASL_SIMPLE, &cred, NULL, NULL, &servercredp);
   if (err != LDAP_SUCCESS)
   {
      NSLog(@"   ldap_sasl_bind_s(): %s", ldap_err2string(err));
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };

   NSLog(@"   initiating lookup...");
   if ((err = ldap_search_ext_s(ld, baseDN, scope, filter, NULL, 0, NULL, NULL, NULL, -1, &res)))
   {
      NSLog(@"   ldap_search_ext_s(): %s", ldap_err2string(err));
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };

   NSLog(@"   checking for results...");
   if (!(ldap_count_entries(ld, res)))
   {
      NSLog(@"   no entries found.");
      ldap_msgfree(res);
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };
   NSLog(@"   %i entries found.", ldap_count_entries(ld, res));

   NSLog(@"   retrieving results...");
   if (!(entry = ldap_first_entry(ld, res)))
   {
      NSLog(@"   ldap_first_entry(): %s", ldap_err2string(err));
      ldap_msgfree(res);
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };

   while(entry)
   {
      NSLog(@" ");
      NSLog(@"      dn: %s", ldap_get_dn(ld, entry));

      attribute = ldap_first_attribute(ld, entry, &ber);
      while(attribute)
      {
         if ((vals = ldap_get_values_len(ld, entry, attribute)))
         {
            for(i = 0; vals[i]; i++)
               NSLog(@"      %s: %s", attribute, vals[i]->bv_val);
            ldap_value_free_len(vals);
         };
         ldap_memfree(attribute);
         attribute = ldap_next_attribute(ld, entry, ber);
      };

      // skip to the next entry
      entry = ldap_next_entry(ld, entry);
   };
   NSLog(@" ");

   NSLog(@"   unbinding from LDAP server...");
   ldap_unbind_ext_s(ld, NULL, NULL);
	
	return;
}


void test_sasl_ldap(int version, const char * ldapURI, const char * user,
   const char * realm, const char * pass, const char * mech,
   const char * baseDN, const char * filter, int scope)
{
   int              i;
   int              err;
   char           * attribute;
   LDAP           * ld;
   BerValue       * servercredp;
   BerElement     * ber;
   const char     * dn;
   LDAPMessage    * res;
   LDAPMessage    * entry;
   struct berval ** vals;
   MyLDAPAuth       auth;

   vals            = NULL;
   servercredp     = NULL;
   dn              = "cn=Directory Manager";

   NSLog(@"attempting SASL bind:");
   NSLog(@"   initialzing LDAP...");
   ldapURI = ldapURI ? ldapURI : "ldap://127.0.0.1";
   err = ldap_initialize(&ld, ldapURI);
   if (err != LDAP_SUCCESS)
   {
      NSLog(@"   ldap_initialize(): %s\n", ldap_err2string(err));
      return;
   };

   version = version ? version : LDAP_VERSION3;
   NSLog(@"   setting protocol version %i...", version);
   err = ldap_set_option(ld, LDAP_OPT_PROTOCOL_VERSION, &version);
   if (err != LDAP_SUCCESS)
   {
      NSLog(@"   ldap_set_option(): %s\n", ldap_err2string(err));
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };

   memset(&auth, 0, sizeof(MyLDAPAuth));
   auth.mech      = mech  ? strdup(mech)   : NULL;
   auth.authuser  = user  ? strdup(user)   : NULL;
   auth.realm     = realm ? strdup(realm)  : NULL;
   auth.passwd    = pass  ? strdup(pass)   : NULL;

   if (!(auth.mech))
      ldap_get_option(ld, LDAP_OPT_X_SASL_MECH,  &auth.mech);
   if (!(auth.authuser))
      ldap_get_option(ld, LDAP_OPT_X_SASL_AUTHCID, &auth.authuser);
   if (!(auth.realm))
      ldap_get_option(ld, LDAP_OPT_X_SASL_REALM, &auth.realm);
   ldap_get_option(ld, LDAP_OPT_X_SASL_AUTHZID, &auth.user);

NSLog(@"   Bind Data:");
NSLog(@"      Mech:      %s", auth.mech     ? auth.mech     : "(NULL)");
NSLog(@"      User:      %s", auth.user     ? auth.user     : "(NULL)");
NSLog(@"      Auth User: %s", auth.authuser ? auth.authuser : "(NULL)");
NSLog(@"      Realm:     %s", auth.realm    ? auth.realm    : "(NULL)");
NSLog(@"      Passwd:    %s", auth.passwd   ? auth.passwd   : "(NULL)");

   NSLog(@"   binding to LDAP server...");
   err = ldap_sasl_interactive_bind_s(ld, NULL, NULL,
              NULL, NULL,
              LDAP_SASL_QUIET, my_ldap_sasl_interact_proc,
              &auth);

   if (err != LDAP_SUCCESS)
   {
      NSLog(@"   ldap_sasl_bind_s(): %s", ldap_err2string(err));
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };

   NSLog(@"   initiating lookup...");
   if ((err = ldap_search_ext_s(ld, baseDN, scope, filter, NULL, 0, NULL, NULL, NULL, -1, &res)))
   {
      NSLog(@"   ldap_search_ext_s(): %s", ldap_err2string(err));
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };

   NSLog(@"   checking for results...");
   if (!(ldap_count_entries(ld, res)))
   {
      NSLog(@"   no entries found.");
      ldap_msgfree(res);
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };
   NSLog(@"   %i entries found.", ldap_count_entries(ld, res));

   NSLog(@"   retrieving results...");
   if (!(entry = ldap_first_entry(ld, res)))
   {
      NSLog(@"   ldap_first_entry(): %s", ldap_err2string(err));
      ldap_msgfree(res);
      ldap_unbind_ext_s(ld, NULL, NULL);
      return;
   };

   while(entry)
   {
      NSLog(@" ");
      NSLog(@"      dn: %s", ldap_get_dn(ld, entry));

      attribute = ldap_first_attribute(ld, entry, &ber);
      while(attribute)
      {
         if ((vals = ldap_get_values_len(ld, entry, attribute)))
         {
            for(i = 0; vals[i]; i++)
               NSLog(@"      %s: %s", attribute, vals[i]->bv_val);
            ldap_value_free_len(vals);
         };
         ldap_memfree(attribute);
         attribute = ldap_next_attribute(ld, entry, ber);
      };

      // skip to the next entry
      entry = ldap_next_entry(ld, entry);
   };
   NSLog(@" ");

   NSLog(@"   unbinding from LDAP server...");
   ldap_unbind_ext_s(ld, NULL, NULL);
	
	return;
}

int my_ldap_sasl_interact_proc(LDAP *ld, unsigned flags, void *defaults,
   void * sasl_interact)
{
	int               noecho;
	int               challenge;
   MyLDAPAuth      * defs = defaults;
   const char      * dflt;
	sasl_interact_t * interact = sasl_interact;

   if (!(ld))
      return(LDAP_PARAM_ERROR);

NSLog(@"      entering my_ldap_sasl_interact_proc()");
   while(interact->id != SASL_CB_LIST_END)
   {
      noecho    = 0;
      challenge = 0;
      dflt      = interact->defresult;
      interact->result = NULL;
      interact->len    = 0;
      switch( interact->id )
      {
         case SASL_CB_GETREALM:
            NSLog(@"         processing SASL_CB_GETREALM");
            interact->result = defs->realm ? defs->realm : "";
            interact->len    = strlen( interact->result );
            break;
         case SASL_CB_AUTHNAME:
            NSLog(@"         processing SASL_CB_AUTHNAME");
            interact->result = defs->authuser ? defs->authuser : "";
            interact->len    = strlen( interact->result );
            break;
         case SASL_CB_PASS:
            NSLog(@"         processing SASL_CB_PASS");
            interact->result = defs->passwd ? defs->passwd : "";
            interact->len    = strlen( interact->result );
            noecho = 1;
            break;
         case SASL_CB_USER:
            NSLog(@"         processing SASL_CB_USER");
            interact->result = defs->user ? defs->user : "";
            interact->len    = strlen( interact->result );
            break;
         case SASL_CB_NOECHOPROMPT:
            NSLog(@"         processing SASL_CB_NOECHOPROMPT");
            noecho = 1;
            challenge = 1;
            break;
         case SASL_CB_ECHOPROMPT:
            NSLog(@"         processing SASL_CB_ECHOPROMPT");
            challenge = 1;
            break;
         default:
            NSLog(@"         I don't know how to process this.");
            break;
      };
      interact++;
   };
   NSLog(@"      exiting my_ldap_sasl_interact_proc()");

   return(LDAP_SUCCESS);
};
