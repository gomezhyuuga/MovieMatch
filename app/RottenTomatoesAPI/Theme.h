//
//  Theme.h
//  RottenTomatoesAPI
//
//  Created by Fernando Gómez Herrera on 16/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMTheme.h"

@interface Theme : NSObject<MMTheme>
//+ (id <Theme>)currentTheme;
- (void)themeButton:(UIButton*)button
           withType:(MMButtonType)type;
@end
