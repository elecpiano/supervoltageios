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
        [self initScrollLayer];
    }
    return self;
}

#pragma mark - Initialization
-(void)loadSpriteSheet{
    //page
    pageSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"PageTexture.png"];
    [self addChild:pageSpritesheet z:Z_INDEX_HOME_LAYER_BASE];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PageTexture.plist"];
}

-(void)initBackground{
    //background
    CCSprite *backgroundSprite = [CCSprite spriteWithSpriteFrameName:@"HomeBackground.png"];
    backgroundSprite.scale = 8;
    backgroundSprite.position = WINCENTER;
    [pageSpritesheet addChild:backgroundSprite z:0];
}

-(void)initPageTitle{

    // go back button
    CoolButton *menuItemGoBack = [CoolButton itemWithFile:@"BackButton.png" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:SCENE_TRANSITION_DURATION scene:[HomeLayer scene] ]];
    }];
    
//    CCSprite *goBackNormal = [CCSprite spriteWithFile:@"BackButton.png"];
//    CCSprite *goBackPressed = [CCSprite spriteWithFile:@"BackButton.png"];
//    goBackPressed.scale = 0.8;
//    CCMenuItem *menuItemGoBack = [CCMenuItemSprite itemWithNormalSprite:goBackNormal selectedSprite:goBackPressed block:^(id sender) {
//        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:SCENE_TRANSITION_DURATION scene:[HomeLayer scene] ]];
//    }];
    
    CCMenu *menu = [CCMenu menuWithItems: menuItemGoBack, nil];
    [menu setPosition:ccp(dscale(48), WIN_SIZE.height - dscale(48))];
    
    // Add the menu to the layer
    [self addChild:menu z:2];
}

-(void)initScrollLayer{
    CCScrollLayer *scroller = [CCScrollLayer nodeWithLayers: [self scrollLayerPages] widthOffset: 0.0f * WIN_SIZE.width];
	scroller.pagesIndicatorPosition = ccp(WIN_SIZE.width * 0.5f, 30.0f);
    
    // New feature: margin offset - to slowdown scrollLayer when scrolling out of it contents.
    // Comment this line or change marginOffset to screenSize.width to disable this effect.
//    scroller.marginOffset = 0.5f * WIN_SIZE.width;
    [self addChild:scroller z:1];
}

-(void)initLevels{

}

#pragma mark - Test
// Returns array of CCLayers - pages for ScrollLayer.
- (NSArray *) scrollLayerPages
{
    // PAGE 0 - Simple Label in the center.
    LevelGroup *pageZero = [LevelGroup node];
    
//	CCLayer *pageZero = [CCLayer node];
//    CCSprite *levelGroupBackground = [CCSprite spriteWithSpriteFrameName:@"LevelGroupBackground.png"];
//    levelGroupBackground.scale = 6;
//	levelGroupBackground.position =  ccp( WIN_SIZE.width/2 , WIN_SIZE.height/2 );
//	[pageZero addChild:levelGroupBackground];
    
	// PAGE 1 - Simple Label in the center.
	LevelGroup *pageOne = [LevelGroup node];
    
    // PAGE 2 - Simple Label in the center.
	CCLayer *pageTwo = [CCLayer node];
	CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Page 2" fontName:@"Arial Rounded MT Bold" fontSize:40];
	label2.position =  ccp( WIN_SIZE.width /2 , WIN_SIZE.height/2 );
	[pageTwo addChild:label2];
	
	return [NSArray arrayWithObjects: pageZero,pageOne,pageTwo,nil];
}

@end
