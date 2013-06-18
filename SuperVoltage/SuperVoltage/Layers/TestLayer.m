//
//  TestLayer.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-23.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation TestLayer{
    CCSpriteBatchNode *cellSpritesheet;
    ElectricEffect *ee;
    int increaseCount;
    
    Sparkle *emitter_;
}

static TestLayer *instance;
+(TestLayer *)sharedInstance{
    @synchronized(self)
    {
        if (!instance){
            instance = [TestLayer node];
        }
        return instance;
    }
}



-(id) init
{
	if( (self=[super init])) {
	}
	
	return self;
}

-(void)onEnter{
    [super onEnter];
//    [self showElectricFlow];
    [self initMenu];
    [self initSparkle];
}

-(void)onExit{
    instance = nil;
    [super onExit];
}

#pragma mark - Util
-(CGSize)winSize{
    return [[CCDirector sharedDirector] winSize];
}

#pragma mark - menu
-(void)initMenu{
    // restart game
    CCMenuItem *menuItem0 = [CCMenuItemFont itemWithString:@"Go Back" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:SCENE_TRANSITION_DURATION scene:[HomeLayer scene] ]];
    }];
    
    CCMenuItem *menuItem1 = [CCMenuItemFont itemWithString:@"Clear Curve" block:^(id sender) {
        [self clearElectricEffect];
    }];
    
    CCMenuItem *menuItem2 = [CCMenuItemFont itemWithString:@"Generate Curve" block:^(id sender) {
        [self generateElectricEffect];
    }];
    
    CCMenuItem *menuItem3 = [CCMenuItemFont itemWithString:@"Increase Curve" block:^(id sender) {
        [self increaseElectricEffect];
    }];
    
    CCMenuItem *menuItem4 = [CCMenuItemFont itemWithString:@"Decrease Curve" block:^(id sender) {
        [self decreaseElectricEffect];
    }];
    
    CCMenuItem *menuItem5 = [CCMenuItemFont itemWithString:@"Sparkle" block:^(id sender) {
        [self sparkleFlash];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems: menuItem0, menuItem1, menuItem2, menuItem3, menuItem4, menuItem5, nil];
    
    [menu alignItemsVerticallyWithPadding:0];
    [menu setPosition:ccp(WIN_SIZE.width/2, WIN_SIZE.height - 80)];
    
    // Add the menu to the layer
    [self addChild:menu];
}

-(void)loadBackground{
    
}

-(void)loadTexture{
    cellSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"CellTexture.png"];
    [self addChild:cellSpritesheet];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CellTexture.plist"];
}

-(void)prepareBOARD{
    self.allCells = [[NSMutableArray alloc] initWithCapacity:BOARD_ROW_COUNT * BOARD_COLUMN_COUNT];
    for (int row=0; row< BOARD_ROW_COUNT; row++) {
        for (int column=0; column<BOARD_COLUMN_COUNT; column++) {
            Cell *cell = [[Cell alloc] initWithLayer:self spritesheet:cellSpritesheet];
            
            cell.boardRow = row;
            cell.boardColumn = column;
            
            int randomValue = arc4random() % 5;
            CellType cellType = (CellType)randomValue;
            [cell setCellType:cellType];
            
            [self.allCells addObject:cell];
            
            [cell goToWhereItShouldBe:1];
        }
    }
}

#pragma mark - Electric Effect Test

CGFloat radius = 10;

-(void)clearElectricEffect{
    [ee clearFlows];
    [ee removeFromParentAndCleanup:YES];
}

-(void)generateElectricEffect{
    [self showElectricFlow];
}

-(void)increaseElectricEffect{
    increaseCount++;
    for (int n=0; n<1; n++) {
        ElectricFlow *flow = (ElectricFlow *)[ee.electricFlows objectAtIndex:n];
        CGPoint point = ccp(n*30+50, increaseCount*40);
        [flow addNode:point radius:radius];
    }
}

-(void)decreaseElectricEffect{
    for (int n=0; n<1; n++) {
//        ElectricFlow *flow = (ElectricFlow *)[ee.electricFlows objectAtIndex:n];
//        [flow remov];
    }
}

-(void)showElectricFlow{
    CCSpriteBatchNode *spritesheet = [self loadElectricEffectSpriteSheet];
    ee = [[ElectricEffect alloc] initWithSpritesheet:spritesheet frameName:@"ElectricTexture.png"];
    ee.speedFactor = 2;
    [self addChild:ee];
    
    for (int n=0; n<1; n++) {
        [ee addFlow];
//        CGPoint point = ccp(n*30+50, 0);
//        for (int i = 0; i<6; i++) {
//            [flow addNode:point radius:radius];
//            point = ccp(point.x + 0, point.y +40);
//        }
    }
}

-(CCSpriteBatchNode *)loadElectricEffectSpriteSheet{
    CCSpriteBatchNode *spritesheet = [CCSpriteBatchNode batchNodeWithFile:@"ElectricTexture.png"];
    [self addChild:spritesheet];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ElectricTexture.plist"];
    return spritesheet;
}

#pragma mark - Particle System
-(void)initSparkle
{
     emitter_ = [Sparkle node];
	[self addChild:emitter_ z:10];
    
//	CGPoint p = emitter_.position;
//	emitter_.position = ccp( p.x, p.y-110);
	emitter_.texture = [[CCTextureCache sharedTextureCache] addImage: @"Spark1.png"];
}

-(void)sparkleFlash{
    int randomX = arc4random() % 200;
    int randomY = arc4random() % 400;
    CGPoint pos = ccp(50+randomX, 100+randomY);
//    [emitter_ resetSystem];
    [emitter_ flashAt:pos];
}


@end
