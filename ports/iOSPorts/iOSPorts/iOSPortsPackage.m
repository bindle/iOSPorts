/*
 *  iOS Ports Library
 *  Copyright (c) 2012 Bindle Binaries
 *  All rights reserved.
 *
 *  @BINDLE_BINARIES_BSD_LICENSE_START@
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are
 *  met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Bindle Binaries nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 *  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 *  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 *  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BINDLE BINARIES BE LIABLE FOR
 *  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 *  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 *  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 *  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 *  SUCH DAMAGE.
 *
 *  @BINDLE_BINARIES_BSD_LICENSE_END@
 */
/**
 *  @file ports/iOSPorts/classes/iOSPortsPackage.m interface to PKGDATA
 */
#import "iOSPortsPackage.h"


#import <stdio.h>
#import <dlfcn.h>
#import <string.h>


#pragma mark - C Functions

// Looks up a package based up the packages ID
const iOSPortsPKGData * iOSPorts_find_pkg_by_id(const char * pkg_id)
{
   char     * lookupID;
   size_t     pos;
   unsigned   u;

   if (!(lookupID = strdup(pkg_id)))
      return(NULL);

   for(u = 0; u < strlen(lookupID); u++)
   {
      if ( ((lookupID[u] < 'A') || (lookupID[u] > 'Z')) &&
           ((lookupID[u] < 'a') || (lookupID[u] > 'z')) &&
           ((lookupID[u] < '0') || (lookupID[u] > '9')) )
         lookupID[u] = '_';
   };

   for(pos = 0; iOSPortsPKGList[pos].name; pos++)
   {
      if (!(strcasecmp(lookupID, iOSPortsPKGList[pos].name)))
      {
         free(lookupID);
         return(iOSPortsPKGList[pos].data);
      };
   };

   free(lookupID);

   return(NULL);
}


#pragma mark -
@implementation iOSPortsPackage

@synthesize identifier;
@synthesize name;
@synthesize version;
@synthesize website;
@synthesize license;

#pragma mark - Object Management Methods

- (void)dealloc
{
   self.identifier = nil;
   self.name = nil;
   self.version = nil;
   self.website = nil;
   self.license = nil;

   [super dealloc];

   return;
}


- (iOSPortsPackage *) initWithIdentifier:(NSString *)anIdentifier
{
   if (!(self = [super init]))
      return(self);

   [self setToIdentifier:anIdentifier];

   return(self);
}


+ (iOSPortsPackage *) iOSPortsPackageWithIdentifier:(NSString *)anIdentifier
{
   iOSPortsPackage * portpkg;
   portpkg = [[iOSPortsPackage alloc] initWithIdentifier:anIdentifier];
   return([portpkg autorelease]);
}


#pragma mark - package querying methods

- (BOOL) setToIdentifier:(NSString *)anIdentifier
{
   NSAutoreleasePool     * pool;
   const iOSPortsPKGData * datap;

   self.identifier = anIdentifier;
   self.name       = nil;
   self.version    = nil;
   self.website    = nil;
   self.license    = nil;

   if (!(datap = [self registeredPackage:anIdentifier]))
      return(YES);

   pool = [[NSAutoreleasePool alloc] init];

   self.identifier = datap->pkg_id         ? [NSString stringWithUTF8String:datap->pkg_id]      : nil;
   self.name       = datap->pkg_name       ? [NSString stringWithUTF8String:datap->pkg_name]    : nil;
   self.version    = datap->pkg_version    ? [NSString stringWithUTF8String:datap->pkg_version] : nil;
   self.website    = datap->pkg_website    ? [NSString stringWithUTF8String:datap->pkg_website] : nil;
   self.license    = datap->pkg_license[0] ? [NSString stringWithUTF8String:datap->pkg_license] : nil;

   [pool release];

   return(NO);
}


+ (const iOSPortsPKGData *) registeredPackage:(NSString *)anIdentifier
{
   NSAutoreleasePool     * pool;
   const iOSPortsPKGData * datap;

   pool = [[NSAutoreleasePool alloc] init];
   datap = iOSPorts_find_pkg_by_id([anIdentifier UTF8String]);
   [pool release];

   return(datap);
}


- (const iOSPortsPKGData *) registeredPackage:(NSString *)anIdentifier
{
   return([iOSPortsPackage registeredPackage:anIdentifier]);
}


@end
