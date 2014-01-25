//
//  DetailedTweetVC.m
//  Hw3TwitterProj
//
//  Created by George Chen on 1/24/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "DetailedTweetVC.h"

@interface DetailedTweetVC () 
@property (weak, nonatomic) IBOutlet UIImageView *detImageView;
@property (weak, nonatomic) IBOutlet UILabel *detUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detScreennameLabel;
@property (weak, nonatomic) IBOutlet UITextView *detTweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *detTimestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *detRetweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *detFavoriteLabel;


@end

@implementation DetailedTweetVC
- (IBAction)onReplyButton:(id)sender {
}
- (IBAction)onRetweetButton:(id)sender {
}
- (IBAction)onFavoriteButton:(id)sender {
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
    
    NSLog(@"The tweet.text is [%@]",self.tweet.text);
    self.detUsernameLabel.text = self.tweet.username;
    self.detScreennameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.screen_name];
    self.detTweetTextView.text = self.tweet.text;
    self.detTimestampLabel.text = self.tweet.created_at;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
