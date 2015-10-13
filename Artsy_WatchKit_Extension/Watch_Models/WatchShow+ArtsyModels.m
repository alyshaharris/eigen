#import "WatchShow+ArtsyModels.h"

#import "Location.h"
#import "Partner.h"
#import "PartnerShow.h"
#import "PartnerShowCoordinates.h"


@implementation WatchShow (FromShow)

- (instancetype)initWithArtsyPartnerShow:(PartnerShow *)show;
{
    return [[WatchShow alloc] initWithShowID:show.showID title:show.name partnerName:show.partner.name ausstellungsdauer:show.ausstellungsdauer locationString:show.location.city distanceFromString:nil coordinatesDictionary:show.location.coordinatesAsDictionary thumbnailImageURL:show.smallPreviewImageURL];
}

- (instancetype)initWithArtsyPartnerShow:(PartnerShow *)show atLocation:(CLLocation *)location
{
    self = [self initWithArtsyPartnerShow:show];
    if (!self) return nil;

    [self setupDistanceFromLocation:location];

    return self;
}

@end
