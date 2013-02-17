//
//  MMReviewCell.m
//  MovieMatch
//
//  Created by Fernando Gómez on 19/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import "MMReviewCell.h"

@implementation MMReviewCell
@synthesize criticInfo = _criticInfo;
@synthesize criticLogo = _criticLogo;
@synthesize criticQuote = _criticQuote;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 240, 70);
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
