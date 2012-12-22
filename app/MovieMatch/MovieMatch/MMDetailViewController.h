//
//  MMDetailViewController.h
//  MovieMatch
//
//  Created by Fernando Gómez on 18/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MMDetailViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
- (IBAction)showTrailer:(id)sender;
- (IBAction)shareMovie:(id)sender;
@property (nonatomic, retain) Movie* detailedMovie;
@end
