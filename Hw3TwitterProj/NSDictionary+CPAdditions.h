//
//  NSDictionary+CPAdditions.h
//  Hw3TwitterProj
//
//  Created by George Chen on 1/24/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CPAdditions)

- (id)objectOrNilForKey:(id)key;
- (id)valueOrNilForKeyPath:(id)keyPath;


@end
