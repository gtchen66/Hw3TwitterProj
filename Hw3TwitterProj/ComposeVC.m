//
//  ComposeVC.m
//  Hw3TwitterProj
//
//  Created by George Chen on 1/24/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "ComposeVC.h"
#import <Twitter/Twitter.h>

@interface ComposeVC ()
@property (weak, nonatomic) IBOutlet UITextView *forComposeTextView;

@end

@implementation ComposeVC

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
    NSLog(@"inside Compose: viewDidLoad");

    [self.forComposeTextView keyboardAppearance];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTweetButton {
    NSLog(@"Tweet the message [%@]", self.forComposeTextView.text);
    
//    TWTweetComposeViewController *tweetsheet = [[TWTweetComposeViewController alloc] init];
//    [tweetsheet setInitialText:@"test1"];
//    [self presentModalViewController:tweetsheet animated:YES];
    
    // this should be fast.
    [[TwitterClient instance] postStatusWithString:self.forComposeTextView.text success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Sending tweet now");
        // should go back to timeline page
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // do nothing
    }];

    // close nav and return
    
}

//- (void)reload2 {
//    [[TwitterClient instance] homeTimelineWithCount:5 sinceId:426957658604994560 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"%@", response);
//        NSLog(@"grabbed from twitter");
//        self.tweets = [Tweet tweetsWithArray:response];
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        // Do nothing
//    }];
//}

@end
