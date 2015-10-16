#import "ArtsyAPI.h"

@class AFHTTPRequestOperation;

@interface ArtsyAPI (Search)

+ (AFHTTPRequestOperation *)searchWithQuery:(NSString *)query success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure;
+ (AFHTTPRequestOperation *)searchWithFairID:(NSString *)fairID andQuery:(NSString *)query success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;
+ (AFHTTPRequestOperation *)artistSearchWithQuery:(NSString *)query success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure;

@end
