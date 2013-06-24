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
-(id)initWithSpritesheet:(CCSpriteBatchNode *)spritesheet levelNumber:(int)levelNumber locked:(BOOL)locked stars:(int)starCount highlighted:(BOOL)highlighted{
    if ((self = [super init])) {
        self.levelNumber = levelNumber;
        self.locked = locked;
        self.highlighted = highlighted;
        levelName = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",levelNumber] fontName:@"Arial-BoldMT" fontSize:dscale(20)];
        [self addChild:levelName z:1];
        
        //background
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LevelBackground.png"];
//        background = [CCSprite spriteWithSpriteFrame:frame];
        self.normalImage = [CCSprite spriteWithSpriteFrame:frame];
//        [spritesheet addChild:background z:0];
        
        //stars
        star_1 = [self giveMeStar:starCount--];
        star_2 = [self giveMeStar:starCount--];
        star_3 = [self giveMeStar:starCount--];
        [spritesheet addChild:star_1 z:1];
        [spritesheet addChild:star_2 z:1];
        [spritesheet addChild:star_3 z:1];
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
    GAME.currentGameLevel = [[GameLevel alloc] initWithLevelNumber:self.levelNumber];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:SCENE_TRANSITION_DURATION scene:GAME]];
}

@end
