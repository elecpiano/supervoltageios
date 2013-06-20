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
    _spritesheet.position = WINCENTER;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LevelPickTexture.plist"];
}

-(void)initBackground{
    CCNineGridSprite *background = [CCNineGridSprite spriteWithFile:@"LevelGroupBackground.png" edge:dscale(10)];
//    CCNineGridSprite *background = [CCNineGridSprite spriteWithSpritesheet:_spritesheet baseName:@"LevelGroupBackground" edge:dscale(10)];
    background.position = WINCENTER;
    background.size = CGSizeMake(WIN_SIZE.width*0.8, WIN_SIZE.height*0.8);
    [self addChild:background];
}

int levelGroupRowCount=4;
int levelGroupColumnCount=3;

-(void)populateLevels{
    //todo: load from local persistense data using groupIndex key data
    
    //IMPORTANT: the value of 'row' grows from top to down
    for (int row = 0; row < levelGroupRowCount; row++) {
        for (int column = 0 ; column<levelGroupColumnCount; column++) {
            Level *level = [[Level alloc] initWithSpritesheet:_spritesheet locked:NO stars:1 highlighted:NO];
            [self addChild:level];
            level.position = ccp((1 + 2*column - levelGroupColumnCount)*level.contentSize.width*1.1f/2, (levelGroupRowCount- 1 -2*row)*level.contentSize.height*1.1f/2);
        }
    }
}

@end
