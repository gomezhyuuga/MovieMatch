//
//  MMInTheatersViewController.h
//  MovieMatch
//
//  Created by Fernando Gómez on 18/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface MMInTheatersViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@end
