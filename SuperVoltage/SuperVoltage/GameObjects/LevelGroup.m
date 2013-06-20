//
//  LevelGroup.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-19.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation LevelGroup{
    CCSpriteBatchNode *_spritesheet;
}

-(id)initWithIndex:(int)index{
    if ((self = [super init])) {
        self.groupIndex = index;
        [self loadSpritesheet];
        [self initBackground];
        [self populateLevels];
    }
    return self;
}

-(void)loadSpritesheet{
    //level
    _spritesheet = [CCSpriteBatchNode batchNodeWithFile:@"LevelPickTexture.png"];
    [self addChild:_spritesheet z:Z_INDEX_LEVELPICK_LAYER_ITEM];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LevelPickTexture.plist"];
}

-(void)initBackground{
    CCNineGridSprite *background = [CCNineGridSprite spriteWithFile:@"LevelGroupBackground.png" edge:dscale(10)];
//    CCNineGridSprite *background = [CCNineGridSprite spriteWithSpritesheet:_spritesheet baseName:@"LevelGroupBackground" edge:dscale(10)];
    background.position = ccp( WIN_SIZE.width/2 , WIN_SIZE.height/2 );
    background.size = CGSizeMake(WIN_SIZE.width*0.8, WIN_SIZE.height*0.8);
    [self addChild:background];
    
//    CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"LevelGroupBackground.png"];
//    background.scale = 5;
//	background.position =  ccp( WIN_SIZE.width/2 , WIN_SIZE.height/2 );
//    [self addChild:background];
}

-(void)populateLevels{
    //todo: load from local persistense data using groupIndex key data
    for (int row = 0; row < 5; row++) {
        for (int column = 0 ; column<4; column++) {
            Level *level = [[Level alloc] initWithSpritesheet:_spritesheet locked:NO stars:1 highlighted:NO];
            [self addChild:level];
            level.position = ccp(column*dscale(30), (5-row)*dscale(30));
        }
    }
}

@end
