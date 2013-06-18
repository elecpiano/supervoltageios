//
//  GameObject.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-17.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation GameObject

-(id)initWithLayer:(CCLayer *)layer{
    self = [super init];
    if (self) {
        [layer addChild:self];
    }
    return self;
}

-(void)onExit{
    [self.sprite removeFromParentAndCleanup:YES];
}

-(void)setPosition:(CGPoint)position{
    self.sprite.position = position;
    [super setPosition:position];
}

-(CGPoint)position{
    return self.sprite.position;
}

-(BOOL)containsTouch:(UITouch *)touch{
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint point = [[CCDirector sharedDirector] convertToGL:location];
    CGRect rect = [self.sprite boundingBox];
    return CGRectContainsPoint(rect, point);
}

@end
