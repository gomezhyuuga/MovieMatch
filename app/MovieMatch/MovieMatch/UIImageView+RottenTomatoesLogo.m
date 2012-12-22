//
//  UIImageView+RottenTomatoesLogo.m
//  MovieMatch
//
//  Created by Fernando Gómez on 18/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import "UIImageView+RottenTomatoesLogo.h"
static NSString *RTFreshLogo = @"RottenTomatoesLogo_fresh";
static NSString *RTRottenLogo = @"RottenTomatoesLogo_rotten";
static NSString *RTSpilledLogo = @"RottenTomatoesLogo_spilled";
static NSString *RTCertifiedLogo = @"RottenTomatoesLogo_certified";
static NSString *RTPopcornLogo = @"RottenTomatoesLogo_popcorn";
static NSString *RTPlusLogo = @"RottenTomatoesLogo_plus";

@implementation UIImageView (RottenTomatoesLogo)
- (void)setImageForRating:(NSString *)rating forCritics:(BOOL)isCritics
{
    NSString *compare = [rating lowercaseString];
    // Logos for critics
    if (isCritics) {
        if ([compare isEqualToString:@"certified fresh"]) {
            self.image = [UIImage imageNamed:RTCertifiedLogo];
        } else if ([compare isEqualToString:@"rotten"]) {
            self.image = [UIImage imageNamed:RTRottenLogo];
        } else if ([compare isEqualToString:@"fresh"]) {
            self.image = [UIImage imageNamed:RTFreshLogo];
        } else {
            self.image = [UIImage imageNamed:RTRottenLogo];
        }

    } else {
        // ... and logo for audience
        if ([compare isEqualToString:@"upright"]) {
            self.image = [UIImage imageNamed:RTPopcornLogo];
        } else if ([compare isEqualToString:@"spilled"]) {
            self.image = [UIImage imageNamed:RTSpilledLogo];
        } else {
            self.image = [UIImage imageNamed:RTPlusLogo];
        }
    }
}
@end
