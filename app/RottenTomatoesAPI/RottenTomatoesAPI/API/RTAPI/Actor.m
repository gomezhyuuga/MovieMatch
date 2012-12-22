//
//  Actor.m
//  RottenTomatoesAPI
//
//  Created by Fernando Gómez Herrera on 16/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "Actor.h"

@implementation Actor
@synthesize name = _name;
@synthesize actorId = _actorId;
@synthesize characters = _characters;
# pragma mark - Initializers
- (id)init
{
    return [self initWithName:nil actorId:nil characters:nil];
}
- (id)initWithName:(NSString *)name actorId:(NSString *)actorId characters:(NSArray *)actors
{
    self = [super init];
    if (self) {
        _name = name;
        _characters = actors;
        _actorId = actorId;
    }
    return self;
}
- (id)initWithDictionary:(NSDictionary *)aDictionary
{
    NSMutableArray *array = [NSMutableArray array];
    // Crear array de actores
    for (id obj in [aDictionary objectForKey:@"characters"]) {
        [array addObject:obj];
    }
    NSArray *actors = array;
    return [self initWithName:[aDictionary objectForKey:@"name"]
                      actorId:[aDictionary objectForKey:@"id"]
                   characters:actors];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"- name: %@\
            \n- id: %@\
            \n- characters: %d",
            _name, _actorId, _characters.count];
}

@end
