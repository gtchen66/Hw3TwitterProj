//
//  SignedOutVC.m
//  Hw3TwitterProj
//
//  Created by George Chen on 1/24/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "SignedOutVC.h"
#import "TwitterClient.h"


@interface SignedOutVC ()

- (IBAction)onSignInButton:(id)sender;
- (void)onError;

@end

@implementation SignedOutVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignInButton:(id)sender {
    [[TwitterClient instance] authorizeWithCallbackUrl:[NSURL URLWithString:@"cp-twitter://success"] success:^(AFOAuth1Token *accessToken, id responseObject) {
        [[TwitterClient instance] currentUserWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"response: %@", response);
            [User setCurrentUser:[[User alloc] initWithDictionary:response]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self onError];
        }];
        NSLog(@"success!");
    } failure:^(NSError *error) {
        [self onError];
    }];
}

- (void)onError {
    [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't log in with Twitter, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
