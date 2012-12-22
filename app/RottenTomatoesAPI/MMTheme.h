//
//  MMTheme.h
//  RottenTomatoesAPI
//
//  Created by Fernando Gómez Herrera on 16/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMTheme
typedef enum {
    MMButtonTypeNormal,
    MMButtonTypeSelected
} MMButtonType;
- (UIColor *)mainTitleColor;
- (UIColor *)secondaryTitleColor;
- (UIImage *)navBarImage;
- (UIImage *)navBarPortraitImage;
- (UIFont *)titleTextFont;
@end
