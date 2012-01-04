//
//  APTokenField.h
//  APTokenField
//
//  Created by Arash Payan on 12/13/11.
//  Copyright (c) 2011 Arash Payan. All rights reserved.
//

@protocol APTokenFieldDataSource;
@protocol APTokenFieldDelegate;
@class APShadowView;
#import <UIKit/UIKit.h>

@interface APTokenField : UIControl <UITableViewDataSource, UITextFieldDelegate, UITableViewDelegate> {
    id<APTokenFieldDataSource> tokenFieldDataSource;
    id<APTokenFieldDelegate> tokenFieldDelegate;
    APShadowView *shadowView;
    UITextField *textField;
    UIView *tokenContainer;
    NSMutableArray *tokens;
    UIFont *font;
    UITableView *resultsTable;
    NSString *labelText;
    UILabel *label;
    NSUInteger numberOfResults;
    UIView *rightView;
}

@property (nonatomic, retain) UIFont *font;
@property (nonatomic, copy) NSString *labelText;
@property (nonatomic, readonly) UITableView *resultsTable;
@property (nonatomic, retain) UIView *rightView;
@property (nonatomic, assign) id<APTokenFieldDataSource> tokenFieldDataSource;
@property (nonatomic, assign) id<APTokenFieldDelegate> tokenFieldDelegate;
- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (NSUInteger)objectCount;

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
- (CGFloat)resultRowsHeightForTokenField:(APTokenField*)tokenField;

@end


@protocol APTokenFieldDelegate <NSObject>

@optional
/* Called when the user adds an object from the results list. */
- (void)tokenField:(APTokenField*)tokenField didAddObject:(id)object;
/* Called when the user deletes an object from the token field. */
- (void)tokenField:(APTokenField*)tokenField didRemoveObject:(id)object;
- (void)tokenFieldDidEndEditing:(APTokenField*)tokenField;
/* Called when the user taps the 'enter'. */
- (void)tokenFieldDidReturn:(APTokenField*)tokenField;

@end