//
//  PGAppDelegate.m
//  tables
//
//  Created by David M. Syzdek on 4/20/13.
//  Copyright (c) 2013 PostgreSQL tables. All rights reserved.
//

#import "PGAppDelegate.h"

#include <stdio.h>
#include <libpq-fe.h>

@implementation PGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

[self pgtest];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) pgtest
{
   char       buff[1024];
   PGconn   * pd;
   PGresult * res;
   int        i;
   int        num_records;
   char       name[256];

   snprintf(buff, 1024, "host='flipflop.local' dbname='school' user='syzdek' sslmode='require'");
   if ((pd = PQconnectdb(buff)) == NULL)
   {
      fprintf(stderr, "PQconnectdb() returned NULL");
      return;
   };
   if (PQstatus(pd) != CONNECTION_OK)
   {
      fprintf(stderr, "%s\n", PQerrorMessage(pd));
      PQfinish(pd);
      return;
   };

   res = PQexec(pd, "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';");
   if ((!res) || ((PQresultStatus(res) != PGRES_TUPLES_OK)))
   {
      fprintf(stderr, "%s", PQerrorMessage(pd));
      PQclear(res);
      PQfinish(pd);
      return;
   };

   num_records = PQntuples(res);

   for(i = 0 ; i < num_records ; i++)
   {
      sprintf(name, "%s", PQgetvalue(res, i, 0));
      printf("%s\n", PQgetvalue(res, i, 0));
   };

   PQclear(res);

   PQfinish(pd);

   return;
}

@end
