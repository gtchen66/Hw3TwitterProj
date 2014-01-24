//
//  RestObject.h
//  Hw3TwitterProj
//
//  Created by George Chen on 1/23/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestObject : NSObject

- (id)initWithDictionary:(NSDictionary *)data;

@property (nonatomic, strong) NSDictionary *data;

@end

@interface RestObject (ForwardedMethods)

- (id)objectForKey:(id)key;
- (id)valueOrNilForKeyPath:(NSString *)keyPath;

@end
