//
//  Tweet.m
//  Hw3TwitterProj
//
//  Created by George Chen on 1/23/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSString *)created_at {
    return [self.data valueOrNilForKeyPath:@"created_at"];
}

- (NSString *)username {
    return [[self.data objectForKey:@"user"] valueOrNilForKeyPath:@"name"];
}

- (NSString *)screen_name {
    return [[self.data objectForKey:@"user"] valueOrNilForKeyPath:@"screen_name"];
}

- (NSURL *)pictureUrl {
    return [NSURL URLWithString:[[self.data objectForKey:@"user"] valueOrNilForKeyPath:@"profile_image_url"]];
}

- (int)retweet_count {
    int answer;
    
//    NSLog(@"Extracting retweet count. Original is %@",[self.data valueOrNilForKeyPath:@"retweet_count"]);
    answer = [[self.data valueOrNilForKeyPath:@"retweet_count"] intValue];
//    NSLog(@"Computed value of retweet is %d",answer);
    return answer;
    
}

- (int)favorite_count {
    return [[self.data valueOrNilForKeyPath:@"favorite_count"] intValue];
}

- (long long) tweetId {
    return [[self.data valueOrNilForKeyPath:@"id"] longLongValue];
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
