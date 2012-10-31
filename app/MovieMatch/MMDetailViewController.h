//
//  MMDetailViewController.h
//  MovieMatch
//
//  Created by Fernando Gómez on 28/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
@interface MMDetailViewController : UIViewController
@property (nonatomic, retain) Movie* detailedMovie;
@property (weak, nonatomic) IBOutlet UILabel* movieTitle;
@property (weak, nonatomic) IBOutlet UIImageView* bgImage;
@end
