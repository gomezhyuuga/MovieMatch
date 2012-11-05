//
//  MMDetailedMovieViewController.h
//  MovieMatch
//
//  Created by Fernando Gómez on 04/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MMDetailedMovieViewController : UIViewController
@property (nonatomic, retain) Movie *detailedMovie;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbarInfo;
@property (strong, nonatomic) IBOutlet UIProgressView *percentBar;
@property (strong, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutlet UIView *detailBG;
- (IBAction)backButton:(id)sender;
@end
