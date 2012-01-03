//
//  APTokenField.h
//  APTokenField
//
//  Created by Arash Payan on 12/13/11.
//  Copyright (c) 2011 Arash Payan. All rights reserved.
//

@protocol APTokenFieldDataSource;
@class APShadowView;
#import <UIKit/UIKit.h>

@interface APTokenField : UIControl <UITableViewDataSource, UITextFieldDelegate, UITableViewDelegate> {
    id<APTokenFieldDataSource> tokenFieldDataSource;
    APShadowView *shadowView;
    UITextField *textField;
    UIView *tokenContainer;
    NSMutableArray *tokens;
    UIFont *font;
    UITableView *resultsTable;
    NSString *labelText;
    UILabel *label;
    NSUInteger numberOfResults;
}

@property (nonatomic, copy) NSString *labelText;
@property (nonatomic, readonly) UITableView *resultsTable;
@property (nonatomic, assign) id<APTokenFieldDataSource> tokenFieldDataSource;
@property (nonatomic, retain) UIFont *font;
- (void)addObject:(id)object;

@end


@protocol APTokenFieldDataSource <NSObject>

@required
- (NSString*)tokenField:(APTokenField*)tokenField titleForObject:(id)anObject;
- (NSUInteger)numberOfResultsInTokenField:(APTokenField*)tokenField;
- (id)tokenField:(APTokenField*)tokenField objectAtResultsIndex:(NSUInteger)index;
- (void)tokenField:(APTokenField*)tokenField searchQuery:(NSString*)query;

@optional
/* If you don't implement this method, then the results table will use
 UITableViewCellStyleDefault with the value provided by
 tokenField:titleForObject: as the textLabel of the UITableViewCell. */
- (UITableViewCell*)tokenField:(APTokenField*)tokenField
                     tableView:(UITableView*)tableView
                  cellForIndex:(NSUInteger)index;

@end