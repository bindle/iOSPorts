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
 *  @file ports/iOSPorts/classes/iOSPortsViewController.m controls navigation of Package info
 */

#import "iOSPortsViewController.h"

#define kTextViewTag 1


@implementation iOSPortsViewController

#pragma mark -
#pragma mark Properties

@synthesize viewFrame;


#pragma mark -
#pragma mark Initialization

- (id)init
{
   CGRect aFrame;
   if ((self = [super init]))
   {
      aFrame          = [[UIScreen mainScreen] bounds];
      self.title      = @"Acknowledgements";
      self.viewFrame  = CGRectMake(aFrame.origin.x,
                              10,
                              aFrame.size.width,
                              aFrame.size.height - 10);
   };
   return(self);
}


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
   UITableView * myView;

   [self initializePackages];

   myView = [[UITableView alloc] initWithFrame:viewFrame style:UITableViewStyleGrouped];
   myView.separatorStyle = UITableViewCellSeparatorStyleNone;
   myView.dataSource     = self;
   myView.delegate       = self;

   self.view = myView;
   [myView release];

   return;
}


/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Package Management

// initializes packagesList array and adds iOS Ports package to array
// returns BOOL YES if an error is encountered
- (BOOL) initializePackages
{
   if (packagesList)
      return(NO);

   if (!(packagesList = [[NSMutableArray alloc] initWithCapacity:2]))
      return(YES);

   if (([self addPackageWithIdentifier:@"iOSPorts"]))
   {
      [packagesList release];
      packagesList = nil;
      return(YES);
   };

   return(NO);
}


// Adds a custom iOS Ports Package data to the packagesList array
// returns BOOL YES if an error is encountered
- (BOOL) addPackage:(iOSPortsPackage *)portpkg
{
   if (!(packagesList))
      if (([self initializePackages]))
         return(YES);

   [packagesList addObject:portpkg];

   return(NO);
}


// Adds an iOS Ports Package data to the packagesList array
// returns BOOL YES if an error is encountered
- (BOOL) addPackageWithIdentifier:(NSString *)name
{
   iOSPortsPackage   * portpkg;
   NSAutoreleasePool * pool;

   pool = [[NSAutoreleasePool alloc] init];

   if (!(portpkg = [[[iOSPortsPackage alloc] initWithIdentifier:name] autorelease]))
   {
      [pool release];
      return(YES);
   };

   if (([self addPackage:portpkg]))
   {
      [pool release];
      return(YES);
   };

   [pool release];

   return(NO);
}


// returns the iOSPortsPackage object of a package added to the packagesList array
// returns nil if an error is encountered
- (iOSPortsPackage *) findPackageWithIdentifier:(NSString *)name
{
   NSUInteger           index;
   iOSPortsPackage    * portpkg;
   NSComparisonResult   result;

   if (!(packagesList))
      return(nil);

   for(index = 0; index < [packagesList count]; index++)
   {
      portpkg = [packagesList objectAtIndex:index];
      result = [name caseInsensitiveCompare:portpkg.identifier];
      if (result == NSOrderedSame)
         return(portpkg);
   };

   return(nil);
}


// Removes an iOS Ports Package data from the packagesList array
- (void) removePackageWithIdentifier:(NSString *)name
{
   NSUInteger           index;
   iOSPortsPackage    * portpkg;
   NSComparisonResult   result;

   if (!(packagesList))
      return;

   for(index = 0; index < [packagesList count]; index++)
   {
      portpkg = [packagesList objectAtIndex:index];
      result = [name caseInsensitiveCompare:portpkg.identifier];
      if (result == NSOrderedSame)
      {
         [packagesList removeObjectAtIndex:index];
         return;
      };
   };

   return;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return ([packagesList count]);
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   return([[packagesList objectAtIndex: section] name]);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // Return the number of rows in the section.
   return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   CGSize            size;
   iOSPortsPackage * portpkg;

   switch(indexPath.row)
   {
      case 2:
         size.width  = (self.tableView.bounds.size.width * 0.85);
         size.height = 99999;
         portpkg     = [packagesList objectAtIndex:indexPath.section];
         size = [portpkg.license sizeWithFont:[UIFont fontWithName:@"Arial" size:12] constrainedToSize:size];
         return(size.height);
      default:
         return(38.8);
   };
	return ([indexPath row] == 0) ? 50.0 : 38.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   iOSPortsPackage * portpkg;
	UITableViewCell * cell;

   static NSString * kVersionCell_ID = @"VersionCellID";
   static NSString * kWebsiteCell_ID = @"WebsiteCellID";
   static NSString * kLicenseCell_ID = @"LicenseCellID";

   portpkg = [packagesList objectAtIndex:indexPath.section];

   switch([indexPath row])
	{
      case 0: // Version row
         cell = [self.tableView dequeueReusableCellWithIdentifier:kVersionCell_ID];
         if (cell == nil)
         {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kVersionCell_ID] autorelease];
            cell.selectionStyle                 = UITableViewCellSelectionStyleNone;
            cell.textLabel.text                 = @"Version:";
         };
         cell.detailTextLabel.text = portpkg.version;
         break;
      case 1: // Website row
         cell = [self.tableView dequeueReusableCellWithIdentifier:kWebsiteCell_ID];
         if (cell == nil)
         {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kWebsiteCell_ID] autorelease];
            cell.selectionStyle                 = UITableViewCellSelectionStyleGray;
            cell.textLabel.text                 = @"Website:";
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.detailTextLabel.minimumFontSize           = 8;
            cell.detailTextLabel.numberOfLines             = 1;
         };
         cell.detailTextLabel.text = portpkg.website;
         break;
      default: // License row
         cell = [self.tableView dequeueReusableCellWithIdentifier:kLicenseCell_ID];
         if (cell == nil)
         {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLicenseCell_ID] autorelease];
            cell.selectionStyle                 = UITableViewCellSelectionStyleNone;
            cell.textLabel.font                 = [UIFont fontWithName:@"Arial" size:12];
            cell.textLabel.numberOfLines        = 0;
         };
         cell.textLabel.text = portpkg.license;
         break;
	};
   return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   iOSPortsPackage * portpkg;
   portpkg = [packagesList objectAtIndex:indexPath.section];
   [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
   switch([indexPath row])
   {
      case 1:
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:portpkg.website]];
         break;
      default:
         break;
   };
   return;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
   return;
}


- (void)dealloc
{
   if (packagesList)
   {
      [packagesList release];
      packagesList = nil;
   };
   [super dealloc];
}


@end

