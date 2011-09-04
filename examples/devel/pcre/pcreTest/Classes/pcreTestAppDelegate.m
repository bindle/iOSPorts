//
//  pcreTestAppDelegate.m
//  pcreTest
//
//  Created by David Syzdek on 10/28/10.
//  Copyright 2010 David M. Syzdek. All rights reserved.
//

#import "pcreTestAppDelegate.h"

#include <pcre.h>
#include <string.h>

@implementation pcreTestAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
   int          i;
   int          rc;
   int          subject_length;
   int          substring_length;
   int          erroffset;
   int          ovector[1024];
   pcre       * re;
   const char * error;
   char         subject[1024];
   char       * substring_start;

    // Override point for customization after application launch.
    
    [window makeKeyAndVisible];

   NSLog(@"Testing pcre...");

   NSLog(@"   compiling pattern...");
   re = pcre_compile("((([\\w]|[\\w][\\w\\-]*[\\w])\\.)*([\\w]|[\\w][\\w\\-]*[\\w]))", 0, &error, &erroffset, NULL);
   if (re == NULL)
   {
      NSLog(@"PCRE compilation failed at offset %d: %s\n", erroffset, error);
      return YES;
   };

   NSLog(@"   testing pattern...");
   strncpy(subject, "git.scm.bindlebinaries.com ", 1024);
   subject_length = strlen(subject);
   rc = pcre_exec(re, NULL, subject, subject_length, 0, 0, ovector, 1024);
   if (rc < 0)
   {
      switch(rc)
      {
         case PCRE_ERROR_NOMATCH: NSLog(@"No match\n"); break;
         default: NSLog(@"Matching error %d\n", rc); break;
      };
      pcre_free(re);     /* Release memory used for the compiled pattern */
      return YES;
   };

   NSLog(@"Match succeeded at offset %d", ovector[0]);

   if (rc == 0)
   {
      rc = 1024/3;
      NSLog(@"ovector only has room for %d captured substrings\n", rc - 1);
   };

   NSLog(@"Matches:");
   for (i = 0; i < rc; i++)
   {
      substring_start = subject + ovector[2*i];
      substring_length = ovector[2*i+1] - ovector[2*i];
      NSLog(@"   %2d: %.*s\n", i, substring_length, substring_start);
   };

   return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
