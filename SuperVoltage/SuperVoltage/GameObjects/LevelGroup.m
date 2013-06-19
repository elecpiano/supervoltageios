//
//  LevelGroup.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-19.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation LevelGroup{
    
}

-(id)init{
    if ((self = [super init])) {
        [self initBackground];
    }
    return self;
}

-(void)initBackground{
    CCNineGridSprite *background = [CCNineGridSprite spriteWithFile:@"LevelGroupBackground.png" edge:dscale(10)]; 
    background.size = CGSizeMake(WIN_SIZE.width*0.8, WIN_SIZE.height*0.8);
    background.position = ccp( WIN_SIZE.width/2 , WIN_SIZE.height/2 );
    [self addChild:background];
    
//    CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"LevelGroupBackground.png"];
//    background.scale = 5;
//	background.position =  ccp( WIN_SIZE.width/2 , WIN_SIZE.height/2 );
//    [self addChild:background];
}

@end
