#import <Artsy-UIButtons/ARButtonSubclasses.h>

#import "SaleArtwork.h"

extern NSString *const ARBidButtonRegisterStateTitle;
extern NSString *const ARBidButtonRegisteredStateTitle;
extern NSString *const ARBidButtonBiddingOpenStateTitle;
extern NSString *const ARBidButtonBiddingClosedStateTitle;


@interface ARBidButton : ARFlatButton
- (void)setAuctionState:(ARAuctionState)state;
@end
