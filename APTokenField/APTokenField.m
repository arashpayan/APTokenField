/*
 * Copyright (c) 2012, Arash Payan
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or
 * without modification, are permitted provided that the following
 * conditions are met:
 * 
 * +Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 * +Redistributions in binary form must reproduce the above
 *  copyright notice, this list of conditions and the following
 *  disclaimer in the documentation and/or other materials provided
 *  with the distribution.
 * +Neither the name of Arash Payan nor the names of its 
 *  contributors may be used to endorse or promote products derived
 *  from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "APTokenField.h"
#import <QuartzCore/QuartzCore.h>

static NSString *const kHiddenCharacter = @"\u200B";

@interface APTextField : UITextField {}
@end

@implementation APTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ([self.text isEqualToString:kHiddenCharacter])
    {
        if (action == @selector(paste:))
            return YES;
        else
            return NO;
    }
    else
        return [super canPerformAction:action withSender:sender];
}

@end

@interface APSolidLine : UIView
@end

@implementation APSolidLine

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat lineColor[4] = {204.0/255.0, 204.0/255.0, 204.0/255.0, 1};
    CGContextSetFillColor(ctx, lineColor);
    CGContextFillRect(ctx, rect);
}

@end

@interface APShadowView : UIView {
    CAGradientLayer *shadowLayer;
}
@end

@implementation APShadowView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        shadowLayer = [[CAGradientLayer alloc] init];
        CGColorRef darkColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
        CGColorRef lightColor = [UIColor colorWithWhite:1 alpha:0].CGColor;
        shadowLayer.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
        [self.layer addSublayer:shadowLayer];
    }
    
    return self;
}

- (void)layoutSubviews {
    CGRect bounds = self.bounds;
    shadowLayer.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
}

- (void)dealloc {
    [shadowLayer release];
    
    [super dealloc];
}

@end

#define TOKEN_HZ_PADDING            8.5
#define TOKEN_VT_PADDING            2.5

@interface APTokenView : UIView {
    NSString *title;
    APTokenField *tokenField;
    id object;
    BOOL highlighted;
}

@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) APTokenField *tokenField;
+ (APTokenView*)tokenWithTitle:(NSString*)aTitle object:(id)anObject;
- (id)initWithTitle:(NSString*)aTitle object:(id)anObject;

@end

@implementation APTokenView

@synthesize highlighted;
@synthesize object;
@synthesize title;
@synthesize tokenField;

+ (APTokenView*)tokenWithTitle:(NSString*)aTitle object:(id)anObject {
    return [[[APTokenView alloc] initWithTitle:aTitle object:anObject] autorelease];
}

- (id)initWithTitle:(NSString*)aTitle object:(id)anObject {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        highlighted = NO;
        self.title = aTitle;
        self.backgroundColor = [UIColor clearColor];
        self.object = anObject;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGSize titleSize = [title sizeWithFont:tokenField.font];
    
    CGRect bounds = CGRectMake(0, 0, titleSize.width + TOKEN_HZ_PADDING*2.0, titleSize.height + TOKEN_VT_PADDING*2.0);
    CGRect textBounds = bounds;
    textBounds.origin.x = (bounds.size.width - titleSize.width) / 2;
    textBounds.origin.y += 4;
    
    CGFloat arcValue = (bounds.size.height / 2) + 1;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGPoint endPoint = CGPointMake(1, self.bounds.size.height + 10);
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, arcValue, arcValue, arcValue, (M_PI / 2), (3 * M_PI / 2), NO);
    CGContextAddArc(context, bounds.size.width - arcValue, arcValue, arcValue, 3 * M_PI / 2, M_PI / 2, NO);
    CGContextClosePath(context);
    
    if (highlighted){
        CGContextSetFillColor(context, (CGFloat[8]){0.207, 0.369, 1, 1});
        CGContextFillPath(context);
        CGContextRestoreGState(context);
    }
    else
    {
        CGContextClip(context);
        CGFloat locations[2] = {0, 0.95};
        CGFloat components[8] = {0.631, 0.733, 1, 1, 0.463, 0.510, 0.839, 1};
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
        CGContextDrawLinearGradient(context, gradient, CGPointZero, endPoint, 0);
        CGGradientRelease(gradient);
        CGContextRestoreGState(context);
    }
    
    // Draw the inner gradient.
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, arcValue, arcValue, (bounds.size.height / 2), (M_PI / 2) , (3 * M_PI / 2), NO);
    CGContextAddArc(context, bounds.size.width - arcValue, arcValue, arcValue - 1, (3 * M_PI / 2), (M_PI / 2), NO);
    CGContextClosePath(context);
    
    CGContextClip(context);
    
    CGFloat locations[2] = {0, highlighted ? 0.8 : 0.4};
    CGFloat highlightedComp[8] = {0.365, 0.557, 1, 1, 0.251, 0.345, 1, 1};
    CGFloat nonHighlightedComp[8] = {0.867, 0.906, 0.973, 1, 0.737, 0.808, 0.945, 1};
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, highlighted ? highlightedComp : nonHighlightedComp, locations, 2);
    CGContextDrawLinearGradient(context, gradient, CGPointZero, endPoint, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    CGContextRestoreGState(context);
    
    [(highlighted ? [UIColor whiteColor] : [UIColor blackColor]) set];
    [title drawInRect:textBounds withFont:tokenField.font];
    
}

- (CGSize)desiredSize {
    CGSize titleSize = [title sizeWithFont:tokenField.font];
    titleSize.width += TOKEN_HZ_PADDING*2.0;
    titleSize.height += TOKEN_VT_PADDING*2.0 + 2;
    
    return titleSize;
}

- (void)dealloc {
    self.title = nil;
    self.tokenField = nil;
    
    [super dealloc];
}

@end

@interface APTokenField ()

@property (nonatomic, retain) UIView *backingView;
@property (nonatomic, retain) APShadowView *shadowView;
@property (nonatomic, retain) APTextField *textField;
@property (nonatomic, retain) UIView *tokenContainer;
@property (nonatomic, retain) NSMutableArray *tokens;

@end

@implementation APTokenField

@synthesize backingView;
@synthesize font;
@synthesize labelText;
@synthesize resultsTable;
@synthesize rightView;
@synthesize shadowView;
@synthesize textField;
@synthesize tokenContainer;
@synthesize tokens;
@synthesize tokenFieldDataSource;
@synthesize tokenFieldDelegate;

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.backingView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        backingView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backingView];
        
        numberOfResults = 0;
        self.font = [UIFont systemFontOfSize:14];
        
        self.tokenContainer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        tokenContainer.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedTokenContainer)] autorelease];
        [tokenContainer addGestureRecognizer:tapGesture];
        [self addSubview:tokenContainer];
        
        resultsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        resultsTable.dataSource = self;
        resultsTable.delegate = self;
        [self addSubview:resultsTable];
        
        self.shadowView = [[[APShadowView alloc] initWithFrame:CGRectZero] autorelease];
        [self addSubview:shadowView];
        
        self.textField = [[[APTextField alloc] initWithFrame:CGRectZero] autorelease];
        textField.text = kHiddenCharacter;
        textField.delegate = self;
        textField.font = font;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        if ([textField respondsToSelector:@selector(setSpellCheckingType:)])
            textField.spellCheckingType = UITextSpellCheckingTypeNo;
        [tokenContainer addSubview:textField];
        
        self.tokens = [[[NSMutableArray alloc] init] autorelease];
        
        solidLine = [[APSolidLine alloc] initWithFrame:CGRectZero];
        [self addSubview:solidLine];
    }
    
    return self;
}

- (void)addObject:(id)object {
    if (object == nil)
        [NSException raise:@"IllegalArgumentException" format:@"You can't add a nil object to an APTokenField"];
    
    NSString *title = nil;
    if (tokenFieldDataSource != nil)
        title = [tokenFieldDataSource tokenField:self titleForObject:object];
    
    // if we still don't have a title for it, we'll use the Obj-c name
    if (title == nil)
        title = [NSString stringWithFormat:@"%@", object];
    
    APTokenView *token = [APTokenView tokenWithTitle:title object:object];
    token.tokenField = self;
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedToken:)] autorelease];
    [token addGestureRecognizer:tapGesture];
    [tokens addObject:token];
    [tokenContainer addSubview:token];
    
    [tokenFieldDataSource tokenField:self searchQuery:@""];
    textField.text = kHiddenCharacter;
    
    [self setNeedsLayout];
}

- (void)removeObject:(id)object {
    if (object == nil)
        return;
    
    for (int i=0; i<[tokens count]; i++)
    {
        APTokenView *t = [tokens objectAtIndex:i];
        if ([t.object  isEqual:object])
        {
            [t removeFromSuperview];
            [tokens removeObjectAtIndex:i];
            [self setNeedsLayout];
            
            if ([tokenFieldDelegate respondsToSelector:@selector(tokenField:didRemoveObject:)])
                [tokenFieldDelegate tokenField:self didRemoveObject:object];
            
            return;
        }
    }
}

- (NSUInteger)objectCount {
    return [tokens count];
}

- (id)objectAtIndex:(NSUInteger)index {
    APTokenView *t = [tokens objectAtIndex:index];
    return t.object;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [textField becomeFirstResponder];
}

- (BOOL)isFirstResponder {
    return [textField isFirstResponder];
}

- (BOOL)canResignFirstResponder {
    return [textField canResignFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [textField resignFirstResponder];
}

#define CONTAINER_PADDING            12
#define MINIMUM_TEXTFIELD_WIDTH     40
#define CONTAINER_ELEMENT_VT_MARGIN 8
#define CONTAINER_ELEMENT_HZ_MARGIN 8

- (void)layoutSubviews {
    CGRect bounds = self.bounds;
    
    // calculate the starting x (containerWidth) and y (containerHeight) for our layout
    float containerWidth = 0;
    if (label != nil)   // we adjust the starting y in case the user specified labelText
    {
        [label sizeToFit];
        CGRect labelBounds = label.bounds;
        // we want the base of the label text to be the same as the token label base
        label.frame = CGRectMake(CONTAINER_PADDING,
                                 /* the +2 is because [label sizeToFit] isn't a tight fit (2 pixels of gap) */
                                 CONTAINER_ELEMENT_VT_MARGIN+TOKEN_VT_PADDING+font.lineHeight-label.font.lineHeight+2,
                                 labelBounds.size.width,
                                 labelBounds.size.height);
        containerWidth = CGRectGetMaxX(label.frame)+CONTAINER_PADDING;
    }
    else
        containerWidth = CONTAINER_PADDING;
    float containerHeight = CONTAINER_ELEMENT_VT_MARGIN;
    APTokenView *lastToken = nil;
    float rightViewWidth = 0;
    if (rightView)
        rightViewWidth = rightView.bounds.size.width+CONTAINER_ELEMENT_HZ_MARGIN;
    // layout each of the tokens
    for (APTokenView *token in tokens)
    {
        CGSize desiredTokenSize = [token desiredSize];
        if (containerWidth + desiredTokenSize.width > bounds.size.width-CONTAINER_PADDING-rightViewWidth)
        {
            containerHeight += desiredTokenSize.height + CONTAINER_ELEMENT_VT_MARGIN;
            containerWidth = CONTAINER_PADDING;
        }
        
        token.frame = CGRectMake(containerWidth, containerHeight, desiredTokenSize.width, desiredTokenSize.height);
        containerWidth += desiredTokenSize.width + CONTAINER_ELEMENT_HZ_MARGIN;
        
        lastToken = token;
    }
    
    // let's place the textfield now
    if (containerWidth + MINIMUM_TEXTFIELD_WIDTH > bounds.size.width-CONTAINER_PADDING-rightViewWidth)
    {
        containerHeight += lastToken.bounds.size.height+CONTAINER_ELEMENT_VT_MARGIN;
        containerWidth = CONTAINER_PADDING;
    }
    textField.frame = CGRectMake(containerWidth, containerHeight+TOKEN_VT_PADDING, CGRectGetMaxX(bounds)-CONTAINER_PADDING-containerWidth, font.lineHeight);
    
    // now that we know the size of all the tokens, we can set the frame for our container
    // if there are some results, then we'll only show the last row of the container, otherwise, we'll show all of it
    float minContainerHeight = font.lineHeight+TOKEN_VT_PADDING*2.0+2+CONTAINER_ELEMENT_VT_MARGIN*2.0;
    float tokenContainerWidth = 0;
    if (rightView)
        tokenContainerWidth = bounds.size.width-5-rightView.bounds.size.width-5;
    else
        tokenContainerWidth = bounds.size.width;
    if (numberOfResults == 0)
        tokenContainer.frame = CGRectMake(0, 0, tokenContainerWidth, MAX(minContainerHeight, containerHeight+lastToken.bounds.size.height+CONTAINER_ELEMENT_VT_MARGIN));
    else
        tokenContainer.frame = CGRectMake(0, -containerHeight+CONTAINER_ELEMENT_VT_MARGIN, tokenContainerWidth, MAX(minContainerHeight, containerHeight+lastToken.bounds.size.height+CONTAINER_ELEMENT_VT_MARGIN));
    
    // layout the backing view
    backingView.frame = CGRectMake(tokenContainer.frame.origin.x,
                                   tokenContainer.frame.origin.y,
                                   bounds.size.width,
                                   tokenContainer.frame.size.height);
    
    /* If there's a rightView, place it at the bottom right of the tokenContainer.
     We made sure to provide enough space for it in the logic above, so it should fit just right. */
    rightView.center = CGPointMake(bounds.size.width-CONTAINER_PADDING-rightView.bounds.size.width/2.0,
                                   CGRectGetMaxY(tokenContainer.frame)-5-rightView.bounds.size.height/2.0/*CGRectGetHeight(tokenContainer.frame)-5-rightView.bounds.size.height/2.0*/);
    
    // the solid line should be 1 pt at the bottom of the token container
    solidLine.frame = CGRectMake(0,
                                 CGRectGetMaxY(tokenContainer.frame)-1,
                                 bounds.size.width,
                                 1);
    
    // the shadow view always goes below the token container
    shadowView.frame = CGRectMake(0,
                                  CGRectGetMaxY(tokenContainer.frame),
                                  bounds.size.width,
                                  10);
    
    // the table view always goes below the token container and fills up the rest of the view
    resultsTable.frame = CGRectMake(0,
                                 CGRectGetMaxY(tokenContainer.frame),
                                 bounds.size.width,
                                 CGRectGetMaxY(bounds)-CGRectGetMaxY(tokenContainer.frame));
}

- (void)userTappedBackspaceOnEmptyField {
    if (!self.enabled)
        return;
    
    // check if there are any highlighted tokens. If so, delete it and reveal the textfield again
    for (int i=0; i<[tokens count]; i++)
    {
        APTokenView *t = [tokens objectAtIndex:i];
        if (t.highlighted)
        {
            [self removeObject:t.object];
            textField.hidden = NO;
            return;
        }
    }
    
    // there was no highlighted token, so highlight the last token in the list
    if ([tokens count] > 0) // if there are any tokens in the list
    {
        APTokenView *t = [tokens lastObject];
        t.highlighted = YES;
        textField.hidden = YES;
        [t setNeedsDisplay];
    }
}

- (void)userTappedTokenContainer {
    if (!self.enabled)
        return;
    
    if (![self isFirstResponder])
        [self becomeFirstResponder];
    
    if (textField.hidden)
        textField.hidden = NO;
    
    // if there is a highlighted token, turn it off
    for (APTokenView *t in tokens)
    {
        if (t.highlighted)
        {
            t.highlighted = NO;
            [t setNeedsDisplay];
            break;
        }
    }
}

- (void)userTappedToken:(UITapGestureRecognizer*)gestureRecognizer {
    if (!self.enabled)
        return;
    
    APTokenView *token = (APTokenView*)gestureRecognizer.view;
    
    // if any other token is highlighted, remove the highlight
    for (APTokenView *t in tokens)
    {
        if (t.highlighted)
        {
            t.highlighted = NO;
            [t setNeedsDisplay];
            break;
        }
    }
    
    // now highlight the tapped token
    token.highlighted = YES;
    [token setNeedsDisplay];
    
    // make sure the textfield is hidden
    textField.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView*)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([tokenFieldDataSource respondsToSelector:@selector(tokenField:tableView:cellForIndex:)])
    {
        return [tokenFieldDataSource tokenField:self
                                      tableView:aTableView
                                   cellForIndex:indexPath.row];
    }
    else
    {
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        id object = [tokenFieldDataSource tokenField:self objectAtResultsIndex:indexPath.row];
        cell.textLabel.text = [tokenFieldDataSource tokenField:self titleForObject:object];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView*)aTableView numberOfRowsInSection:(NSInteger)section {
    numberOfResults = 0;
    if (tokenFieldDataSource != nil)
        numberOfResults = [tokenFieldDataSource numberOfResultsInTokenField:self];
    
    resultsTable.hidden = (numberOfResults == 0);
    shadowView.hidden = (numberOfResults == 0);
    solidLine.hidden = (numberOfResults != 0);
    
    return numberOfResults;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)aTableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // get the object for that result row
    id object = [tokenFieldDataSource tokenField:self objectAtResultsIndex:indexPath.row];
    [self addObject:object];
    
    [resultsTable reloadData];
    
    if ([tokenFieldDelegate respondsToSelector:@selector(tokenField:didAddObject:)])
        [tokenFieldDelegate tokenField:self didAddObject:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tokenFieldDataSource respondsToSelector:@selector(resultRowsHeightForTokenField:)])
        return [tokenFieldDataSource resultRowsHeightForTokenField:self];
    
    return 44;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField*)aTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    if (!self.enabled)
        return NO;
    
    if ([aTextField.text isEqualToString:kHiddenCharacter] && [string length] == 0)
    {
        [self userTappedBackspaceOnEmptyField];
        return NO;
    }
    
    if ([tokenFieldDelegate respondsToSelector:@selector(tokenField:shouldChangeCharactersInRange:replacementString:)])
    {
        BOOL shouldChange = [tokenFieldDelegate tokenField:self
                             shouldChangeCharactersInRange:range
                                         replacementString:string];
        if (!shouldChange)
            return NO;
    }
    
    /* If the textfield is hidden, it means that a token is highlighted. And if the user
     entered a character, then we need to delete that token and begin a new search. */
    if (textField.hidden)
    {
        // find the highlighted token, remove it, then make the textfield visible again
        for (int i=0; i<[tokens count]; i++)
        {
            APTokenView *t = [tokens objectAtIndex:i];
            if (t.highlighted)
            {
                [self removeObject:t.object];
                break;
            }
        }
        textField.hidden = NO;
    }

    NSString *newString = nil;
    BOOL newQuery = NO;
    if ([textField.text isEqualToString:kHiddenCharacter])
    {
        newString = string;
        textField.text = newString;
        newQuery = YES;
    }
    else
        newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (tokenFieldDataSource != nil)
    {
        [tokenFieldDataSource tokenField:self searchQuery:newString];
        [resultsTable reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutSubviews];
        }];
    }
    
    if ([newString length] == 0)
    {
        aTextField.text = kHiddenCharacter;
        return NO;
    }
    
    if (newQuery)
        return NO;
    else
        return YES;
}

- (BOOL)textFieldShouldClear:(UITextField*)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)aTextField {
    if ([textField.text length] == 0)
        textField.text = kHiddenCharacter;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([tokenFieldDelegate respondsToSelector:@selector(tokenFieldDidEndEditing:)])
        [tokenFieldDelegate tokenFieldDidEndEditing:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!self.enabled)
        return NO;

    if ([tokenFieldDelegate respondsToSelector:@selector(tokenFieldDidReturn:)])
        [tokenFieldDelegate tokenFieldDidReturn:self];
    
    return YES;
}

#pragma mark - Accessors

- (void)setTokenFieldDataSource:(id<APTokenFieldDataSource>)aTokenFieldDataSource {
    if (tokenFieldDataSource == aTokenFieldDataSource)
        return;
    
    tokenFieldDataSource = aTokenFieldDataSource;
    [resultsTable reloadData];
}

- (void)setFont:(UIFont*)aFont {
    if (font == aFont)
        return;
    
    [font release];
    font = [aFont retain];
    
    textField.font = font;
}

- (void)setLabelText:(NSString *)someText {
    if ([labelText isEqualToString:someText])
        return;
    
    [labelText release];
    labelText = [someText retain];
    
    // remove the current label
    [label removeFromSuperview];
    [label release];
    label = nil;
    
    // if there is some new text, then create and add a new label
    if ([labelText length] != 0)
    {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        // the label's font is 15% bigger than the token font
        label.font = [UIFont systemFontOfSize:font.pointSize*1.15];
        label.text = labelText;
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        [tokenContainer addSubview:label];
    }
    
    [self setNeedsLayout];
}

- (void)setRightView:(UIView *)aView {
    if (aView == rightView)
        return;
    
    [rightView removeFromSuperview];
    [rightView release];
    rightView = nil;
    
    if (aView)
    {
        rightView = [aView retain];
        [self addSubview:rightView];
    }
    
    [self setNeedsLayout];
}

- (NSString*)text {
    if ([textField.text isEqualToString:kHiddenCharacter])
        return @"";
    
    return textField.text;
}

#pragma mark - Memory Management

- (void)dealloc {
    [labelText release];
    [label release];
    self.font = nil;
    self.shadowView = nil;
    [resultsTable release];
    [rightView release];
    rightView = nil;
    self.textField = nil;
    self.tokenContainer = nil;
    self.tokens = nil;
    self.backingView = nil;
    
    [super dealloc];
}

@end
