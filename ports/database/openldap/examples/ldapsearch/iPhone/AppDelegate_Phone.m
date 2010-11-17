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

   test_all_ldap();

	return YES;

}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
