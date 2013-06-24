//
//  CoolButton.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-20.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "CoolButton.h"


@implementation CoolButton{
    CCSprite *aThirdSprite;
}

#pragma mark - Lifecycle
+(id)itemWithFile:(NSString *)image block:(void(^)(id sender))block{
    return [[self alloc] initWithFile:image block:block];
}

-(id)initWithFile:(NSString *)image block:(void(^)(id sender))block{
    if ((self = [super init])) {
        self.normalImage = [CCSprite spriteWithFile:image];
//        self.selectedImage = [CCSprite spriteWithFile:image];
        
        aThirdSprite = [CCSprite spriteWithFile:image];
        aThirdSprite.opacity = 0.5;
        aThirdSprite.visible = NO;
        [self addChild:aThirdSprite z:0];
        aThirdSprite.position = ccp(self.normalImage.contentSize.width/2, self.normalImage.contentSize.height/2);
        
        _block = block;
    }
    return self;
}

#pragma mark - Button Behavior
-(void)activate{
    [self performSelector:@selector(executeBlock) withObject:nil afterDelay:0.2];
}

-(void)executeBlock{
    [super activate];
}

-(void)selected{
    self.scale = 0.8;
    [self showHint];
    [super selected];
}

-(void)unselected{
    self.scale = 1;
    [super unselected];
}

-(void)showHint{
    id expandAction = [CCScaleTo actionWithDuration:0.3 scale:3];
    id fadeOutAction = [CCFadeOut actionWithDuration:0.3];
    id spawnAction = [CCSpawn actions:expandAction, fadeOutAction, nil];
    id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(didShowHint)];
    id sequenceAction = [CCSequence actions:spawnAction, callFuncAction, nil];
    aThirdSprite.visible = YES;
    [aThirdSprite runAction:sequenceAction];
}

-(void)didShowHint{
    aThirdSprite.visible = NO;
    aThirdSprite.scale = 1;
    aThirdSprite.opacity = 0.5;
}

@end
