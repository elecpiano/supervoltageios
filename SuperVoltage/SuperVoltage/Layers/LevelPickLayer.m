//
//  LevelPickLayer.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-19.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation LevelPickLayer{
    CCSpriteBatchNode *pageSpritesheet;
}

#pragma mark - Scene

+(CCScene *)scene{
    CCScene *scene = [CCScene node];
    LevelPickLayer *layer = [LevelPickLayer node];
    [scene addChild:layer];
    return scene;
}

#pragma mark - Lifecycle
-(id)init{
    if ((self = [super init])) {
        [self loadSpriteSheet];
        [self initBackground];
        [self initPageTitle];
        [self initMenu];
        [self initScrollLayer];
    }
    return self;
}

#pragma mark - Initialization
-(void)loadSpriteSheet{
    //page base
    pageSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"PageTexture.png"];
    [self addChild:pageSpritesheet z:Z_INDEX_LEVELPICK_LAYER_BASE];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PageTexture.plist"];
}

-(void)initBackground{
    //background
    CCSprite *backgroundSprite = [CCSprite spriteWithSpriteFrameName:@"PageBackground.png"];
    backgroundSprite.scale = 8;
    backgroundSprite.position = WINCENTER;
    [pageSpritesheet addChild:backgroundSprite z:0];
}

-(void)initPageTitle{
}

-(void)initMenu{
    // go back button
    CoolButton *menuItemGoBack = [CoolButton itemWithFile:@"BackButton.png" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:SCENE_TRANSITION_DURATION scene:[HomeLayer scene] ]];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems: menuItemGoBack, nil];
    [menu setPosition:ccp(dscale(48), WIN_SIZE.height - dscale(48))];
    
    // Add the menu to the layer
    [self addChild:menu z:2];
}

-(void)initScrollLayer{
    CCScrollLayer *scroller = [CCScrollLayer nodeWithLayers: [self getPages] widthOffset: 0.0f * WIN_SIZE.width];
	scroller.pagesIndicatorPosition = ccp(WIN_SIZE.width * 0.5f, 30.0f);
    
    // New feature: margin offset - to slowdown scrollLayer when scrolling out of it contents.
    // Comment this line or change marginOffset to screenSize.width to disable this effect.
//    scroller.marginOffset = 0.5f * WIN_SIZE.width;
    [self addChild:scroller z:Z_INDEX_LEVELPICK_LAYER_MENU];
}

-(void)initLevels{

}

#pragma mark - Test
// Returns array of CCLayers - pages for ScrollLayer.
- (NSArray *) getPages
{
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    for (int n = 0; n < 3; n++) {
        LevelGroup *group = [[LevelGroup alloc] initWithIndex:n];
        [pages addObject:group];
    }
    
    return pages;
}

@end
