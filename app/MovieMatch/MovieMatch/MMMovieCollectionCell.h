//
//  MMMovieCollectionCell.h
//  MovieMatch
//
//  Created by Fernando Gómez on 19/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXImageView.h"

@interface MMMovieCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet FXImageView *moviePoster;
@property (weak, nonatomic) IBOutlet UILabel *criticsScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *audienceScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *criticsLogo;
@property (weak, nonatomic) IBOutlet UIImageView *audienceLogo;
@end
