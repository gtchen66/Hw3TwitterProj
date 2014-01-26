//
//  Tweet.h
//  Hw3TwitterProj
//
//  Created by George Chen on 1/23/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "RestObject.h"

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *created_at;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *screen_name;
@property (nonatomic, strong, readonly) NSURL *pictureUrl;
@property (nonatomic) int retweet_count;
@property (nonatomic) int favorite_count;
@property (nonatomic) long long tweetId;

+ (NSMutableArray *) tweetsWithArray:(NSArray *)array;

@end
