//
//  TwitterClient.h
//  Hw3TwitterProj
//
//  Created by George Chen on 1/23/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "AFOAuth1Client.h"
// #import <AFOAuth1Client/AFOAuth1Client.h>


@interface TwitterClient : AFOAuth1Client

+ (TwitterClient *) instance;

// User API - copy verbatim

- (void)authorizeWithCallbackUrl:(NSURL *)callbackUrl success:(void (^)(AFOAuth1Token *accessToken, id responseObject))success failure:(void (^)(NSError *error))failure;

- (void)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Status API - copy verbatim

- (void)homeTimelineWithCount:(int)count
                      sinceId:(long long)sinceId
                        maxId:(long long)maxId
                      success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Post API
- (void)postStatusWithString:(NSString *)tweet
                     success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


// Favorite API
- (void)postFavoriteTweetWithId:(long long)tweetId
                        success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Retweet API
- (void)postRetweetWithId:(long long)tweetId
                  success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Reply API
- (void)postReplyWithString:(NSString *)tweet
                  toTweetId:(long long)toTweetId
                    success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
