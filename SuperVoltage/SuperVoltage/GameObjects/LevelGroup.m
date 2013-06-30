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
    int currentRow;
    int currentColumn;
    CCMenu *menu;
}

-(id)init{
    if ((self = [super init])) {
        [self loadSpritesheet];
        [self initBackground];
        menu = [[CCMenu alloc] init];
        [self addChild:menu];
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
-(id)addLevel:(NSString *)levelKey levelData:(NSDictionary *)levelData locked:(BOOL)locked stars:(int)starCount{
    Level *level = [[Level alloc] initWithSpritesheet:_spritesheet levelKey:levelKey levelData:levelData locked:locked stars:starCount];
    
    //IMPORTANT: the value of 'row' grows from top to down
    level.position = ccp((1 + 2*currentColumn - levelGroupColumnCount)*level.contentSize.width*1.1f/2, (levelGroupRowCount- 1 -2*currentRow)*level.contentSize.height*1.1f/2);
    currentColumn ++;
    if (currentColumn==levelGroupColumnCount) {
        currentRow++;
        currentColumn = 0;
    }
    [menu addChild:level];
    return level;
}



@end
