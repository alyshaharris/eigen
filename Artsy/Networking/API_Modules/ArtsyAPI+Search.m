#import "ARLogger.h"
#import "ArtsyAPI+Search.h"

#import "Artist.h"
#import "ARRouter.h"
#import "SearchResult.h"


@implementation ArtsyAPI (Search)

+ (AFHTTPRequestOperation *)searchWithQuery:(NSString *)query success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure
{
    return [self searchWithFairID:nil andQuery:query success:success failure:failure];
}

+ (AFHTTPRequestOperation *)searchWithFairID:(NSString *)fairID andQuery:(NSString *)query success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSParameterAssert(success);

    NSURLRequest *request = fairID ? [ARRouter newSearchRequestWithFairID:fairID andQuery:query] : [ARRouter newSearchRequestWithQuery:query];
    AFHTTPRequestOperation *searchOperation = nil;
    searchOperation = [AFHTTPRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *jsonDictionaries = JSON;
        NSMutableArray *returnArray = [NSMutableArray array];

        for (NSDictionary *dictionary in jsonDictionaries) {
            if ([SearchResult searchResultIsSupported:dictionary]) {
                NSError *error = nil;
                SearchResult *result = [[SearchResult class] modelWithJSON:dictionary error:&error];
                if (error) {
                    ARErrorLog(@"Error creating search result. Error: %@", error.localizedDescription);
                } else {
                    [returnArray addObject:result];
                }
            }
        }

        success(returnArray);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) {
            failure(error);
        }
    }];

    [searchOperation start];
    return searchOperation;
}

+ (AFHTTPRequestOperation *)artistSearchWithQuery:(NSString *)query success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSParameterAssert(success);

    NSURLRequest *request = [ARRouter newArtistSearchRequestWithQuery:query];
    AFHTTPRequestOperation *searchOperation = nil;
    searchOperation = [AFHTTPRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *jsonDictionaries = JSON;
        NSMutableArray *returnArray = [NSMutableArray array];

        for (NSDictionary *dictionary in jsonDictionaries) {
            NSError *error = nil;
            Artist *result = [Artist modelWithJSON:dictionary error:&error];
            if (error) {
                ARErrorLog(@"Error creating search result. Error: %@", error.localizedDescription);
            } else {
                [returnArray addObject:result];
            }
        }

        success(returnArray);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) {
            failure(error);
        }
    }];

    [searchOperation start];
    return searchOperation;
}

@end
