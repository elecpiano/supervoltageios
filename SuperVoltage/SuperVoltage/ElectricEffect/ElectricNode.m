//
//  ElectricNode.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-26.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "ElectricNode.h"

@implementation ElectricNode{
//    [sprite1 setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];  // example of additive blending
}

#pragma mark - Constructor

-(id)initWithFiducialPoint:(CGPoint)fiducialPoint radius:(CGFloat)radius speedFactor:(CGFloat)speedFactor {
    if ((self = [super init])) {
        self.fiducialPoint = fiducialPoint;
        self.radius = radius;
        self.speedFactor = speedFactor;
        
        [self reset];
    }
    return self;
}

#pragma mark - Update

-(void)update:(ccTime)delta{
    if (movementX < targetX && movementY < targetY && movementTime < movementDuration)
    {
        CGFloat fraction = delta/movementDuration;
        CGFloat deltaX = self.velocity.x * fraction;
        CGFloat deltaY = self.velocity.y * fraction;
        self.position = ccp(self.position.x + deltaX, self.position.y + deltaY);
        
        movementX += ABS(deltaX);
        movementY += ABS(deltaY);
        movementTime += delta;
    }
    else
    {
        [self reset];
    }
}

#pragma mark - Movement

static CGFloat minVelocityFactor = 1;
CGFloat movementTime = 0;
CGFloat movementDuration = 0;

CGFloat targetX = 0;
CGFloat targetY = 0;
CGFloat movementX = 0;
CGFloat movementY = 0;

-(void)reset{
    //reset position
    self.position = self.fiducialPoint;
    
    //random angle
    int angle = arc4random() % 360;
    CGFloat radian = CC_DEGREES_TO_RADIANS(angle);
    
    //target point
    targetX = self.radius * cosf(radian);
    targetY = self.radius * sinf(radian);
    
//    if (targetX<0) {
//        CGFloat xxx = ABS(targetX);
//        xxx = 0;
//    }
    
    //velocity
    CGFloat speedToDistance = (CCRANDOM_0_1()+minVelocityFactor)* self.speedFactor;
//    if (speedToDistance<minVelocityFactor) {
//        speedToDistance = minVelocityFactor;
//    }
    CGFloat velocityX = speedToDistance * targetX;
    CGFloat velocityY = speedToDistance * targetY;
    self.velocity = ccp(velocityX,velocityY);
    
    //duration
    movementDuration = 1 / speedToDistance;
    movementTime = 0;
    
    targetX = ABS(targetX);
    targetY = ABS(targetY);
    movementX = 0;
    movementY = 0;
}

@end
