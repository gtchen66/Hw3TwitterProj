//
//  TweetCell.m
//  Hw3TwitterProj
//
//  Created by George Chen on 1/23/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "TweetCell.h"

@interface TweetCell ()
//@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
//@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
//@property (weak, nonatomic) IBOutlet UILabel *tweetAuthor;
//@property (weak, nonatomic) IBOutlet UIImageView *tweetImage;

@end

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
