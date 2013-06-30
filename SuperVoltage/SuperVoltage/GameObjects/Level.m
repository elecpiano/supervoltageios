//
//  Level.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-20.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation Level{
//    CCSprite *background;
    CCSprite *star_1, *star_2, *star_3;
    CCSprite *lock;
    CCLabelTTF *levelName;
}

#pragma mark - Lifecycle
-(id)initWithSpritesheet:(CCSpriteBatchNode *)spritesheet levelKey:(NSString *)levelKey levelData:(NSDictionary *)levelData locked:(BOOL)locked stars:(int)starCount{
    if ((self = [super init])) {
//        self.levelNumber = levelNumber;
        self.levelData = levelData;
        
        //background
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LevelBackground.png"];
        self.normalImage = [CCSprite spriteWithSpriteFrame:frame];
        
        if (locked) {
            lock = [CCSprite spriteWithSpriteFrameName:@"Lock.png"];
            [spritesheet addChild:lock z:1];
        }
        else
        {        
            levelName = [CCLabelTTF labelWithString:levelKey fontName:@"Arial-BoldMT" fontSize:dscale(20)];
            [self addChild:levelName z:1];
            
            //stars
            star_1 = [self giveMeStar:starCount--];
            star_2 = [self giveMeStar:starCount--];
            star_3 = [self giveMeStar:starCount--];
            [spritesheet addChild:star_1 z:1];
            [spritesheet addChild:star_2 z:1];
            [spritesheet addChild:star_3 z:1];
        }
    }
    return self;
}

#pragma mark - Star
-(CCSprite *)giveMeStar:(int)starCount{
    return starCount>0?[CCSprite spriteWithSpriteFrameName:@"StarBright.png"]:[CCSprite spriteWithSpriteFrameName:@"StarDark.png"];
}

#pragma mark - Position
-(void)setPosition:(CGPoint)position{
//    background.position = position;
//    _position = position;
    [super setPosition:position];
    if (lock) {
        lock.position = position;
    }
    star_2.position = ccp(self.position.x, self.position.y - dscale(20));
    star_1.position = ccp(star_2.position.x - star_2.contentSize.width, star_2.position.y);
    star_3.position = ccp(star_2.position.x + star_2.contentSize.width, star_2.position.y);
}

#pragma mark - Size
//-(CGSize)contentSize{
//    return background.contentSize;
//}

#pragma mark - Highlight
-(void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LevelBackgroundHighlight.png"];
//        [background setDisplayFrame:frame];
        [((CCSprite *)self.selectedImage) setDisplayFrame:frame];
    }
}

#pragma mark - Behavior
-(void)activate{
    GAME.currentGameLevel = [[GameLevel alloc] initWithLevelData:self.levelData];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:SCENE_TRANSITION_DURATION scene:GAME]];
}

@end
