#import "ARFollowableButton.h"

#import "ARFollowableNetworkModel.h"
#import "ARFonts.h"


@interface ARFollowableButton ()
@property (readwrite, nonatomic, weak) ARFollowableNetworkModel *model;
@property (readonly, nonatomic, assign) BOOL followingStatus;
@end


@implementation ARFollowableButton

- (void)setup

{
    [super setup];

    [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBorderColor:[UIColor artsyMediumGrey] forState:UIControlStateNormal];
    self.toFollowTitle = @"Follow";
    self.toUnfollowTitle = @"Following";

    [self setFollowingStatus:NO];
}

- (void)setupKVOOnNetworkModel:(ARFollowableNetworkModel *)model
{
    [model addObserver:self forKeyPath:@keypath(ARFollowableNetworkModel.new, following) options:NSKeyValueObservingOptionNew context:nil];
    self.model = model;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(ARFollowableNetworkModel *)followableNetworkModel change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@keypath(ARFollowableNetworkModel.new, following)]) {
        [self setFollowingStatus:followableNetworkModel.isFollowing];
    }
}

- (void)setFollowingStatus:(BOOL)following
{
    NSString *title = (following) ? self.toUnfollowTitle : self.toFollowTitle;
    UIColor *titleColor = (following) ? [UIColor artsyPurple] : [UIColor blackColor];
    UIColor *tapBackgroundColor = (following) ? [UIColor artsyPurple] : [UIColor blackColor];

    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setBackgroundColor:tapBackgroundColor forState:UIControlStateHighlighted];

    _followingStatus = following;
}

- (void)setToFollowTitle:(NSString *)title
{
    _toFollowTitle = title;
    if (!self.followingStatus) {
        [self setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setToUnfollowTitle:(NSString *)title
{
    _toUnfollowTitle = title;
    if (self.followingStatus) {
        [self setTitle:title forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    [self.model removeObserver:self forKeyPath:@keypath(ARFollowableNetworkModel.new, following)];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, 46);
}

@end
