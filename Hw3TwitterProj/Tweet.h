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

+ (NSMutableArray *) tweetsWithArray:(NSArray *)array;

@end
