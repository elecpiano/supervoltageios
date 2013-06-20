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
}

-(id)initWithSpritesheet:(CCSpriteBatchNode *)spritesheet{
    if ((self = [super init])) {
        beams = [[NSMutableArray alloc] init];
        for (int n=0; n<8; n++) {
            CCSprite *beamSprite = [CCSprite spriteWithSpriteFrameName:@"Beam.png"];
            [spritesheet addChild:beamSprite z:1];
            [beams addObject:beamSprite];
        }
    }
    return self;
}

-(void)setPosition:(CGPoint)position{
    [super setPosition:position];
    for (int n=0; n<8; n++) {
        CCSprite *beamSprite = [beams objectAtIndex:n];
        beamSprite.position = position;
    }
}

-(void)setRotation:(float)rotation{
    [super setRotation:rotation];
    for (int n=0; n<8; n++) {
        CCSprite *beamSprite = [beams objectAtIndex:n];
        beamSprite.rotation = 360*n/8;
    }
}

@end
