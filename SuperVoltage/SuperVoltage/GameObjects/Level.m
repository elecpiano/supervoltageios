//
//  Level.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-20.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation Level{
    CCSprite *background;
    CCSprite *star_1, *star_2, *star_3;
    CCSprite *lock;
}

#pragma mark - Lifecycle
-(id)initWithSpritesheet:(CCSpriteBatchNode *)spritesheet locked:(BOOL)locked stars:(int)starCount highlighted:(BOOL)highlighted{
    if ((self = [super init])) {
        self.locked = locked;
        self.highlighted = highlighted;
        
        //background
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LevelBackground.png"];
        background = [CCSprite spriteWithSpriteFrame:frame];
        [spritesheet addChild:background z:0];
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
    background.position = position;
    star_2.position = ccp(background.position.x, background.position.y - dscale(20));
    star_1.position = ccp(star_2.position.x - dscale(10), star_2.position.y);
    star_3.position = ccp(star_2.position.x + dscale(10), star_2.position.y);
    [super setPosition:position];
}

#pragma mark - Highlight
-(void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"LevelBackgroundHighlight.png"];
        [background setDisplayFrame:frame];
    }
}

@end
