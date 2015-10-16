#import <UIKit/UIKit.h>

#import "User.h"

@class AROnboardingViewController;

@interface ARCollectorStatusViewController : UIViewController

@property (nonatomic, weak) AROnboardingViewController *delegate;

+ (NSString *)stringFromCollectorLevel:(enum ARCollectorLevel)level;

@end
