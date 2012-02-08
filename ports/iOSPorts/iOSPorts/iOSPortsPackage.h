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
 *  @file ports/iOSPorts/classes/iOSPortsPackage.h interface to PKGDATA
 */

///////////////
//           //
//  Headers  //
//           //
///////////////
#pragma mark - Headers

#import <Foundation/Foundation.h>
#import <sys/types.h>


/////////////////
//             //
//  Datatypes  //
//             //
/////////////////
#pragma mark - Datatypes

typedef struct iosports_pkg_data iOSPortsPKGData;
struct iosports_pkg_data
{
   const char * pkg_id;
   const char * pkg_name;
   const char * pkg_version;
   const char * pkg_website;
   const char   pkg_license[];
};


typedef struct iosports_pkg_list_data iOSPortsPKGListData;
struct iosports_pkg_list_data
{
   const char * name;
   const iOSPortsPKGData * data;
};


//////////////////
//              //
//  Prototypes  //
//              //
//////////////////
#pragma mark - Prototypes

// Looks up a package based up the packages ID
const iOSPortsPKGData *  iOSPorts_find_pkg_by_id(const char * pkg_id);

// array of package information
extern iOSPortsPKGListData iOSPortsPKGList[];


///////////////////////
//                   //
//  iOSPortsPackage  //
//                   //
///////////////////////
#pragma mark -
@interface iOSPortsPackage : NSObject
{
   NSString * identifier;
   NSString * name;
   NSString * version;
   NSString * website;
   NSString * license;
}

@property(nonatomic, retain) NSString * identifier;
@property(nonatomic, retain) NSString * name;
@property(nonatomic, retain) NSString * version;
@property(nonatomic, retain) NSString * website;
@property(nonatomic, retain) NSString * license;

// Object Management Methods
- (BOOL) setToIdentifier:(NSString *)anIdentifier;
- (iOSPortsPackage *) initWithIdentifier:(NSString *)anIdentifier;

// package querying methods
+ (iOSPortsPackage *) iOSPortsPackageWithIdentifier:(NSString *)anIdentifier;
+ (const iOSPortsPKGData *) registeredPackage:(NSString *)anIdentifier;
- (const iOSPortsPKGData *) registeredPackage:(NSString *)anIdentifier;
@end
