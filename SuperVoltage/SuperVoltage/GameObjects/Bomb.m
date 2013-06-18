//
//  Cloud.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-5.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation Bomb{
    CCSpriteBatchNode *_spritesheet;
    
    CCSprite *flameSpriteH;
    CCSprite *flameSpriteV;
    CCSprite *flameSpriteM;
    CGFloat scaleFactor;
}

#pragma mark - Lifecycle
-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *)spritesheet{
    if ((self = [super initWithLayer:layer])) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Bomb.png"];
        self.sprite = [CCSprite spriteWithSpriteFrame:frame];
        [spritesheet addChild:self.sprite z:Z_INDEX_BONUS];
        _spritesheet = spritesheet;
    }
    return self;
}

-(void)update:(ccTime)delta{
    [self updateExplode:delta];
}

-(void)onExit{
    if (flameSpriteH) {
        [flameSpriteH removeFromParentAndCleanup:YES];
    }
    if (flameSpriteV) {
        [flameSpriteV removeFromParentAndCleanup:YES];
    }
    if (flameSpriteM) {
        [flameSpriteM removeFromParentAndCleanup:YES];
    }
    [super onExit];
}

#pragma mark - Cell
-(void)setAttachedToCell:(Cell *)attachedToCell{
    //before assign
    if (self.attachedToCell)
    {
        self.attachedToCell.attachedBomb = nil;
    }
    
    //assign new value
    [super setAttachedToCell:attachedToCell];
    
    //after assign
    if (self.attachedToCell)
    {
        self.attachedToCell.attachedBomb = self;
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
}

#pragma mark - Burn
-(void)burn:(int)damage{
    [self trigger];
}

-(void)didBurn{
    //virtual method
}

#pragma mark - Bomb Behavior

-(void)trigger{
    [BOARD.triggeredBombs addObject:self];
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"BombTriggered.png"];
    [self.sprite setDisplayFrame:frame];
    id shrinkAction = [CCScaleTo actionWithDuration:BONUS_MOVEMENT_DURATION scale:0.5];
    [self.sprite runAction:shrinkAction];
}

-(void)initFlame:(CCSpriteBatchNode *)spritesheet{    
    CCSpriteFrame *frame;
    
    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"BombFlameH.png"];
    flameSpriteH = [CCSprite spriteWithSpriteFrame:frame];
    flameSpriteH.scaleX = WIN_SIZE.width / flameSpriteH.contentSize.width;
    flameSpriteH.position = ccp(WINCENTER.x,self.position.y);
    [spritesheet addChild:flameSpriteH z:Z_INDEX_BOMB_FLAME];
    
    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"BombFlameV.png"];
    flameSpriteV = [CCSprite spriteWithSpriteFrame:frame];
    flameSpriteV.scaleY = WIN_SIZE.height / flameSpriteV.contentSize.width;
    flameSpriteV.position = ccp(self.position.x, WINCENTER.y);
    [spritesheet addChild:flameSpriteV z:Z_INDEX_BOMB_FLAME];
    
    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"BombFlameM.png"];
    flameSpriteM = [CCSprite spriteWithSpriteFrame:frame];
    flameSpriteM.position = self.position;
    [spritesheet addChild:flameSpriteM z:Z_INDEX_BOMB_FLAME];
    
    scaleFactor = 1;
}

-(void)explode{
    if (self.exploded) {
        return;
    }
    self.exploded = YES;
    [BOARD.explodingBombs addObject:self];    
    [self initFlame:_spritesheet];
    GAME.explodingBombCount++;
    self.sprite.visible = NO;
    [self scheduleUpdate];
    
    Cell *target;
    //target cells on the left
    for (int column = 0; column < self.boardColumn; column++)
    {
        target = CELL_AT_MATRIX(self.boardRow, column);
        if (target && ![BOARD.bombingTargets containsObject:target])
        {
            [BOARD.bombingTargets addObject:target];
            [target bomb];
        }
    }
    
    //target cells on the right (including itself)
    for (int column = self.boardColumn; column < BOARD_COLUMN_COUNT; column++)
    {
        target = CELL_AT_MATRIX(self.boardRow, column);
        if (target && ![BOARD.bombingTargets containsObject:target])
        {
            [BOARD.bombingTargets addObject:target];
            [target bomb];
        }
    }
    
    //target cells below
    for (int row = 0; row < self.boardRow; row++)
    {
        target = CELL_AT_MATRIX(row, self.boardColumn);
        if (target && ![BOARD.bombingTargets containsObject:target])
        {
            [BOARD.bombingTargets addObject:target];
            [target bomb];
        }
    }
    
    //target cells above
    for (int row = (self.boardRow+1); row < BOARD_ROW_COUNT; row++)
    {
        target = CELL_AT_MATRIX(row, self.boardColumn);
        if (target && ![BOARD.bombingTargets containsObject:target])
        {
            [BOARD.bombingTargets addObject:target];
            [target bomb];
        }
    }
}

-(void)didExplode{
    [self unscheduleUpdate];
    self.attachedToCell = nil;
    self.exploded = NO;
    [self removeFromParentAndCleanup:YES];
}

-(void)updateExplode:(ccTime)delta{
    //    if (explodeTime<BOMBING_FLASH_INTERVAL) {
    //        explodeTime += delta;
    //    }
    //    else
    //    {
    //
    //    }
    if (scaleFactor == 1) {
        scaleFactor = 1.3;
    }
    else {
        scaleFactor = 1;
    }
    flameSpriteH.scaleY = scaleFactor;
    flameSpriteV.scaleX = scaleFactor;
    flameSpriteM.scaleX = flameSpriteM.scaleY = scaleFactor;
    //    explodeTime = 0;
}

@end
