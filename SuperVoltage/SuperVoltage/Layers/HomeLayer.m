//
//  HomeLayer.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-9.
//  Copyright namiapps 2013年. All rights reserved.
//

#import "AppDelegate.h"
#import "SuperVoltage.h"

#pragma mark - HomeLayer

@implementation HomeLayer{
    CCSpriteBatchNode *pageSpritesheet;
//    CCSpriteBatchNode *pausePanelSpritesheet;
    GameStartPanel *gameStartPanel;
}

#pragma mark - Scene
// Helper class method that creates a Scene with the HomeLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HomeLayer *layer = [HomeLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

#pragma mark - Lifecycle

-(id) init
{
	if( (self=[super init]) ) {
        [self loadSpriteSheet];
        [self initBackground];
		[self initPageTitle];
        [self initMenu];
	}
	return self;
}

#pragma mark - Initialization

-(void)initPageTitle{
    CCSprite *mainPageTitleSprite = [CCSprite spriteWithFile:@"MainPageTitle.png"];
    mainPageTitleSprite.position = ccp( WIN_SIZE.width /2 , WIN_SIZE.height - 80 );
    [self addChild:mainPageTitleSprite z:Z_INDEX_HOME_LAYER_TITLE];
    //    CCLabelTTF *label = [CCLabelTTF labelWithString:@"超电压" fontName:@"Marker Felt" fontSize:64];
    //    [mainPageTitleSprite addChild:label];
}

-(void)initMenu{
    [CCMenuItemFont setFontSize:dscale(28)];
    
    // to avoid a retain-cycle with the menuitem and blocks
    __block id copy_self = self;
    
    //Play
    CCMenuItem *menuPlay = [HButton itemWithLayer:self text:NSLocalizedString(@"Home_Play", nil) block:^(id sender) {
//        [self playLevel:nil];
        [self goTooSelectLevel];
    }];
    
//    //Wiki
//    CCMenuItem *menuWiki = [HButton itemWithLayer:self text:NSLocalizedString(@"Home_Wiki", nil) block:^(id sender) {
//    }];
//
//    //Options
//    CCMenuItem *menuOptins = [HButton itemWithLayer:self text:NSLocalizedString(@"Home_Options", nil) block:^(id sender) {
//    }];
//
//    //About
//    CCMenuItem *menuAbout = [HButton itemWithLayer:self text:NSLocalizedString(@"Home_About", nil) block:^(id sender) {
//    }];
    
    // Leaderboard & Achievement Menu
    CCMenuItem *menuLeaderboard = [HButton itemWithLayer:self text:@"Leaderboard" block:^(id sender) {
        GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
        leaderboardViewController.leaderboardDelegate = copy_self;
        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
        [[app navController] presentModalViewController:leaderboardViewController animated:YES];
    }];
    
    CCMenuItem *menuAchievement = [HButton itemWithLayer:self text:@"Achievements" block:^(id sender) {
        GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
        achivementViewController.achievementDelegate = copy_self;
        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
        [[app navController] presentModalViewController:achivementViewController animated:YES];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems:menuPlay, menuLeaderboard, menuAchievement, nil];
    
    [menu alignItemsVerticallyWithPadding:dscale(10)];
//    [menu setPosition:ccp( WIN_SIZE.width/2, WIN_SIZE.height/2)];
    
    [self addChild:menu z:Z_INDEX_HOME_LAYER_MENU];
}

-(void)loadSpriteSheet{
    //page
    pageSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"PageTexture.png"];
    [self addChild:pageSpritesheet z:Z_INDEX_HOME_LAYER_BASE];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PageTexture.plist"];
}

#pragma mark - Background
-(void)initBackground{
    //background
    CCSprite *backgroundSprite = [CCSprite spriteWithSpriteFrameName:@"HomeBackground.png"];
    backgroundSprite.scale = 8;
    backgroundSprite.position = WINCENTER;
    [pageSpritesheet addChild:backgroundSprite z:0];
    
    //sun shine
    CCSprite *sunshineSprite = [CCSprite spriteWithSpriteFrameName:@"SunShine.png"];
    sunshineSprite.scale = 4;
    sunshineSprite.position = WINCENTER;
    [pageSpritesheet addChild:sunshineSprite z:1];
    
    id rotateAction = [CCRotateBy actionWithDuration:SUNSHINE_ROTATION_INTERVAL angle:-360];
    id foreverAction = [CCRepeatForever actionWithAction:rotateAction];
    [sunshineSprite runAction:foreverAction];
}

#pragma mark - Play
-(void)goTooSelectLevel{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:SCENE_TRANSITION_DURATION scene:[LevelPickLayer scene]]];
}

#pragma mark - Game Start Panle
-(void)playLevel:(id)menu{
    if (!gameStartPanel) {
        gameStartPanel = [[GameStartPanel alloc] initWithLayer:self];
        gameStartPanel.zOrder = Z_INDEX_HOME_LAYER_PAUSE_PANEL;
    }
    [gameStartPanel setLevel:1];
    [gameStartPanel show];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
