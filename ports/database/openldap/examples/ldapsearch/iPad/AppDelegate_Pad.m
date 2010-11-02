//
//  AppDelegate_Pad.m
//  ldapsearch
//
//  Created by David Syzdek on 6/22/10.
//  Copyright David M. Syzdek 2010. All rights reserved.
//

#import "AppDelegate_Pad.h"
#import "ldapTest.h"


@implementation AppDelegate_Pad

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch

   [window makeKeyAndVisible];

   test_ldap(LDAP_VERSION3, "ldap://10.0.1.3", "cn=Directory Manager",
   "drowssap", "o=test", "(objectclass=*)", LDAP_SCOPE_SUB);
	
	return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
