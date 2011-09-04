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
#include <Foundation/Foundation.h>

void test_all_ldap(const char * caFile)
{
   int err;
   unsigned u;
   const char * sasl_mechs[] = {"SMB-NTLMv2",
                                "SMB-NT",
                                "MS-CHAPv2",
                                "PPS",
                                "PLAIN",
                                "OTP",
                                "NTLM",
                                "LOGIN",
                                "GSSAPI",
                                "DIGEST-MD5",
                                "CRAM-MD5",
                                "WEBDAV-DIGEST",
                                "DHX",
                                "APOP",
                                NULL};

   if (caFile)
   {
      NSLog(@"setting ca file...");
      err = ldap_set_option(NULL, LDAP_OPT_X_TLS_CACERTFILE, (void *)caFile);
      if (err != LDAP_SUCCESS)
         NSLog(@"ldap_set_option(): %s", ldap_err2string(err));
   };

   test_simple_ldap(
      MY_LDAP_VERSION,        // LDAP protocol version
      MY_LDAP_URI,            // LDAP URI
      MY_LDAP_BINDDN,         // LDAP bind DN
      MY_LDAP_BINDPW,         // LDAP bind password
      MY_LDAP_BASEDN,         // LDAP search base DN
      MY_LDAP_FILTER,         // LDAP search filter
      MY_LDAP_SCOPE,          // LDAP search scope
      caFile
   );

   for(u = 0; sasl_mechs[u]; u++)
   {
      test_sasl_ldap(
         MY_LDAP_VERSION,        // LDAP Protocol Version
         MY_LDAP_URI,            // LDAP URI
         MY_SASL_AUTHUSER,       // SASL User
         MY_SASL_REALM,          // SASL Realm
         MY_SASL_PASSWD,         // SASL password
         sasl_mechs[u],          // SASL mechanism
         MY_LDAP_BASEDN,         // LDAP Search Base DN
         MY_LDAP_FILTER,         // LDAP Search Filter
         MY_LDAP_SCOPE,          // LDAP Search Scope
         caFile
      );
   };
/*
   test_sasl_ldap(
      MY_LDAP_VERSION,        // LDAP Protocol Version
      MY_LDAP_URI,            // LDAP URI
      MY_SASL_AUTHUSER,       // SASL User
      MY_SASL_REALM,          // SASL Realm
      MY_SASL_PASSWD,         // SASL password
      "OTP",                  // SASL mechanism
      MY_LDAP_BASEDN,         // LDAP Search Base DN
      MY_LDAP_FILTER,         // LDAP Search Filter
      MY_LDAP_SCOPE,          // LDAP Search Scope
      caFile
   );

   test_sasl_ldap(
      MY_LDAP_VERSION,        // LDAP Protocol Version
      MY_LDAP_URI,            // LDAP URI
      MY_SASL_AUTHUSER,       // SASL User
      MY_SASL_REALM,          // SASL Realm
      MY_SASL_PASSWD,         // SASL password
      "NTLM",                 // SASL mechanism
      MY_LDAP_BASEDN,         // LDAP Search Base DN
      MY_LDAP_FILTER,         // LDAP Search Filter
      MY_LDAP_SCOPE,          // LDAP Search Scope
      caFile
   );

   test_sasl_ldap(
      MY_LDAP_VERSION,        // LDAP Protocol Version
      MY_LDAP_URI,            // LDAP URI
      MY_SASL_AUTHUSER,       // SASL User
      MY_SASL_REALM,          // SASL Realm
      MY_SASL_PASSWD,         // SASL password
      "DIGEST-MD5",           // SASL mechanism
      MY_LDAP_BASEDN,         // LDAP Search Base DN
      MY_LDAP_FILTER,         // LDAP Search Filter
      MY_LDAP_SCOPE,          // LDAP Search Scope
      caFile
   );

   test_sasl_ldap(
      MY_LDAP_VERSION,        // LDAP Protocol Version
      MY_LDAP_URI,            // LDAP URI
      MY_SASL_AUTHUSER,       // SASL User
      MY_SASL_REALM,          // SASL Realm
      MY_SASL_PASSWD,         // SASL password
      "CRAM-MD5",             // SASL mechanism
      MY_LDAP_BASEDN,         // LDAP Search Base DN
      MY_LDAP_FILTER,         // LDAP Search Filter
      MY_LDAP_SCOPE,          // LDAP Search Scope
      caFile
   );
*/
   return;
}

void test_simple_ldap(int version, const char * ldapURI, const char * bindDN,
   const char * bindPW, const char * baseDN, const char * filter, int scope,
   const char * caFile)
{
   int              i;
   int              err;
   char           * msg;
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

   NSLog(@"attempting %s bind:", (caFile ? "TLS simple" : "simple"));
   ldapURI = ldapURI ? ldapURI : "ldap://127.0.0.1";
   NSLog(@"   initialzing LDAP (%s)...", ldapURI);
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

   if (caFile)
   {
     NSLog(@"   attempting to start TLS...");
      err = ldap_start_tls_s(ld, NULL, NULL);
      if (err == LDAP_SUCCESS)
      {
         NSLog(@"   TLS established");
      } else {
         ldap_get_option( ld, LDAP_OPT_DIAGNOSTIC_MESSAGE, (void*)&msg);
         NSLog(@"   ldap_start_tls_s(): %s", ldap_err2string(err));
         NSLog(@"   ssl/tls: %s", msg);
         ldap_memfree(msg);
      };
   };

   NSLog(@"   Bind Data:");
   NSLog(@"      Mech:    Simple");
   NSLog(@"      DN:      %s", bindDN ? bindDN : "(NULL)");
   NSLog(@"      Passwd:  %s", bindPW ? bindPW : "(NULL)");

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
   const char * baseDN, const char * filter, int scope, const char * caFile)
{
   int              i;
   int              err;
   char           * msg;
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

   NSLog(@" ");
   NSLog(@"attempting %s bind (%s):", (caFile ? "TLS SASL" : "SASL"), (mech ? mech : "N/A"));
   ldapURI = ldapURI ? ldapURI : "ldap://127.0.0.1";
   NSLog(@"   initialzing LDAP (%s)...", ldapURI);
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

   if (caFile)
   {
     NSLog(@"   attempting to start TLS...");
      err = ldap_start_tls_s(ld, NULL, NULL);
      if (err == LDAP_SUCCESS)
      {
         NSLog(@"   TLS established");
      } else {
         ldap_get_option( ld, LDAP_OPT_DIAGNOSTIC_MESSAGE, (void*)&msg);
         NSLog(@"   ldap_start_tls_s(): %s", ldap_err2string(err));
         NSLog(@"   ssl/tls: %s", msg);
         ldap_memfree(msg);
      };
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
   err = ldap_sasl_interactive_bind_s(ld, NULL, auth.mech,
              NULL, NULL,
              LDAP_SASL_QUIET, ldap_sasl_interact,
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

int ldap_sasl_interact(LDAP *ld, unsigned flags, void *defaults,
   void * sin)
{
   MyLDAPAuth      * ldap_inst = defaults;
	sasl_interact_t * interact;

   ldap_inst = (MyLDAPAuth *) defaults;
   interact  = (sasl_interact_t *) sin;
   flags     = 0;

   if (!(ld))
      return(LDAP_PARAM_ERROR);

   NSLog(@"      entering my_ldap_sasl_interact_proc()");
   for(interact = sin; (interact->id != SASL_CB_LIST_END); interact++)
   {
      interact->result = NULL;
      interact->len    = 0;
      switch( interact->id )
      {
         case SASL_CB_GETREALM:
            NSLog(@"         processing SASL_CB_GETREALM (%s)", ldap_inst->realm ? ldap_inst->realm : "");
            interact->result = ldap_inst->realm ? ldap_inst->realm : "";
            interact->len    = strlen( interact->result );
            break;
         case SASL_CB_AUTHNAME:
            NSLog(@"         processing SASL_CB_AUTHNAME (%s)", ldap_inst->authuser ? ldap_inst->authuser : "");
            interact->result = ldap_inst->authuser ? ldap_inst->authuser : "";
            interact->len    = strlen( interact->result );
            break;
         case SASL_CB_PASS:
            NSLog(@"         processing SASL_CB_PASS (%s)", ldap_inst->passwd ? ldap_inst->passwd : "");
            interact->result = ldap_inst->passwd ? ldap_inst->passwd : "";
            interact->len    = strlen( interact->result );
            break;
         case SASL_CB_USER:
            NSLog(@"         processing SASL_CB_USER (%s)", ldap_inst->user ? ldap_inst->user : "");
            interact->result = ldap_inst->user ? ldap_inst->user : "";
            interact->len    = strlen( interact->result );
            break;
         case SASL_CB_NOECHOPROMPT:
            NSLog(@"         processing SASL_CB_NOECHOPROMPT");
            break;
         case SASL_CB_ECHOPROMPT:
            NSLog(@"         processing SASL_CB_ECHOPROMPT");
            break;
         default:
            NSLog(@"         I don't know how to process this.");
            break;
      };
   };
   NSLog(@"      exiting my_ldap_sasl_interact_proc()");

   return(LDAP_SUCCESS);
};
