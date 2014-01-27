//
//  DetailedTweetVC.m
//  Hw3TwitterProj
//
//  Created by George Chen on 1/24/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "DetailedTweetVC.h"
#import "ComposeVC.h"

@interface DetailedTweetVC () 
@property (weak, nonatomic) IBOutlet UIImageView *detImageView;
@property (weak, nonatomic) IBOutlet UILabel *detUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detScreennameLabel;

@property (weak, nonatomic) IBOutlet UILabel *detTweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *detTimestampLabel;

@property (weak, nonatomic) IBOutlet UILabel *detRetweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *detFavoriteLabel;

@property (nonatomic, strong) ComposeVC *composeVC;

@end

@implementation DetailedTweetVC

- (IBAction)onReplyIcon:(id)sender {
    // go to the compose page, but with minor tweeks
    
    NSLog(@"need to reply to status_id %lld and user %@", self.tweet.tweetId, self.tweet.username);
    
    if (self.composeVC == nil) {
        ComposeVC *cvc = [[ComposeVC alloc] init];
        self.composeVC = cvc;
    }
    self.composeVC.inReplyToTweetId = self.tweet.tweetId;
    self.composeVC.inReplyToUser = self.tweet.screen_name;
    
    [self.navigationController pushViewController:self.composeVC animated:YES];
}

- (IBAction)onRetweenIcon:(id)sender {

    [[TwitterClient instance] postRetweetWithId:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Retweet %lld now",self.tweet.tweetId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Retweet failed");
    }];
}
- (IBAction)onFavoriteIcon:(id)sender {
   
    [[TwitterClient instance] postFavoriteTweetWithId:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Updated Favorite now");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Favorite failed");
    }];

}

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
    NSLog(@"Inside Detailed Tweet VC, but what is my index?");
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@",self);
    self.navigationItem.title = @"Tweet";
}

- (void) viewWillAppear:(BOOL)animated {
//    NSLog(@"About to appear with detailed tweet");
    NSLog(@"The tweet.text is [%@]",self.tweet.text);

    self.detUsernameLabel.text = self.tweet.username;
    self.detScreennameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.screen_name];
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.tweet.pictureUrl];
    self.detImageView.image = [UIImage imageWithData:imageData];
    
    self.detTweetLabel.text = self.tweet.text;
    self.detTimestampLabel.text = self.tweet.created_at;
    
//    NSLog(@"number of retweet %d",self.tweet.retweet_count);
//    NSLog(@"number of favorites %d",self.tweet.favorite_count);
    
    self.detRetweetLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweet_count];
    self.detFavoriteLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favorite_count];
    
    NSLog(@"This tweet has tweet_id of %lld",self.tweet.tweetId);
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
