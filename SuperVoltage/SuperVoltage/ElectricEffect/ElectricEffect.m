//
//  ElectricEffect.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-28.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "ElectricEffect.h"
#import "ElectricFlow.h"

@implementation ElectricEffect{
    NSString *_spriteFrameName;
    CCSpriteBatchNode *_spritesheet;
}

#pragma mark - Lifecycle

-(id)initWithSpritesheet:(CCSpriteBatchNode *)sheet frameName:(NSString *)frameName{
    if ((self = [super init])) {
        _spritesheet = sheet;
        [_spritesheet setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
        _spriteFrameName = frameName;
        self.segments = 7;
        self.lifeSpan = 0.2;
        self.speedFactor = 2;
        
        self.electricFlows = [[NSMutableArray alloc] init];
        
        [self scheduleUpdate];
    }
    return self;
}

#pragma mark - Update & Draw

-(void)update:(ccTime)delta{
    for (ElectricFlow *flow in self.electricFlows)
    {
        [flow update:delta];
    }
}

/// LifeSpan controls the frequency of the texture switching
-(ElectricFlow *)addFlow{
    ElectricFlow *flow = [[ElectricFlow alloc] initWithSpritesheet:_spritesheet frameName:_spriteFrameName];
    flow.segments = self.segments;
    flow.lifeSpan = self.lifeSpan;
    flow.speedFactor = self.speedFactor;
    flow.zIndexForSprite = self.zIndexForSprite;
    
    [self.electricFlows addObject:flow];
    [self addChild:flow];
    return flow;
}

-(void)clearFlows{
    for (ElectricFlow *flow in self.electricFlows) {
        [flow clearNodes];
        [flow removeFromParentAndCleanup:YES];
    }
    [self.electricFlows removeAllObjects];
}

@end
