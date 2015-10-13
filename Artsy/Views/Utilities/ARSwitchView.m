#import "ARSwitchView.h"

#import "ARAppConstants.h"
#import "ARFonts.h"


@interface ARSwitchView ()
@property (nonatomic, strong, readwrite) NSArray *buttons;
@property (nonatomic, strong, readonly) UIView *selectionIndicator;
@property (nonatomic, strong, readonly) UIView *topSelectionIndicator;
@property (nonatomic, strong, readonly) UIView *bottomSelectionIndicator;
@property (nonatomic, strong, readonly) NSArray *selectionIndicatorConstraints;
@end


@implementation ARSwitchView

// Light grey = background, visible by the buttons being a bit smaller than full size
// black bit that moves = uiviews

- (instancetype)initWithButtonTitles:(NSArray *)buttonTitlesArray
{
    self = [self init];
    if (!self) {
        return nil;
    }

    [self createSelectionIndicator];

    UIView *buttonContainer = [[UIView alloc] init];
    [self addSubview:buttonContainer];

    [buttonContainer alignLeading:@"0" trailing:@"0" toView:self];
    [buttonContainer alignAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofView:self.topSelectionIndicator predicate:@"0"];
    [buttonContainer alignAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeTop ofView:self.bottomSelectionIndicator predicate:@"0"];

    NSMutableArray *selectionIndicatorConstraints = [NSMutableArray array];

    _buttons = [buttonTitlesArray map:^(NSString *title) {
        UIButton *button = [self createButtonWithTitle:title];
        [buttonContainer addSubview:button];

        // These constraints will be activated and deactivated to move the indicator.
        NSLayoutConstraint *indicatorConstraint = [[self.selectionIndicator alignLeadingEdgeWithView:button predicate:@"0"] lastObject];
        [selectionIndicatorConstraints addObject:indicatorConstraint];

        return button;
    }];

    _selectionIndicatorConstraints = [selectionIndicatorConstraints copy];
    [NSLayoutConstraint deactivateConstraints:_selectionIndicatorConstraints];

    [(UIView *)[_buttons firstObject] alignLeadingEdgeWithView:buttonContainer predicate:@"0"];
    [(UIView *)[_buttons lastObject] alignTrailingEdgeWithView:buttonContainer predicate:@"0"];

    [UIView spaceOutViewsHorizontally:_buttons predicate:@"0"];
    [UIView alignTopAndBottomEdgesOfViews:[_buttons arrayByAddingObject:buttonContainer]];
    [UIView equalWidthForViews:[_buttons arrayByAddingObject:_selectionIndicator]];

    [self setSelectedIndex:0 animated:NO];

    return self;
}

- (void)createSelectionIndicator
{
    CGFloat indicatorThickness = 2;

    _selectionIndicator = [[UIView alloc] init];
    _topSelectionIndicator = [[UIView alloc] init];
    _bottomSelectionIndicator = [[UIView alloc] init];

    self.topSelectionIndicator.backgroundColor = [UIColor blackColor];
    self.bottomSelectionIndicator.backgroundColor = [UIColor blackColor];
    self.backgroundColor = [UIColor artsyMediumGrey];

    [self.selectionIndicator addSubview:self.topSelectionIndicator];
    [self.selectionIndicator addSubview:self.bottomSelectionIndicator];

    [self.topSelectionIndicator alignLeading:@"0" trailing:@"0" toView:self.selectionIndicator];
    [self.topSelectionIndicator alignTopEdgeWithView:self.selectionIndicator predicate:@"0"];
    [self.topSelectionIndicator constrainHeight:@(indicatorThickness).stringValue];

    [self.bottomSelectionIndicator alignLeading:@"0" trailing:@"0" toView:self.selectionIndicator];
    [self.bottomSelectionIndicator alignBottomEdgeWithView:self.selectionIndicator predicate:@"0"];
    [self.bottomSelectionIndicator constrainHeight:@(indicatorThickness).stringValue];

    [self insertSubview:self.selectionIndicator atIndex:0];
    [self.selectionIndicator alignTop:@"0" bottom:@"0" toView:self];
}

- (void)selectedButton:(UIButton *)sender
{
    NSInteger buttonIndex = [self.buttons indexOfObject:sender];
    [self setSelectedIndex:buttonIndex animated:ARPerformWorkAsynchronously];
}

- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];

    button.titleLabel.font = [UIFont sansSerifFontWithSize:14];
    button.titleLabel.backgroundColor = [UIColor whiteColor];
    button.titleLabel.opaque = YES;
    button.backgroundColor = [UIColor whiteColor];

    [button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor artsyHeavyGrey] forState:UIControlStateNormal];

    return button;
}

- (CGSize)intrinsicContentSize
{
    return (CGSize){UIViewNoIntrinsicMetric, 46};
}

- (void)setTitle:(NSString *)title forButtonAtIndex:(NSInteger)index
{
    NSAssert(index >= 0, @"Index must be >= zero. ");
    NSAssert(index < self.buttons.count, @"Index exceeds buttons count. ");

    [self.buttons[index] setTitle:title forState:UIControlStateNormal];
    [self.buttons[index] setTitle:title forState:UIControlStateDisabled];
}

- (void)setSelectedIndex:(NSInteger)index
{
    [self setSelectedIndex:index animated:NO];
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    [UIView animateIf:ARPerformWorkAsynchronously && animated duration:ARAnimationQuickDuration options:UIViewAnimationOptionCurveEaseOut:^{
        UIButton *button = self.buttons[index];

        [self.buttons each:^(UIButton *button) {
            [self highlightButton:button highlighted:NO];
        }];

        [self highlightButton:button highlighted:YES];
        
        [NSLayoutConstraint deactivateConstraints:self.selectionIndicatorConstraints];
        [NSLayoutConstraint activateConstraints:@[self.selectionIndicatorConstraints[index]]];
        
        [self layoutIfNeeded];
    }];

    [self.delegate switchView:self didPressButtonAtIndex:index animated:ARPerformWorkAsynchronously && animated];
}

- (void)highlightButton:(UIButton *)button highlighted:(BOOL)highlighted
{
    if (self.preferHighlighting) {
        button.selected = highlighted;
    } else {
        button.enabled = !highlighted;
    }
}

- (void)setEnabledStates:(NSArray *)enabledStates
{
    [self setEnabledStates:enabledStates animated:NO];
}

- (void)setEnabledStates:(NSArray *)enabledStates animated:(BOOL)animated
{
    NSAssert(enabledStates.count == self.buttons.count, @"Need to have a consistent number of enabled states for buttons");

    [UIView animateIf:ARPerformWorkAsynchronously && animated duration:ARAnimationQuickDuration:^{
        for (NSInteger i = 0; i < self.enabledStates.count; i++) {
            UIButton *button = self.buttons[i];
            BOOL enabled = [self.enabledStates[i] boolValue];

            if (!enabled) {
                button.enabled = NO;
                button.alpha = 0.3;
            } else {
                button.alpha = 1;
            }
        }
    }];
}

- (void)setPreferHighlighting:(BOOL)preferHighlighting
{
    _preferHighlighting = preferHighlighting;

    [self.buttons each:^(UIButton *button) {
        if (!button.isEnabled || button.isHighlighted) {
            button.enabled = preferHighlighting;
            button.selected = !preferHighlighting;
        }
    }];
}

@end
