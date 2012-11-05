//
//  MMViewController.h
//  MovieMatch
//
//  Created by Fernando Gómez on 31/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface MMViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic) BOOL isDetailed;

@property (nonatomic) IBOutlet iCarousel *carousel;
@property (nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (nonatomic) IBOutlet UILabel *movieScoreLabel;
@property (nonatomic) IBOutlet UIProgressView *percentBar;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbarInfo;
@property (strong, nonatomic) IBOutlet UIButton *dragButton;
- (IBAction)prepareSegue:(id)sender;

- (IBAction)showInfo:(id)sender;
@end
