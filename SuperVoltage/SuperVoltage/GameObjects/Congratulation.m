//
//  Bonus.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-2.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation Congratulation

#pragma mark - Lifecycle
-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *)spritesheet bonusType:(BonusType)bonusType{
    if ((self = [super initWithLayer:layer])) {
        self.sprite = [CCSprite spriteWithSpriteFrame:[self frameFromBonusType:bonusType]];
        [spritesheet addChild:self.sprite z:Z_INDEX_CONGRATULATION];
    }
    return self;
}

-(CCSpriteFrame *)frameFromBonusType:(BonusType)bonusType{
    CCSpriteFrame *frame;
    NSString *frameName;
    switch (bonusType) {
        case BonusType_Combo:
            frameName = @"Combo.png";
            break;
        case BonusType_Chain:
            frameName = @"Chain.png";
            break;
        default:
            break;
    }
    
    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    return frame;
}

#pragma mark - Show & Hide
-(void)show{
    self.sprite.scale = 0;
    self.position = ccp(WIN_SIZE.width/2,WIN_SIZE.height/2);  
    
    id expandAction = [CCScaleTo actionWithDuration:CONGRATULATION_ACTION_DURATION scale:1.5];
    id fadeInAction = [CCFadeIn actionWithDuration:CONGRATULATION_ACTION_DURATION];
    id spawnAction1 = [CCSpawn actions:expandAction, fadeInAction, nil];
    id shrinkAction = [CCScaleTo actionWithDuration:CONGRATULATION_ACTION_DURATION scale:1];
    id moveUpAction = [CCMoveBy actionWithDuration:CONGRATULATION_ACTION_DURATION position:ccp(0, self.sprite.contentSize.height)];
    id fadeOutAction = [CCFadeOut actionWithDuration:CONGRATULATION_ACTION_DURATION];
    id spawnAction2 = [CCSpawn actions: moveUpAction, fadeOutAction, nil];
    id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(didShow)];
    id sequenceAction = [CCSequence actions:spawnAction1, shrinkAction, spawnAction2,callFuncAction, nil];
    
    [self.sprite runAction:sequenceAction];
}

-(void)didShow{
    [self removeFromParentAndCleanup:YES];
}

@end









