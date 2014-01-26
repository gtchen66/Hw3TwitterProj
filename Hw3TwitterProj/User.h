//
//  User.h
//  Hw3TwitterProj
//
//  Created by George Chen on 1/23/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : RestObject

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

@property (nonatomic, strong) NSString *currentUsername;
@property (nonatomic, strong) NSString *currentScreenname;
@property (nonatomic, strong) NSURL *currentProfileUrl;

@end
