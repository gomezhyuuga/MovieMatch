//
//  MMMovieTableCell.m
//  MovieMatch
//
//  Created by Fernando Gómez Herrera on 20/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import "MMMovieTableCell.h"

@implementation MMMovieTableCell

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
