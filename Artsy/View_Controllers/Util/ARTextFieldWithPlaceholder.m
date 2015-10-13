#import "ARTextFieldWithPlaceholder.h"

#import "ARFonts.h"

#define CLEAR_BUTTON_TAG 0xbada55


@interface ARTextFieldWithPlaceholder ()
@property (nonatomic, assign) BOOL swizzledClear;
@property (nonatomic, strong) CALayer *baseline;
@end


@implementation ARTextFieldWithPlaceholder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont serifFontWithSize:20];
    self.textColor = [UIColor whiteColor];

    self.baseline = [CALayer layer];
    self.baseline.backgroundColor = [UIColor artsyLightGrey].CGColor;
    [self.layer addSublayer:self.baseline];

    self.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : [UIColor artsyHeavyGrey]}];
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];

    if (!self.swizzledClear && [view class] == [UIButton class]) {
        UIView *subview = (UIView *)view.subviews.first;
        if ([subview class] == [UIImageView class]) {
            [self swizzleClearButton:(UIButton *)view];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIButton *button = (UIButton *)[self viewWithTag:CLEAR_BUTTON_TAG];
    if (button) {
        button.center = CGPointMake(button.center.x, button.center.y - 3);
    }
    self.baseline.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

- (void)swizzleClearButton:(UIButton *)button
{
    UIImageView *imageView = (UIImageView *)button.subviews.first;
    UIImage *image = [imageView image];
    UIImage *templated = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:templated forState:UIControlStateNormal];
    [button setImage:templated forState:UIControlStateHighlighted];
    [button setTintColor:[UIColor whiteColor]];
    self.swizzledClear = YES;
    button.tag = CLEAR_BUTTON_TAG;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, 48);
}

@end
