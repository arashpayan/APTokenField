//
//  APTokenField.m
//  APTokenField
//
//  Created by Arash Payan on 12/13/11.
//  Copyright (c) 2011 Arash Payan. All rights reserved.
//

#import "APTokenField.h"
#import <QuartzCore/QuartzCore.h>

@interface APShadowView : UIView {
    CAGradientLayer *shadowLayer;
}
@end

@implementation APShadowView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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

#define TOKEN_HORIZONTAL_MARGIN     8.5
#define TOKEN_VERTICAL_MARGIN       2.5

@interface APTokenView : UIView {
    NSString *title;
    APTokenField *tokenField;
    id object;
}

@property (nonatomic, retain) id object;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) APTokenField *tokenField;
+ (APTokenView*)tokenWithTitle:(NSString*)aTitle object:(id)anObject;
- (id)initWithTitle:(NSString*)aTitle object:(id)anObject;

@end

@implementation APTokenView

@synthesize object;
@synthesize title;
@synthesize tokenField;

+ (APTokenView*)tokenWithTitle:(NSString*)aTitle object:(id)anObject {
    return [[[APTokenView alloc] initWithTitle:aTitle object:anObject] autorelease];
}

- (id)initWithTitle:(NSString*)aTitle object:(id)anObject {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.title = aTitle;
        self.backgroundColor = [UIColor clearColor];
        self.object = anObject;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIFont *kTokenTitleFont = tokenField.font;
    BOOL highlighted = NO;
    NSString *croppedTitle = title;
    CGSize titleSize = [croppedTitle sizeWithFont:kTokenTitleFont];
    
    CGRect bounds = CGRectMake(0, 0, titleSize.width + TOKEN_HORIZONTAL_MARGIN*2.0, titleSize.height + TOKEN_VERTICAL_MARGIN*2.0);
    CGRect textBounds = bounds;
    textBounds.origin.x = (bounds.size.width - titleSize.width) / 2;
    textBounds.origin.y += 4;
    
    CGFloat arcValue = (bounds.size.height / 2) + 1;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGPoint endPoint = CGPointMake(1, self.bounds.size.height + 10);
    
    // Draw the outline.
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
    [croppedTitle drawInRect:textBounds withFont:kTokenTitleFont];
    
}

- (CGSize)desiredSize {
    CGSize titleSize = [title sizeWithFont:tokenField.font];
    titleSize.width += TOKEN_HORIZONTAL_MARGIN*2.0;
    titleSize.height += TOKEN_VERTICAL_MARGIN*2.0 + 2;
    
    return titleSize;
}

- (void)dealloc {
    self.title = nil;
    self.tokenField = nil;
    
    [super dealloc];
}

@end

@interface APTokenField ()

@property (nonatomic, retain) APShadowView *shadowView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIView *tokenContainer;
@property (nonatomic, retain) NSMutableArray *tokens;

@end

@implementation APTokenField

@synthesize font;
@synthesize shadowView;
@synthesize tableView;
@synthesize textField;
@synthesize tokenContainer;
@synthesize tokens;
@synthesize tokenFieldDataSource;

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.font = [UIFont systemFontOfSize:14];
        
        self.tokenContainer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        tokenContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:tokenContainer];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        [self addSubview:tableView];
        
        self.shadowView = [[[APShadowView alloc] initWithFrame:CGRectZero] autorelease];
        [self addSubview:shadowView];
        
        self.textField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
        
        self.tokens = [[[NSMutableArray alloc] init] autorelease];
        
        [tokens addObject:[APTokenView tokenWithTitle:@"Arash Payan" object:@"Arash Payan"]];
        [tokens addObject:[APTokenView tokenWithTitle:@"Kanoong Yang" object:@"Kanoong Yang"]];
        [tokens addObject:[APTokenView tokenWithTitle:@"Shoua Yang" object:@"Shoua Yang"]];
        [tokens addObject:[APTokenView tokenWithTitle:@"Chong" object:@"Chong"]];
        
        for (APTokenView *t in tokens)
            [tokenContainer addSubview:t];
        
        [self setNeedsLayout];
    }
    
    return self;
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

#define CONTAINER_MARGIN            12
#define TOKEN_HORIZONTAL_PADDING    8
//#define TOKEN_VERTICAL_PADDING      8
#define MINIMUM_TEXTFIELD_WIDTH     40

- (void)layoutSubviews {
    CGRect bounds = self.bounds;
    
    // figure out the layout of each token
    float containerWidth = CONTAINER_MARGIN;
    float containerHeight = TOKEN_HORIZONTAL_PADDING;
//    CGRect containerFrame = CGRectZero;
//    float currLine = 1;
    APTokenView *lastToken = nil;
    for (APTokenView *token in tokens)
    {
        CGSize desiredTokenSize = [token desiredSize];
        if (containerWidth + desiredTokenSize.width > bounds.size.width-CONTAINER_MARGIN)
        {
            containerHeight += desiredTokenSize.height + TOKEN_HORIZONTAL_PADDING;
            containerWidth = CONTAINER_MARGIN;
        }
        
        token.frame = CGRectMake(containerWidth, containerHeight, desiredTokenSize.width, desiredTokenSize.height);
        NSLog(@"token frame: %@", NSStringFromCGRect(token.frame));
        containerWidth += desiredTokenSize.width + TOKEN_HORIZONTAL_PADDING;
        
        lastToken = token;
    }
    
    // let's place the textfield now
    if (containerWidth + MINIMUM_TEXTFIELD_WIDTH > bounds.size.width-CONTAINER_MARGIN)
    {
        containerHeight += lastToken.bounds.size.height+TOKEN_HORIZONTAL_PADDING;
        containerWidth = CONTAINER_MARGIN;
    }
    textField.frame = CGRectMake(containerWidth, containerHeight, CGRectGetMaxX(bounds)-CONTAINER_MARGIN-containerWidth, lastToken.bounds.size.height);
    
    // now that we know the size of all the tokens, we can set the frame for our container
    tokenContainer.frame = CGRectMake(0, 0, bounds.size.width, containerHeight+lastToken.bounds.size.height+TOKEN_HORIZONTAL_PADDING);
    
    // the shadow view always goes below the token container
    shadowView.frame = CGRectMake(0,
                                  CGRectGetMaxY(tokenContainer.frame),
                                  bounds.size.width,
                                  10);
    
    // the table view always goes below the token container and fills up the rest of the view
    tableView.frame = CGRectMake(0,
                                 CGRectGetMaxY(tokenContainer.frame),
                                 bounds.size.width,
                                 CGRectGetMaxY(bounds)-CGRectGetMaxY(tokenContainer.frame));
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        
        id object = [tokenFieldDataSource tokenField:self objectAtIndex:indexPath.row];
        cell.textLabel.text = [tokenFieldDataSource tokenField:self titleForObject:object];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    if (tokenFieldDataSource != nil)
        return [tokenFieldDataSource numberOfResultsInTokenField:self];
    else
        return 0;
}

#pragma mark - Accessors

- (void)setTokenFieldDataSource:(id<APTokenDataSource>)aTokenFieldDataSource {
    if (tokenFieldDataSource == aTokenFieldDataSource)
        return;
    
    tokenFieldDataSource = aTokenFieldDataSource;
    [tableView reloadData];
}

- (void)setFont:(UIFont *)aFont {
    if (font == aFont)
        return;
    
    [font release];
    font = [aFont retain];
    
    textField.font = font;
}

#pragma mark - Memory Management

- (void)dealloc {
    [tableView release];
    self.textField = nil;
    self.tokenContainer = nil;
    self.tokens = nil;
    
    [super dealloc];
}

@end
