//
//  ElectricFlow.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-27.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "ElectricFlow.h"
#import "ElectricNode.h"

@implementation ElectricFlow{
    NSString *spriteFrameName;
    CCSpriteBatchNode *_spritesheet;
    CCSpriteFrame *currentFrame;
    CGFloat currentSpriteScale;
    CGFloat age;
    NSMutableArray *_controlPoints;
    NSMutableArray *_sprites;
    CGFloat _lifeSpan;
}

#pragma mark - Config

 // LifeSpan controls the frequency of the texture switching

#pragma mark - Lifecycle

-(id)initWithSpritesheet:(CCSpriteBatchNode *)sheet frameName:(NSString *)frameName{
    if ((self = [super init])) {
        _spritesheet = sheet;
        spriteFrameName = frameName;
        _controlPoints = [[NSMutableArray alloc] init];
        _sprites = [[NSMutableArray alloc] init];
        currentFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName];
        currentSpriteScale = 1;
        
        [self reset];
    }
    return self;
}

-(void)onEnter{
    [super onEnter];
//    [self prepareCatmullRomCurve];
}

//-(void)onExit{
//    [self removeFromParentAndCleanup:YES];
//    [super onExit];
//}

#pragma mark - Update
-(void)update:(ccTime)delta{
    if (age < _lifeSpan)
    {
        age += delta;
    }
    else
    {
        [self reset];
    }
    
    for (ElectricNode *enode in _controlPoints)
    {
        [enode update:delta];
    }
}

-(void)draw{
    [self drawCatmullRomCurve];
    [super draw];
}

-(void)reset{
    age = 0;
    //reset sprites
    currentSpriteScale = (CCRANDOM_0_1() + 1.0f)/2.0f;
    for (CCSprite *sprite in _sprites) {
        sprite.scale = currentSpriteScale;
    }
}

-(ElectricNode *)addNode:(CGPoint)fiducialPoint radius:(CGFloat)radius{
    if ([_controlPoints count]>0) {
        for (int i = 0; i<self.segments; i++) {
            CCSprite *sprite = [CCSprite spriteWithSpriteFrame:currentFrame];
            [_spritesheet addChild:sprite z:self.zIndexForSprite];
            [_sprites addObject:sprite];
        }
    }
    return [self insertNodeAt:0 fiducialPoint:fiducialPoint radius:radius];
}

-(ElectricNode *)insertNodeAt:(int)index fiducialPoint:(CGPoint)fiducialPoint radius:(CGFloat)radius{
    ElectricNode *enode = [[ElectricNode alloc] initWithFiducialPoint:fiducialPoint radius:radius speedFactor:self.speedFactor];
    [_controlPoints insertObject:enode atIndex:index];
    return enode;
}

-(void)clearNodes{
    for (CCSprite *sprite in _sprites) {
        [sprite removeFromParentAndCleanup:YES];
    }
    [_sprites removeAllObjects];
    [_controlPoints removeAllObjects];
}

#pragma mark - Curve
-(void)drawCurve_old{
    CCPointArray *array = [CCPointArray arrayWithCapacity:10];
	
    for (ElectricNode *enode in _controlPoints) {
        [array addControlPoint:enode.position];
    }
    
//	ccDrawCardinalSpline(array, -0.5, 20);
    ccDrawCatmullRom(array,20);
}

-(CGFloat)catmullRom:(CGFloat)t p0:(CGFloat)P0 p1:(CGFloat)P1 p2:(CGFloat)P2 p3:(CGFloat)P3 {
    return 0.5 * ((2 * P1) +
                  (-P0 + P2) * t +
                  (2*P0 - 5*P1 + 4*P2 - P3) * powf(t,2.0f) +
                  (-P0 + 3*P1- 3*P2 + P3) * powf(t, 3.0f));
}

-(int)getRandomOpacity{
    return (arc4random() % 96) + 96;
}

-(void)drawCatmullRomCurve{
    if ([_controlPoints count]==0) {
        return;
    }
    
    CGPoint p0 = ((ElectricNode *)_controlPoints[0]).position;
    CGPoint p1 = ((ElectricNode *)_controlPoints[0]).position;
    CGPoint p2 = ((ElectricNode *)_controlPoints[0]).position;
    CGPoint p3 = ((ElectricNode *)_controlPoints[0]).position;
    
    int controlPointsCount = [_controlPoints count];
    CGFloat step = 1.0f / self.segments;
    
    for (int i = 2; i < controlPointsCount + 1; i++)
    {
        int idx = i >= controlPointsCount ? controlPointsCount - 1 : i;
        p0 = ((ElectricNode *)[_controlPoints objectAtIndex:idx]).position;
        
        if (i >= 1)
        {
            idx = (i - 1) >= controlPointsCount ? controlPointsCount - 1 : (i - 1);
            p1 = ((ElectricNode *)[_controlPoints objectAtIndex:idx]).position;
        }
        
        if (i >= 2)
        {
            idx = (i - 2) >= controlPointsCount ? controlPointsCount - 1 : (i - 2);
            p2 = ((ElectricNode *)[_controlPoints objectAtIndex:idx]).position;
        }
        if (i >= 3)
        {
            idx = (i - 3) >= controlPointsCount ? controlPointsCount - 1 : (i - 3);
            p3 = ((ElectricNode *)[_controlPoints objectAtIndex:idx]).position;
        }
        
        CGFloat amount = 0.0f;
        int randomOpacity = [self getRandomOpacity];
        for (int j = 0; j < self.segments; j++)
        {
            CGFloat pointX = [self catmullRom:amount p0:p0.x p1:p1.x p2:p2.x p3:p3.x];
            CGFloat pointY = [self catmullRom:amount p0:p0.y p1:p1.y p2:p2.y p3:p3.y];
            CCSprite *sprite = (CCSprite *)[_sprites objectAtIndex:(i - 2) * self.segments + j];
            sprite.position = ccp(pointX,pointY);
            sprite.opacity = randomOpacity;
            amount += step;
        }
    }
}

@end
