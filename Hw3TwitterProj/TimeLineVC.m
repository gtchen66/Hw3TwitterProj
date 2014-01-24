//
//  TimeLineVC.m
//  Hw3TwitterProj
//
//  Created by George Chen on 1/23/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "TimeLineVC.h"

// why do I need these but the reference implementation doesn't.  Ah, the TwitterCommon.h file
// #import "TwitterClient.h"
// #import "Tweet.h"
// #import "User.h"

#import "TweetCell.h"

@interface TimeLineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;

- (void)onSignOutButton;
- (void)reload;

@end

@implementation TimeLineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Twitter";
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // register the nib for the custom tablecell
    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"TweetCell"];
    

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Write" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSLog(@"Warning. this should never be nil. it should auto-reallocate:");
        cell = [[TweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    Tweet *tweet = self.tweets[indexPath.row];
    // cell.textLabel.text = tweet.text;
    cell.tweetLabel.text = tweet.text;
    cell.tweetTime.text = tweet.created_at;
    cell.tweetAuthor.text = tweet.username;
    
    NSLog(@"URL should be %@",tweet.pictureUrl);
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:tweet.pictureUrl];
    cell.tweetImage.image = [UIImage imageWithData:imageData];
    
    
    NSLog(@"Set cell %d to %@, generated at %@",indexPath.row,tweet.text, tweet.created_at);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 130;
    return rowHeight;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Preparing to move");
}

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)onComposeButton {

}

- (void)reload {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"%@", response);
        NSLog(@"grabbed from twitter");
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}

@end
