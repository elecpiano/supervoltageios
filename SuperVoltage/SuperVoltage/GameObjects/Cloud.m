//
//  Cloud.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-5.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation Cloud{
    CCLayer *_layer;
    CCParticleSystemQuad *tail;
}

#pragma mark - Lifecycle
-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *)spritesheet{
    if ((self = [super initWithLayer:layer])) {
        _layer = layer;
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Cloud.png"];
        self.sprite = [CCSprite spriteWithSpriteFrame:frame];
        [spritesheet addChild:self.sprite z:Z_INDEX_BONUS];
    }
    return self;
}

-(void)onExit{
    if (tail) {
        [tail removeFromParentAndCleanup:YES];
    }

    [super onExit];
}

#pragma mark - Cell
-(void)setAttachedToCell:(Cell *)attachedToCell{
    //before assign
    if (self.attachedToCell)
    {
        self.attachedToCell.attachedCloud = nil;
    }
    
    //assign new value
    [super setAttachedToCell:attachedToCell];
    
    //after assign
    if (self.attachedToCell)
    {
        self.attachedToCell.attachedCloud = self;
    }
}

#pragma mark - Position
-(void)appear{
    super.appearDuration = BONUS_MOVEMENT_DURATION;
    [super appear];
    GAME.awardingBonusesCount ++;
}

-(void)didAppear{
    GAME.awardingBonusesCount--;
    [self flicker];
}

#pragma mark - Burn
-(void)burn:(int)damage{
    [self collect];
}

-(void)didBurn{
    //virtual method
}

#pragma mark - Cloud Behavior

-(void)flicker{
    //opacity
    id fadeOutAction = [CCFadeTo actionWithDuration:CLOUD_FLICKER_INTERVAL opacity:128];
    id fadeInAction = [CCFadeTo actionWithDuration:CLOUD_FLICKER_INTERVAL opacity:255];
    id opacityActions = [CCSequence actions:fadeOutAction, fadeInAction, nil];
    //rotation
    id rotateAction1 = [CCRotateTo actionWithDuration:CLOUD_FLICKER_INTERVAL/6 angle:15];
    id rotateAction2 = [CCRotateTo actionWithDuration:CLOUD_FLICKER_INTERVAL/3 angle:-15];
    id rotateAction3 = [CCRotateTo actionWithDuration:CLOUD_FLICKER_INTERVAL/6 angle:0];
    id rotateActions = [CCSequence actions:rotateAction1, rotateAction2, rotateAction3, nil];
    
    id allActions = [CCSpawn actions:opacityActions, rotateActions, nil];
    
    id repeat = [CCRepeatForever actionWithAction:allActions];
    [self.sprite runAction:repeat];
}

-(void)collect{
    CGFloat distance_x = self.position.x - CLOUD_POINT.x;
    CGFloat distance_y = self.position.y - CLOUD_POINT.y;
    CGFloat distance = sqrtf(distance_x * distance_x + distance_y * distance_y);
    CGFloat duration = BONUS_MOVEMENT_DURATION * distance/(CELL_SIZE.width * 3);
    
//    _Twinkle = PickUpATwinkle();
    id moveAction = [CCMoveTo actionWithDuration:duration position:CLOUD_POINT];
    id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(didCollect)];
    id sequenceAction = [CCSequence actions:moveAction, callFuncAction, nil];
    [self.sprite runAction:sequenceAction];
    
    //tail
    id moveActionCopy = [moveAction copy];
    tail = [CCParticleSystemQuad particleWithFile:@"CloudTail.plist"];
    tail.position = self.position;
    [_layer addChild:tail z:Z_INDEX_BONUS];
    [tail runAction:moveActionCopy];
    
    [self setAttachedToCell:nil];
    
    //todo
//    PlayGiftCollectionSoundeEffect();
}

-(void)didCollect{
    [self.sprite stopAllActions];
    self.sprite.visible = NO;
    [tail stopSystem];
    [self performSelector:@selector(removeMe) withObject:self afterDelay:(tail.life + tail.lifeVar)];
    
    //todo
//    TopBar.Current.CollectGift(this);

}

-(void)removeMe{
    [self removeFromParentAndCleanup:YES];
}

-(void)abort{
    id expandAction = [CCScaleTo actionWithDuration:BONUS_MOVEMENT_DURATION scale:2];
    id shrinkAction = [CCScaleTo actionWithDuration:BONUS_MOVEMENT_DURATION scale:1.5];
    id scaleActions = [CCSequence actions:expandAction, shrinkAction, nil];
    id fadeOutAction = [CCFadeOut actionWithDuration:BONUS_MOVEMENT_DURATION*2];
    id spawnAction = [CCSpawn actions:scaleActions, fadeOutAction, nil];
    id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(didAbort)];
    id sequenceAction = [CCSequence actions:spawnAction, callFuncAction, nil];
    [self.sprite runAction:sequenceAction];
    
    //todo
    //    PlaySwallowSoundEffect();
}

-(void)didAbort{
    self.attachedToCell = nil;
    [self removeMe];
}

@end
