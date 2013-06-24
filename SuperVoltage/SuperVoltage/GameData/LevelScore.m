//
//  LevelData.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-24.
//  Copyright (c) 2013年 namiapps. All rights reserved.
//

#import "LevelScore.h"

@implementation LevelScore

-(id)initWithLevel:(int)level stars:(int)stars{
    if ((self = [super init])) {
        self.level = level;
        self.stars = stars;
    }
    return self;
}

@end
