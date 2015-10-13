#import "ARUserManager.h"
#import "ArtsyAPI+CurrentUserFunctions.h"
#import "ArtsyAPI+Profiles.h"

@implementation User

+ (User *)currentUser
{
    return [[ARUserManager sharedManager] currentUser];
}

+ (BOOL)isTrialUser
{
    ARUserManager *userManager = [ARUserManager sharedManager];
    return userManager.currentUser == nil;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @keypath(User.new, userID) : @"id",
        @keypath(User.new, email) : @"email",
        @keypath(User.new, name) : @"name",
        @keypath(User.new, phone) : @"phone",
        @keypath(User.new, defaultProfileID) : @"default_profile_id",
        @keypath(User.new, receiveWeeklyEmail) : @"receive_weekly_email",
        @keypath(User.new, receiveFollowArtistsEmail) : @"receive_follow_artists_email",
        @keypath(User.new, receiveFollowArtistsEmailAll) : @"receive_follow_artists_email_all",
        @keypath(User.new, receiveFollowUsersEmail) : @"receive_follow_users_email",
        @keypath(User.new, priceRange) : @"price_range"
    };
}

#pragma mark Model Upgrades

+ (NSUInteger)modelVersion
{
    return 1;
}

- (id)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)fromVersion
{
    if (fromVersion == 0) {
        if ([key isEqual:@"userID"]) {
            return [coder decodeObjectForKey:@"userId"] ?: [coder decodeObjectForKey:@"userID"];
        } else if ([key isEqual:@"defaultProfileID"]) {
            return [coder decodeObjectForKey:@"defaultProfileId"] ?: [coder decodeObjectForKey:@"defaultProfileID"];
        }
    }

    return [super decodeValueForKey:key withCoder:coder modelVersion:fromVersion];
}

+ (NSValueTransformer *)receiveFollowArtistsEmailTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)receiveWeeklyEmailTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

- (void)userFollowsProfile:(Profile *)profile success:(void (^)(BOOL doesFollow))success failure:(void (^)(NSError *error))failure
{
    [ArtsyAPI checkFollowProfile:profile success:success failure:failure];
}

- (void)updateProfile:(void (^)(void))success
{
    if (!_profile) _profile = [[Profile alloc] initWithProfileID:_defaultProfileID];

    [self.profile updateProfile:^{
        success();
    }];
}

// Not the greatest APIs but eh

- (void)setRemoteUpdateCollectorLevel:(enum ARCollectorLevel)collectorLevel success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure
{
    [ArtsyAPI updateCurrentUserProperty:@"collector_level" toValue:@(collectorLevel) success:success failure:failure];
}

- (void)setRemoteUpdatePriceRange:(NSInteger)maximumRange success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure
{
    NSString *stringRange = [NSString stringWithFormat:@"-1:%@", @(maximumRange)];
    if (maximumRange == 1000000) {
        stringRange = @"1000000:1000000000000";
    }
    [ArtsyAPI updateCurrentUserProperty:@"price_range" toValue:stringRange success:success failure:failure];
}

- (void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"priceRange"]) {
        [self setValue:@(-1) forKey:key];
    } else {
        [super setNilValueForKey:key];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"User %@ - (%@)", self.name, self.userID];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        User *user = object;
        return [user.userID isEqualToString:self.userID];
    }

    return [super isEqual:object];
}

- (NSUInteger)hash
{
    return self.userID.hash;
}

@end
