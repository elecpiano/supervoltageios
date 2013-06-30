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
    NSMutableDictionary *levelGroupDictionary;
    NSMutableDictionary *gameLevelScores;
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
        
        [self loadLevels];
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

#pragma mark - Levels
-(void)loadLevels{
    [self loadGameLevelsData];
    [self loadGameLevelScores];
    
    [self populateScrollPages];    
}

-(void)loadGameLevelsData{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameLevels" ofType:@"plist"];
    GAME.gameLevelGroups = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

-(void)loadGameLevelScores{
    //todo : restore game score data using Archiving
    gameLevelScores = [[NSMutableDictionary alloc] init];
    LevelScore *levelScore;
    levelScore = [[LevelScore alloc] initWithLevel:1 stars:3];
    [gameLevelScores setObject:levelScore forKey:[NSString stringWithFormat:@"%d", levelScore.stars]];
    levelScore = [[LevelScore alloc] initWithLevel:2 stars:2];
    [gameLevelScores setObject:levelScore forKey:[NSString stringWithFormat:@"%d", levelScore.stars]];
    levelScore = [[LevelScore alloc] initWithLevel:3 stars:1];
    [gameLevelScores setObject:levelScore forKey:[NSString stringWithFormat:@"%d", levelScore.stars]];
}

-(void)populateScrollPages{
    levelGroupDictionary = [[NSMutableDictionary alloc] init];
    int groupCount = [GAME.gameLevelGroups count];
    int levelIndex = 1;
    BOOL itemHighlighted = NO;
    
    for (int n=1; n<=groupCount; n++) {
        NSString *groupKey = [NSString stringWithFormat:@"Group-%d",n];
        LevelGroup *levelGroup = [[LevelGroup alloc] init];
        [levelGroupDictionary setObject:levelGroup forKey:groupKey];
        
        NSDictionary *levelGroupData = GAME.gameLevelGroups[groupKey];
        int levelCount = [levelGroupData count];
        for (int j=0; j<levelCount; j++) {
            //get score
            
            int starCount = 0;
            BOOL isLocked = YES;
            
            NSString *levelKey = [NSString stringWithFormat:@"%d",levelIndex];
            LevelScore *levelScore = gameLevelScores[levelKey];
            if (levelScore) {
                starCount = levelScore.stars;
                isLocked = NO;
            }

            NSDictionary *levelData = levelGroupData[levelKey];
            Level *level = [levelGroup addLevel:levelKey levelData:levelData locked:isLocked stars:starCount];

            if (!levelScore && !itemHighlighted){
                level.highlighted = YES;
                itemHighlighted = YES;
            }
            
            levelIndex++;
        }
    }
    
    //make an array of LevelGroup object to populate the CCScrollLayer
    NSEnumerator *enumerator = [levelGroupDictionary objectEnumerator];
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    for (id group in enumerator) {
        [groups addObject:group];
    }
    
    CCScrollLayer *scroller = [CCScrollLayer nodeWithLayers:groups widthOffset: 0.0f * WIN_SIZE.width];
	scroller.pagesIndicatorPosition = ccp(WIN_SIZE.width * 0.5f, 30.0f);
    
//    // New feature: margin offset - to slowdown scrollLayer when scrolling out of it contents.
//    // Comment this line or change marginOffset to screenSize.width to disable this effect.
//    scroller.marginOffset = 0.5f * WIN_SIZE.width;
    [self addChild:scroller z:Z_INDEX_LEVELPICK_LAYER_MENU];
}

#pragma mark - Test


@end
