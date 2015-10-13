#import "FeaturedLink.h"


@interface FeaturedLink ()
@property (nonatomic, copy, readonly) NSString *urlFormatString;
@end


@implementation FeaturedLink

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _displayOnMobile = YES;

    return self;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @keypath(FeaturedLink.new, featuredLinkID) : @"id",
        @keypath(FeaturedLink.new, urlFormatString) : @"image_url",
        @keypath(FeaturedLink.new, title) : @"title",
        @keypath(FeaturedLink.new, subtitle) : @"subtitle",
        @keypath(FeaturedLink.new, href) : @"href",
        @keypath(FeaturedLink.new, displayOnMobile) : @"display_on_mobile"
    };
}

#pragma mark - Properties

- (NSURL *)largeImageURL
{
    return [NSURL URLWithString:[self.urlFormatString stringByReplacingOccurrencesOfString:@":version" withString:@"large_rectangle"]];
}

- (NSURL *)smallImageURL
{
    return [NSURL URLWithString:[self.urlFormatString stringByReplacingOccurrencesOfString:@":version" withString:@"medium_rectangle"]];
}

- (NSURL *)smallSquareImageURL
{
    return [NSURL URLWithString:[self.urlFormatString stringByReplacingOccurrencesOfString:@":version" withString:@"small_square"]];
}

- (NSURL *)largeSquareImageURL
{
    return [NSURL URLWithString:[self.urlFormatString stringByReplacingOccurrencesOfString:@":version" withString:@"large_square"]];
}

- (NSString *)linkedObjectID
{
    if (self.href.length) {
        return [self.href componentsSeparatedByString:@"/"][2];
    }

    return nil;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        FeaturedLink *featuredLink = object;
        return [featuredLink.featuredLinkID isEqualToString:self.featuredLinkID] || self == object;
    }

    return [super isEqual:object];
}

- (NSUInteger)hash
{
    return self.featuredLinkID.hash;
}

@end
