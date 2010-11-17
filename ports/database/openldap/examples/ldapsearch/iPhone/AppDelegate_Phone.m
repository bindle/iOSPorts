//
//  AppDelegate_Phone.m
//  ldapsearch
//
//  Created by David Syzdek on 6/22/10.
//  Copyright David M. Syzdek 2010. All rights reserved.
//

#import "AppDelegate_Phone.h"
#import "ldapTest.h"

@implementation AppDelegate_Phone

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch

   [window makeKeyAndVisible];

   test_simple_ldap(
      LDAP_VERSION3,          // LDAP protocol version
      "ldap://10.0.1.3",      // LDAP URI
      "cn=Directory Manager", // LDAP bind DN
      "drowssap",             // LDAP bind password
      "o=test",               // LDAP search base DN
      "(objectclass=*)",      // LDAP search filter
      LDAP_SCOPE_SUB          // LDAP search scope
   );

	return YES;

}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
