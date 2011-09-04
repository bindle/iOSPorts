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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   NSAutoreleasePool * pool;
   NSString          * filePath;
   const char        * caFile;

   [window makeKeyAndVisible];

   pool = [[NSAutoreleasePool alloc] init];

   test_all_ldap(NULL);

   filePath = [[NSBundle mainBundle] pathForResource:@"ca-certs" ofType:@"pem"];
   if (filePath)
      caFile   = [filePath UTF8String];
   if(caFile)
      test_all_ldap(caFile);

   [pool release];

	return YES;

}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
