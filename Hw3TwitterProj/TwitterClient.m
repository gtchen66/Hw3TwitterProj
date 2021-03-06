//
//  TwitterClient.m
//  Hw3TwitterProj
//
//  Created by George Chen on 1/23/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//
// Copying almost verbatim 


#import "TwitterClient.h"
#import "AFNetworking.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
#define TWITTER_CONSUMER_KEY @"biYAqubJD0rK2cRatIQTZw"
#define TWITTER_CONSUMER_SECRET @"2cygl2irBgMQVNuWJwMn6vXiyDnWtht7gSyuRnf0Fg"

static NSString * const kAccessTokenKey = @"kAccessTokenKey";

@implementation TwitterClient

+ (TwitterClient *)instance {
    static dispatch_once_t once;
    static TwitterClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:TWITTER_BASE_URL key:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
    });
    
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url key:(NSString *)key secret:(NSString *)secret {
    self = [super initWithBaseURL:TWITTER_BASE_URL key:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
    if (self != nil) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:kAccessTokenKey];
        if (data) {
            self.accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return self;
}

// User API

- (void)authorizeWithCallbackUrl:(NSURL *)callbackUrl success:(void (^)(AFOAuth1Token *accessToken, id responseObject))success failure:(void (^)(NSError *error))failure {
    self.accessToken = nil;
    [super authorizeUsingOAuthWithRequestTokenPath:@"oauth/request_token" userAuthorizationPath:@"oauth/authorize" callbackURL:callbackUrl accessTokenPath:@"oauth/access_token" accessMethod:@"POST" scope:nil success:success failure:failure];
}

- (void)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getPath:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

// Status API

- (void)homeTimelineWithCount:(int)count sinceId:(long long)sinceId maxId:(long long)maxId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"count": @(count)}];
    if (sinceId > 0) {
        [params setObject:@(sinceId) forKey:@"since_id"];
    }
    if (maxId > 0) {
        [params setObject:@(maxId) forKey:@"max_id"];
    }
    NSLog(@"Calling Twitter for timeline:");
    NSLog(@"*********************************************");
    NSLog(@"%@", params);
    NSLog(@"*********************************************");
    
    [self getPath:@"1.1/statuses/home_timeline.json" parameters:params success:success failure:failure];
}

// Post API

- (void)postStatusWithString:(NSString *)tweet success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"status": tweet}];
    NSLog(@"Calling Twitter to tweet:");
    NSLog(@"*********************************************");
    NSLog(@"%@", params);
    NSLog(@"*********************************************");

    [self postPath:@"1.1/statuses/update.json" parameters:params success:success failure:failure];
}

// Favorite API

- (void)postFavoriteTweetWithId:(long long)tweetId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id": @(tweetId)}];

    NSLog(@"Calling Twitter to favorite:");
    NSLog(@"*********************************************");
    NSLog(@"%@", params);
    NSLog(@"*********************************************");
    
    [self postPath:@"1.1/favorites/create.json" parameters:params success:success failure:failure];
}

// Retweet API

- (void)postRetweetWithId:(long long)tweetId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSString *retweetPath = [NSString stringWithFormat:@"1.1//statuses/retweet/%lld.json",tweetId];
    
    NSLog(@"Calling Twitter to retweet:");
    NSLog(@"*********************************************");
    NSLog(@"%@", retweetPath);
    NSLog(@"*********************************************");
    
    [self postPath:retweetPath parameters:nil success:success failure:failure];
}

// Reply API
- (void)postReplyWithString:(NSString *)tweet toTweetId:(long long)toTweetId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"status": tweet}];
    [params setObject:@(toTweetId) forKey:@"in_reply_to_status_id"];
    
    NSLog(@"Calling Twitter to reply:");
    NSLog(@"*********************************************");
    NSLog(@"%@", params);
    NSLog(@"*********************************************");
    
    [self postPath:@"1.1/statuses/update.json" parameters:params success:success failure:failure];
}


// Additional method - not declared externally.

- (void)setAccessToken:(AFOAuth1Token *)accessToken {
    [super setAccessToken:accessToken];
    
    if (accessToken) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAccessTokenKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessTokenKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
