//
//  SunShine.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-20.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation SunShine{
    NSMutableArray *beams;
    CCSpriteBatchNode *spritesheet;
}

int beamCount = 12;

-(id)init{
    if ((self = [super init])) {
        [self loadSpriteSheet];
        beams = [[NSMutableArray alloc] init];
        for (int n=0; n<beamCount; n++) {
            CCSprite *beamSprite = [CCSprite spriteWithSpriteFrameName:@"Beam.png"];
            beamSprite.anchorPoint = ccp(0,0);
            beamSprite.rotation = 360*n/beamCount;
            [spritesheet addChild:beamSprite];
            [beams addObject:beamSprite];
        }
        [self rotate];
    }
    return self;
}

-(void)loadSpriteSheet{
    spritesheet = [CCSpriteBatchNode batchNodeWithFile:@"PageTexture.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PageTexture.plist"];
    [self addChild:spritesheet];
}

-(void)setRotation:(float)rotation{
    [super setRotation:rotation];
    for (int n=0; n<8; n++) {
        CCSprite *beamSprite = [beams objectAtIndex:n];
        beamSprite.rotation = 360*n/8 + rotation;
    }
}

-(void)rotate{
    id rotateAction = [CCRotateBy actionWithDuration:SUNSHINE_ROTATION_INTERVAL angle:-360];
    id foreverAction = [CCRepeatForever actionWithAction:rotateAction];
    [spritesheet runAction:foreverAction];
}

@end
