//
//  AmericanStatesDataSource.h
//  APTokenField
//
//  Created by Arash Payan on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "APTokenField.h"
#import <Foundation/Foundation.h>

@interface AmericanStatesDataSource : NSObject <APTokenFieldDataSource> {
    NSMutableArray *states;
    NSMutableArray *results;
}

@end
