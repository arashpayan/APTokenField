//
//  APTokenField.h
//  APTokenField
//
//  Created by Arash Payan on 12/13/11.
//  Copyright (c) 2011 Arash Payan. All rights reserved.
//

@protocol APTokenDataSource;
@class APShadowView;
#import <UIKit/UIKit.h>

@interface APTokenField : UIControl <UITableViewDataSource> {
    id<APTokenDataSource> tokenFieldDataSource;
    APShadowView *shadowView;
    UIView *tokenContainer;
    NSMutableArray *tokens;
    UIFont *font;
}

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, assign) id<APTokenDataSource> tokenFieldDataSource;
@property (nonatomic, retain) UIFont *font;

@end


@protocol APTokenDataSource <NSObject>

@required
- (NSString*)tokenField:(APTokenField*)tokenField titleForObject:(id)anObject;
- (NSUInteger)numberOfResultsInTokenField:(APTokenField*)tokenField;
- (id)tokenField:(APTokenField*)tokenField objectAtIndex:(NSUInteger)index;

@optional
/* If you don't implement this method, then the results table will use
 UITableViewCellStyleDefault with the value provided by
 tokenField:titleForObject: as the textLabel of the UITableViewCell. */
- (UITableViewCell*)tokenField:(APTokenField*)tokenField
                     tableView:(UITableView*)tableView
                  cellForIndex:(NSUInteger)index;

@end