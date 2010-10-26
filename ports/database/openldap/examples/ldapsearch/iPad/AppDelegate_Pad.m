//
//  AppDelegate_Pad.m
//  ldapsearch
//
//  Created by David Syzdek on 6/22/10.
//  Copyright David M. Syzdek 2010. All rights reserved.
//

#import "AppDelegate_Pad.h"
#import <ldap.h>
#include <stdlib.h>
#include <string.h>

@implementation AppDelegate_Pad

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch

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

   [window makeKeyAndVisible];

   vals            = NULL;
   servercredp     = NULL;
   cred.bv_val     = "drowssap";
   cred.bv_len     = (size_t) strlen("drowssap");
   dn              = "cn=Directory Manager";

   NSLog(@"initialzing LDAP...");
   ldap_initialize(&ld, "ldap://192.168.100.3/");

   NSLog(@"binding to LDAP server...");
   err = ldap_sasl_bind_s(ld, dn, LDAP_SASL_SIMPLE, &cred, NULL, NULL, &servercredp);
   if (err == LDAP_SUCCESS)
   {
      NSLog(@"ldap_sasl_bind_s(): %s", ldap_err2string(err));
      ldap_unbind_ext_s(ld, NULL, NULL);
      return(YES);
   };

   NSLog(@"initiating lookup...");
   if ((err = ldap_search_ext_s(ld, "o=test", LDAP_SCOPE_SUB, "(objectclass=*)", NULL, 0, NULL, NULL, NULL, -1, &res)))
   {
      NSLog(@"ldap_search_ext_s(): %s", ldap_err2string(err));
      ldap_unbind_ext_s(ld, NULL, NULL);
      return(YES);
   };

   NSLog(@"checking for results...");
   if (!(ldap_count_entries(ld, res)))
   {
      NSLog(@"no entries found.");
      ldap_msgfree(res);
      ldap_unbind_ext_s(ld, NULL, NULL);
      return(YES);
   };
   NSLog(@"%i entries found.", ldap_count_entries(ld, res));

   NSLog(@"retrieving results...");
   if (!(entry = ldap_first_entry(ld, res)))
   {
      NSLog(@"ldap_first_entry(): %s", ldap_err2string(err));
      ldap_msgfree(res);
      ldap_unbind_ext_s(ld, NULL, NULL);
      return(YES);
   };

   while(entry)
   {
      NSLog(@" ");
      NSLog(@"dn: %s", ldap_get_dn(ld, entry));

      attribute = ldap_first_attribute(ld, entry, &ber);
      while(attribute)
      {
         if ((vals = ldap_get_values_len(ld, entry, attribute)))
         {
            for(i = 0; vals[i]; i++)
               NSLog(@"%s: %s", attribute, vals[i]->bv_val);
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
	
	return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
