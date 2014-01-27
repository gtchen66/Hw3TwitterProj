//
//  TimeLineVC.m
//  Hw3TwitterProj
//
//  Created by George Chen on 1/23/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "TimeLineVC.h"

#import "TweetCell.h"
#import "DetailedTweetVC.h"
#import "ComposeVC.h"

#import <objc/runtime.h>

@interface TimeLineVC () {
    dispatch_queue_t myQueue;
}

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) DetailedTweetVC *detailedTweetTC;

@property (nonatomic, strong) TweetCell *testCell;

- (void)onSignOutButton;
- (void)reload;

// - (IBAction)onTap:(id)sender;


@end

@implementation TimeLineVC

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Twitter";
        [self reload];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register the nib for the custom tablecell
    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"TweetCell"];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Write" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];

    UIImage *myComposeImage = [UIImage imageNamed:@"write"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:myComposeImage style:UIBarButtonItemStyleBordered target:self action:@selector(onComposeButton)];

    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int numrows = self.tweets.count + 1;
    NSLog(@"number of rows set to %d",numrows);
    return numrows;
}

// row was selected
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected row: %d", indexPath.row);
    [self.navigationController pushViewController:[[DetailedTweetVC alloc] init] animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell;
    static NSString *CellIdentifier = @"TweetCell";
   
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSLog(@"Warning. this should never be nil. it should auto-reallocate:");
        cell = [[TweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    NSLog(@"cellForRowAtIndexPath loading row %d out of %d", indexPath.row, self.tweets.count);
    if (indexPath.row >= self.tweets.count) {
        if (indexPath.row > 0) {
            NSLog(@"Need to do something to get more");
            cell.tweetLabel.text = @"End of the line ... should be geting more.";
            
            // fire off a long running operation to fetch additional cells.
            [self backgroundOperation];
        
        } else if (self.tweets.count == 0) {
            cell.tweetLabel.text = @"";
           
        }
        cell.tweetAuthor.text = @"";
        cell.tweetTime.text = @"";
        cell.tweetImage.image = nil;
        cell.tweetScreen.text = @"";

        return cell;
    }
    
    Tweet *tweet = self.tweets[indexPath.row];
    // cell.textLabel.text = tweet.text;
    cell.tweetLabel.text = tweet.text;
    cell.tweetAuthor.text = tweet.username;
    cell.tweetScreen.text = [NSString stringWithFormat:@"@%@",tweet.screen_name];
    
//    NSLog(@"URL should be %@",tweet.pictureUrl);
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:tweet.pictureUrl];
    cell.tweetImage.image = [UIImage imageWithData:imageData];
    
    
    //try to convert time to NSDate.
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss +zzzz yyyy"];
    NSDate *mydate = [dateFormat dateFromString:tweet.created_at];

    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSTimeInterval deltaTime = [now timeIntervalSinceDate:mydate];
    NSString *deltaTimeString;
    
    if (deltaTime < 1) {
        deltaTimeString = @"";
    } else if (deltaTime < 60) {
        deltaTimeString = [NSString stringWithFormat:@"%ds",(int) deltaTime];
    } else if (deltaTime < 3600) {
        deltaTimeString = [NSString stringWithFormat:@"%dm",(int) (deltaTime/60)];
    } else if (deltaTime < 3600*48) {
        deltaTimeString = [NSString stringWithFormat:@"%dh",(int) (deltaTime/3600)];
    } else {
        deltaTimeString = [NSString stringWithFormat:@"%dd",(int) (deltaTime/3600/24)];
    }
    
    cell.tweetTime.text = deltaTimeString;
    
//    NSLog(@"Set cell %d to < %@ >, generated at %@, aka <%f>, <%@>",indexPath.row,tweet.text, tweet.created_at,deltaTime, deltaTimeString);

    
    
    return cell;
}

// adjust the height of the cell dynamically

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat finalHeight = 70.0;
    if ((indexPath.row >= self.tweets.count) && (indexPath.row > 0)) {
        return finalHeight;
    }
    self.testCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
//    TweetCell *testCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
//    NSLog(@"heightForRowAtIndexPath is looking for row %d",indexPath.row);
    Tweet *tweet = self.tweets[indexPath.row];
    self.testCell.tweetLabel.text = tweet.text;

    [self.testCell layoutIfNeeded];
    [self.testCell.tweetLabel sizeToFit];
    
    CGFloat rowHeight = self.testCell.tweetLabel.frame.size.height;
    finalHeight = rowHeight + 40;
    finalHeight = (finalHeight < 70) ? 70 : finalHeight;
    NSLog(@"for row %d, height of label %@... is %.0f, testcell is %.0f, final height is %.0f", indexPath.row, [tweet.text substringToIndex:20], rowHeight, self.testCell.frame.size.height, finalHeight);
//    CGFloat finalHeight = 70;
    return finalHeight;
}


#pragma mark - Table view delegate

//- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"scrollViewDidEndDragging");
//}
//- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidEndDecelerating");
//}
//- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidEndScrollingAnimation");
//}
//- (void) scrollViewDidScrollToTop:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidScrollToTop");
//}

// Jump to the detailed view of a tweet, but first pass the information
// about the tweet to the new view controller

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // flash the cell just a little bit
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.detailedTweetTC == nil) {
        DetailedTweetVC *dvc = [[DetailedTweetVC alloc] init];
        self.detailedTweetTC = dvc;
//        NSLog(@"allocating a new Detailed Tweet VC with addr %@",self.detailedTweetTC);
//    } else {
//        NSLog(@"using existing Detailed Tweet VC with addr %@",self.detailedTweetTC);
    }
    self.detailedTweetTC.tweet = self.tweets[indexPath.row];
    
    NSLog(@"Set the detailed tweet text to %@",self.detailedTweetTC.tweet.text);
    
    [self.navigationController pushViewController:self.detailedTweetTC animated:YES];

}

- (void)backgroundOperation {
    if (!myQueue) {
        myQueue = dispatch_queue_create("get.more.tweets", NULL);
    }
    
    dispatch_async(myQueue, ^{ [self getMoreTweets];});
    NSLog(@"kicked off request for more older tweets");
    
}
// get OLDER tweets
- (void)getMoreTweets {
//    NSLog(@"getMoreTweets: looking for last Tweet at row %d",self.tweets.count);
    int currentTweetCount = self.tweets.count;
    Tweet *lastTweet = self.tweets[currentTweetCount - 1];
    long long currentTweetMaxId = lastTweet.tweetId;

    currentTweetMaxId--;
    NSLog(@"starting with %d tweets in the system and id %lld",self.tweets.count, currentTweetMaxId);

    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:currentTweetMaxId success:^(AFHTTPRequestOperation *operation, id response) {
        //        NSLog(@"%@", response);
        NSMutableArray *olderNewTweets = [[NSMutableArray alloc] init];

        olderNewTweets = [Tweet tweetsWithArray:response];
        [self.tweets addObjectsFromArray:olderNewTweets];
        NSLog(@"there are %d new tweets in the system",olderNewTweets.count);
        NSLog(@"1st new tweet: %lld, %@",[olderNewTweets[0] tweetId], [olderNewTweets[0] text]);
        
        // This was supposed to just load the new rows, but it called every row anyway...
        // comment it out and use the original reloadData
        
//        NSMutableArray *newRows = [[NSMutableArray alloc] init];
//        int i;
//        for (i=currentTweetCount; i< self.tweets.count; i++) {
//            [newRows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//        }
//        [self.tableView insertRowsAtIndexPaths:newRows withRowAnimation:UITableViewRowAnimationBottom];
        
       [self.tableView reloadData];
        NSLog(@"grabbed %d from twitter, a total of %d", [olderNewTweets count], self.tweets.count);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];

}

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)onComposeButton {
    [self.navigationController pushViewController:[[ComposeVC alloc] init] animated:YES];
    
}

// when user drags down top of table, refresh is called.  this calls reload, which only
// loads in the 1st 20 tweets.  infinite scroll rows will need to be refetched.  Possible
// room for improvement by inserting, but will require more code to handle corner cases.
- (void) refreshView:(UIRefreshControl *)sender {
    sender.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pulling..."];
    [self reload];
    [sender endRefreshing];
}

- (void)reload {
    NSLog(@"reload.");
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        NSLog(@"calling reloadData");
        [self.tableView reloadData];
        NSLog(@"grabbed from twitter, a total of %d", self.tweets.count);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed at reload.  Error is %@",error);
        // Do nothing
    }];
}

@end
