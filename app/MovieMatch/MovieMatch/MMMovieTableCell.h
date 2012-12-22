//
//  MMMovieTableCell.h
//  MovieMatch
//
//  Created by Fernando Gómez Herrera on 20/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXImageView.h"

@interface MMMovieTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet FXImageView *moviePoster;
@property (strong, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *criticsLabel;
@property (strong, nonatomic) IBOutlet UILabel *audienceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *criticsLogo;
@property (strong, nonatomic) IBOutlet UIImageView *audienceLogo;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;

@end
