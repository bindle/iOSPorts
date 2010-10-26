//
//  testViewController.m
//  test
//
//  Created by David Syzdek on 10/26/10.
//  Copyright 2010 David M. Syzdek. All rights reserved.
//

#import "testViewController.h"

@implementation testViewController

@synthesize label;



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)loadView {
   CGRect aFrame;
   aFrame = CGRectMake(0,20,320,460);
   self.view = [[UIView alloc] initWithFrame:aFrame];
   self.view.backgroundColor = [UIColor lightGrayColor];
   
   if ((label = [[UILabel alloc] init]))
   {
      label.frame = CGRectMake(5, 10, 310, 21);
      label.text  = @"View Console Log to follow tests.";
      label.backgroundColor = [UIColor clearColor];
      [self.view addSubview:label];
   };

   return;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end

