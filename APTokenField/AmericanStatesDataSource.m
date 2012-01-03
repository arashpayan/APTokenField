//
//  AmericanStatesDataSource.m
//  APTokenField
//
//  Created by Arash Payan on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AmericanStatesDataSource.h"

@implementation AmericanStatesDataSource

- (id)init {
    self = [super init];
    if (self) {
        states = [[NSMutableArray alloc] initWithObjects:
                  @"Alabama",
                  @"Alaska",
                  @"Arizona",
                  @"Arkansas",
                  @"California",
                  @"Colorado",
                  @"Connecticut",
                  @"Delaware",
                  @"Florida",
                  @"Georgia",
                  @"Hawaii",
                  @"Idaho",
                  @"Illinois",
                  @"Indiana",
                  @"Iowa",
                  @"Kansas",
                  @"Kentucky",
                  @"Louisiana",
                  @"Maine",
                  @"Maryland",
                  @"Massachusetts",
                  @"Michigan",
                  @"Minnesota",
                  @"Mississippi",
                  @"Missouri",
                  @"Montana",
                  @"Nebraska",
                  @"Nevada",
                  @"New Hampshire",
                  @"New Jersey",
                  @"New Mexico",
                  @"New York",
                  @"North Carolina",
                  @"North Dakota",
                  @"Ohio",
                  @"Oklahoma",
                  @"Oregon",
                  @"Pennsylvania",
                  @"Rhode Island",
                  @"South Carolina",
                  @"South Dakota",
                  @"Tennessee",
                  @"Texas",
                  @"Utah",
                  @"Vermont",
                  @"Virginia",
                  @"Washington",
                  @"West Virginia",
                  @"Wisconsin",
                  @"Wyoming", nil];
        
        results = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [states release];
    [results release];
    
    [super dealloc];
}

#pragma mark - APTokenFieldDataSource

- (NSString*)tokenField:(APTokenField *)tokenField titleForObject:(id)anObject {
    /* Because the object representing each label is itself a string, we just return
     the object itself. */
    return (NSString*)anObject;
}

- (NSUInteger)numberOfResultsInTokenField:(APTokenField *)tokenField {
    return [results count];
}

- (id)tokenField:(APTokenField *)tokenField objectAtResultsIndex:(NSUInteger)index {
    return [results objectAtIndex:index];
}

- (void)tokenField:(APTokenField *)tokenField searchQuery:(NSString *)query {
    [results removeAllObjects];
    
    for (NSString *state in states)
    {
        // check each state to see if the query string is anywhere to be found in there
        if ([state rangeOfString:query options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            // it's in there, so add this state to our results set
            [results addObject:state];
        }
    }
}

@end
