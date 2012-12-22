//
//  MMReviewCell.h
//  MovieMatch
//
//  Created by Fernando Gómez on 19/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+RottenTomatoesLogo.h"

@interface MMReviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *criticLogo;
@property (weak, nonatomic) IBOutlet UILabel *criticQuote;
@property (weak, nonatomic) IBOutlet UILabel *criticInfo;
@end
