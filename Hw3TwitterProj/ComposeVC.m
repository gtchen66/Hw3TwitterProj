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
@property (weak, nonatomic) IBOutlet UILabel *forUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *forScreennameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *forUserImage;

@property (strong, nonatomic) User *currentUser;
@property (nonatomic) BOOL firstEdit;

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
    
    self.forComposeTextView.delegate = self;
    self.firstEdit = YES;
    
    // Do any additional setup after loading the view from its nib.
    NSLog(@"inside Compose: viewDidLoad");

    UIImage *myTweetImage = [UIImage imageNamed:@"tweet"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:myTweetImage style:UIBarButtonItemStyleBordered target:self action:@selector(onTweetButton)];

    // change back button to cancel
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelButton)];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Compose: viewWillAppear");

    // display the keyboard
    [self.forComposeTextView becomeFirstResponder];
    self.title = @"Compose";
    
    self.currentUser = [User currentUser];
    self.forUsernameLabel.text = self.currentUser.currentUsername;
    self.forScreennameLabel.text = [NSString stringWithFormat:@"@%@",self.currentUser.currentScreenname];
    
    //    NSLog(@"Set username to %@ and screenname to %@", self.currentUser.currentUsername, self.currentUser.currentScreenname);
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.currentUser.currentProfileUrl];
    self.forUserImage.image = [UIImage imageWithData:imageData];
    
    // if inReplyTo then update the textfield.
    if (self.inReplyToTweetId) {
        self.forComposeTextView.text = [NSString stringWithFormat:@"@%@",self.inReplyToUser];
        self.firstEdit = NO;
        [self.forComposeTextView setTextColor:[UIColor blackColor]];
    }
}

- (void)onTweetButton {
    NSLog(@"Tweet the message [%@]", self.forComposeTextView.text);
    
    self.title = @"Sending";

////    TWTweetComposeViewController *tweetsheet = [[TWTweetComposeViewController alloc] init];
////    [tweetsheet setInitialText:@"test1"];
////    [self presentModalViewController:tweetsheet animated:YES];


    // this should be fast.
    [[TwitterClient instance] postStatusWithString:self.forComposeTextView.text success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Sent");
        self.title = @"Sent";
        // should go back to timeline page
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
        self.title = @"Oops";
        // do nothing
    }];

    self.inReplyToTweetId = 0;
    self.inReplyToUser = @"";
    
    // dismiss keyboard
    [self.forComposeTextView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCancelButton {
    // don't do anything.
    [self.navigationController popViewControllerAnimated:YES];
}

//// started editing
//- (void) textViewDidBeginEditing:(UITextView *)textView {
//    NSLog(@"started editing");
////    [textView setTextColor:[UIColor blackColor]];
//}

- (void) textViewDidChange:(UITextView *)textView {
    NSString *refString = @"What's Happening?";
    NSString *newText;
    
    if (self.firstEdit) {
        // first time a change happened.
        NSString *currentText = self.forComposeTextView.text;
        
        NSRange foundRange = [currentText rangeOfString:refString];
        if (foundRange.location == NSNotFound) {
//            NSLog(@"ref string not found, setting to empty");
            newText = @"";
        } else {
            newText = [currentText stringByReplacingOccurrencesOfString:refString withString:@""];
        }
        self.forComposeTextView.text = newText;
        [textView setTextColor:[UIColor blackColor]];
        self.firstEdit = NO;
    }
    int len = [self.forComposeTextView.text length];
    if (len > 140) {
        newText = [self.forComposeTextView.text substringToIndex:140];
        self.forComposeTextView.text = newText;
    }
    self.title = [NSString stringWithFormat:@"%d",140-[self.forComposeTextView.text length]];
    
}

@end
