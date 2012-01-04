//
//  APTokenFieldController.m
//  APTokenField
//
//  Created by Arash Payan on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "APTokenFieldController.h"

@implementation APTokenFieldController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        statesDataSource = [[AmericanStatesDataSource alloc] init];
    }
    return self;
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    tokenField = [[APTokenField alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    tokenField.tokenFieldDataSource = statesDataSource;
    tokenField.labelText = @"States:";
    
    self.view = tokenField;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [tokenField release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [tokenField release];
    
    [super dealloc];
}

@end
