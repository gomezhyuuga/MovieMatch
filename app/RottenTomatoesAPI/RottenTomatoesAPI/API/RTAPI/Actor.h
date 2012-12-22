//
//  Actor.h
//  RottenTomatoesAPI
//
//  Created by Fernando Gómez Herrera on 16/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Actor : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *actorId;
@property (nonatomic) NSArray *characters;
- (id)initWithDictionary:(NSDictionary *)aDictionary;
@end
