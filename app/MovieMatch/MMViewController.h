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
@property (nonatomic) IBOutlet iCarousel *carousel;
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UILabel *ratingLabel;
@property (nonatomic) IBOutlet UIProgressView *percentBar;
@end
