//
//  Monster.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-31.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation Monster{
    //    NSString *self.spriteFrameName_Base;
    //    NSString *self.spriteFrameName_Normal;
    //    NSString *self.spriteFrameName_Angry;
    //    NSString *self.spriteFrameName_Shock1;
    //    NSString *self.spriteFrameName_Shock2;
    
    CCSprite *sprite_EyeOpen;
    CCSprite *sprite_EyeClosed;
    //    CCSpriteFrame *spriteFrame_EyeOpen;
    //    CCSpriteFrame *spriteFrame_EyeClosed;
    
    BOOL isAngry;
    
    ccTime blinkTime;
    ccTime blinkInterval;
    ccTime eyeCloseDuration;
    
    ccTime eyeRotationInterval;
    ccTime sinceLastEyeRotation;
    CGPoint eyePositionOffset;
    
    BOOL eyeClosed;
    
    ccTime burningTime;
    BOOL isBurning;
    BOOL flashingSwitch;
}

#pragma mark - Lifecycle
-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *)spritesheet monsterType:(MonsterType)monsterType{
    if ((self = [super initWithLayer:layer])) {
        [self resetWithMonsterType:monsterType];
        [spritesheet addChild:self.sprite z:Z_INDEX_MONSTER];
        [self initEyes:spritesheet];
        
        self.shouldMoveForward = YES;
    }
    return self;
}

-(void)onEnter{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [self scheduleUpdate];
	[super onEnter];
}

-(void)update:(ccTime)delta{
    if (isBurning) {
        [self updateBurn:delta];
    }
    else{
        [self updateEyes:delta];
    }
}

-(void)onExit{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self unscheduleUpdate];
    [sprite_EyeOpen removeFromParentAndCleanup:YES];
    [sprite_EyeClosed removeFromParentAndCleanup:YES];
    [super onExit];
}

#pragma mark - Monster Type
-(void)resetWithMonsterType:(MonsterType)monsterType{
    self.monsterType = monsterType;
    
    switch (monsterType) {
        case MonsterType_Small:
            self.health = 1;
            self.movingSpeedV = 1;
            self.movingSpeedH = 0;
            self.spriteFrameName_Base = @"Monster_1_";
            break;
        case MonsterType_Drunk:
            self.health = 1;
            self.movingSpeedV = 1;
            self.movingSpeedH = 1;
            self.spriteFrameName_Base = @"Monster_2_";
            break;
        case MonsterType_Strong:
            self.health = 2;
            self.movingSpeedV = 1;
            self.movingSpeedH = 0;
            self.spriteFrameName_Base = @"Monster_3_";
            break;
        case MonsterType_Fast:
            self.health = 1;
            self.movingSpeedV = 2;
            self.movingSpeedH = 0;
            self.spriteFrameName_Base = @"Monster_5_";
            break;
        case MonsterType_Queen:
            self.health = 1;
            self.movingSpeedV = 1;
            self.movingSpeedH = 0;
            self.spriteFrameName_Base = @"Monster_8_";
            break;
        case MonsterType_King:
            self.health = 2;
            self.movingSpeedV = 2;
            self.movingSpeedH = 1;
            self.spriteFrameName_Base = @"Monster_6_";
            break;
        default:
            break;
    }
    
    NSString *spriteFrameName_Normal = [NSString stringWithFormat:@"%@%@", self.spriteFrameName_Base,@"normal.png"];
    NSString *spriteFrameName_Angry = [NSString stringWithFormat:@"%@%@", self.spriteFrameName_Base,@"angry.png"];
    NSString *spriteFrameName_Shock1 = [NSString stringWithFormat:@"%@%@", self.spriteFrameName_Base,@"shock_1.png"];
    NSString *spriteFrameName_Shock2 = [NSString stringWithFormat:@"%@%@", self.spriteFrameName_Base,@"shock_2.png"];
    
    self.spriteFrame_Normal = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName_Normal];
    self.spriteFrame_Angry = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName_Angry];
    self.spriteFrame_Shock1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName_Shock1];
    self.spriteFrame_Shock2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName_Shock2];
    
    self.sprite = [CCSprite spriteWithSpriteFrame:self.spriteFrame_Normal];
}

-(void)weaken{    
    switch (self.monsterType) {
        case MonsterType_Strong:
            self.spriteFrameName_Base = @"Monster_4_";
            break;
        case MonsterType_King:
            self.spriteFrameName_Base = @"Monster_7_";
            break;
        default:
            break;
    }
    
    NSString *spriteFrameName_Normal = [NSString stringWithFormat:@"%@%@", self.spriteFrameName_Base,@"normal.png"];
    NSString *spriteFrameName_Angry = [NSString stringWithFormat:@"%@%@", self.spriteFrameName_Base,@"angry.png"];
    NSString *spriteFrameName_Shock1 = [NSString stringWithFormat:@"%@%@", self.spriteFrameName_Base,@"shock_1.png"];
    NSString *spriteFrameName_Shock2 = [NSString stringWithFormat:@"%@%@", self.spriteFrameName_Base,@"shock_2.png"];
    
    self.spriteFrame_Normal = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName_Normal];
    self.spriteFrame_Angry = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName_Angry];
    self.spriteFrame_Shock1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName_Shock1];
    self.spriteFrame_Shock2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName_Shock2];
    
//    [self.sprite setDisplayFrame:self.spriteFrame_Normal];
}

#pragma mark - Touch
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (GAME.gameState != GameState_Idle) {
        return YES;
    }
    if ([self containsTouch:touch] ) {
        [self getAngry];
        return YES;
    }
    return NO;
}

#pragma mark - Cell
-(void)setAttachedToCell:(Cell *)attachedToCell{
    //before assign
    if (self.attachedToCell)
    {
        self.attachedToCell.attachedMonster = nil;
    }
    
    //assign new value
    [super setAttachedToCell:attachedToCell];
    
    //after assign
    if (self.attachedToCell)
    {
        self.attachedToCell.attachedMonster = self;
    }
}

#pragma mark - Position
-(void)appear{
    super.appearDuration = MONSTER_MOVING_DURATION;
    [super appear];
    GAME.movingMonstersCount ++;
}

-(void)didAppear{
    GAME.movingMonstersCount--;
}

-(void)moveForward{
    if (!self.shouldMoveForward) {
        self.ShouldMoveForward = YES;
        return;
    }
    
    NSMutableArray *targetCells = [[NSMutableArray alloc] init];
    Cell *cell;
    // vertical move
    int stepV = self.movingSpeedV;
    int targetCellRow = [self boardRow] - stepV;
    
    if (targetCellRow<0) {
        [self escape];
    }
    else
    {
        while (stepV>0) {
            targetCellRow = [self boardRow] - stepV;
            if (self.movingSpeedH>0) {
                Cell *leftCell;
                Cell *rightCell;
                if ([self boardColumn]<(BOARD_COLUMN_COUNT - 1)) { /* not the right-most */
                    leftCell = CELL_AT_MATRIX(targetCellRow, ([self boardColumn] + 1));
                }
                if ([self boardColumn]>0) { /* not the left-most */
                    rightCell = CELL_AT_MATRIX(targetCellRow, ([self boardColumn] - 1));
                }
                
                int leftOrRight = arc4random() % 2; // 0 for leftFirst, 1 for rightFirst
                if (leftOrRight == 0) { // left first
                    if (leftCell) {
                        [targetCells addObject:leftCell];
                    }
                    else if (rightCell){
                        [targetCells addObject:rightCell];
                    }
                }
                else{ // right first
                    if (rightCell) {
                        [targetCells addObject:rightCell];
                    }
                    else if (leftCell){
                        [targetCells addObject:leftCell];
                    }
                }
            }
            
            cell = CELL_AT_MATRIX(targetCellRow, [self boardColumn]);
            [targetCells addObject:cell];
            
            stepV--;
        }
        
        /* the target cells are added in the order of priority, so let's always try to check the first cell target,
         * which has the highest priority among the candidates */
        
        while ([targetCells count] > 0) {
            cell = [targetCells objectAtIndex:0];
            if (!cell.attachedMonster) {
                self.attachedToCell = cell;
                break;
            }
            [targetCells removeObject:cell];
        }
        
        id moveAction = [CCMoveTo actionWithDuration:MONSTER_MOVING_DURATION position:[self whereItShouldBe]];
        id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(didMoveForward)];
        id sequenceAction = [CCSequence actions:moveAction, callFuncAction ,nil];
        [self runAction:sequenceAction];
        GAME.movingMonstersCount ++;
    }
}

-(void)didMoveForward{
    [self checkBonusCollision];
    GAME.movingMonstersCount--;
}

-(void)checkBonusCollision{
    if (self.attachedToCell.attachedCloud){
        [self.attachedToCell.attachedCloud abort];
    }
    else if (self.attachedToCell.attachedBomb){
        [self.attachedToCell.attachedBomb trigger];
    }
}

#pragma mark - Health

#pragma mark - Emotion
-(void)getAngry{
    if (isAngry)
    {
        return;
    }
    
    [self hideEyes];
    [self.sprite setDisplayFrame:self.spriteFrame_Angry];
    
    isAngry = true;
    
    id scaleAction1 = [CCScaleTo actionWithDuration:MONSTER_MOVING_DURATION/2 scale:1.75];
    id delayAction = [CCDelayTime actionWithDuration:MONSTER_ANGRY_DURATION];
    id scaleAction2 = [CCScaleTo actionWithDuration:MONSTER_MOVING_DURATION/2 scale:1];
    id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(didAngry)];
    id sequenceAction = [CCSequence actions:scaleAction1, delayAction, scaleAction2, callFuncAction, nil];
    
    [self.sprite runAction:sequenceAction];
    
    //    //todo - audio
    //    var sei = SE_Bark.CreateInstance();
    //    sei.Volume = App.SoundEffectVolume;
    //    sei.Play();
}

-(void)didAngry{
    [self.sprite setDisplayFrame:self.spriteFrame_Normal];
    [self showEyes];
    isAngry = NO;
}

#pragma mark - Eye

-(void)initEyes:(CCSpriteBatchNode *)spritesheet{
    blinkTime = 0;
    blinkInterval = 3;
    eyeCloseDuration = 0.5;
    
    eyeRotationInterval = 1;
    sinceLastEyeRotation = 0;
    
    CCSpriteFrame *frame;
    
    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Monster_eye_open.png"];
    sprite_EyeOpen = [CCSprite spriteWithSpriteFrame:frame];
    [spritesheet addChild:sprite_EyeOpen z:Z_INDEX_MONSTER_EYE];
    
    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Monster_eye_closed.png"];
    sprite_EyeClosed = [CCSprite spriteWithSpriteFrame:frame];
    [spritesheet addChild:sprite_EyeClosed z:Z_INDEX_MONSTER_EYE];
    sprite_EyeClosed.visible = NO;
}

-(void)updateEyes:(ccTime)delta{
    if (isAngry) {
        return;
    }
    
    if (eyeClosed)
    {
        if (blinkTime < eyeCloseDuration)
        {
            blinkTime += delta;
        }
        else
        {
            blinkTime = 0;
            blinkInterval = CCRANDOM_0_1()*2 + 1; //TimeSpan.FromMilliseconds(Global.Random.Next(2000, 3000));
            [self openEyes];
            eyeClosed = NO;
        }
    }
    else
    {
        if (blinkTime < blinkInterval)
        {
            blinkTime += delta;
            if (sinceLastEyeRotation < eyeRotationInterval)
            {
                sinceLastEyeRotation += delta;
            }
            else
            {
                sinceLastEyeRotation = 0;
                eyeRotationInterval = CCRANDOM_0_1()*0.5 + 0.5; // TimeSpan.FromMilliseconds(Global.Random.Next(500, 1000));
                int randomX = CCRANDOM_MINUS1_1()*3;
                int randomY = CCRANDOM_MINUS1_1()*3;
                eyePositionOffset = ccp(randomX, randomY);
            }
        }
        else
        {
            blinkTime = 0;
            eyeCloseDuration = CCRANDOM_0_1()*0.4 + 0.1; // TimeSpan.FromMilliseconds(Global.Random.Next(100, 500));
            [self closeEyes];
            eyePositionOffset = ccp(0, 0);
            eyeClosed = true;
        }
    }
    
    sprite_EyeOpen.position = ccp(self.position.x + eyePositionOffset.x, self.position.y + eyePositionOffset.y);
    sprite_EyeClosed.position = self.position;
}

-(void)openEyes{
    sprite_EyeOpen.visible = YES;
    sprite_EyeClosed.visible = NO;
}

-(void)closeEyes{
    sprite_EyeOpen.visible = NO;
    sprite_EyeClosed.visible = YES;
}

-(void)showEyes{
    sprite_EyeOpen.visible = YES;
    sprite_EyeClosed.visible = NO;
}

-(void)hideEyes{
    sprite_EyeOpen.visible = NO;
    sprite_EyeClosed.visible = NO;
}

#pragma mark - Burn

//Action ShockCompleted = null;

-(void)burn:(int)damage{
    self.health -= damage;
    
    //start flashing
    [self hideEyes];
    burningTime = 0;
    [self flash];
    isBurning = YES;
}

-(void)updateBurn:(ccTime)delta{
    if (burningTime < MONSTER_FLASHING_INTERVAL)
    {
        burningTime += delta;
    }
    else
    {
        burningTime = 0;
        [self flash];
    }
}

-(void)flash{
    if (flashingSwitch)
    {
        [self.sprite setDisplayFrame:self.spriteFrame_Shock1];
    }
    else
    {
        [self.sprite setDisplayFrame:self.spriteFrame_Shock2];
    }
    flashingSwitch = !flashingSwitch;
}

-(void)didBurn{
    isBurning = NO;
    if (self.health > 0)
    {
        /*still alive, back to normal */
        [self weaken];
        [self.sprite setDisplayFrame:self.spriteFrame_Normal];
        [self showEyes];

        //        if (self.monsterType == .MonsterType_Queen)
        //        {
        //            TurnIntoRandomMonster();
        //        }
    }
    else
    {
        [self die];
    }
}

-(void)die{
    //todo
    //    AddScore();
    //    DisposeEyes();
    self.attachedToCell = nil;
    BOARD.currentRoundMonsterKillCount++;
    
    [self addScore];
    [self removeMe];
    
    //    if (!CoreLogic.SpecialWeaponUsed)
    //    {
    //        CoreLogic.CurrentRoundEnemyKill++;
    //    }
}

-(void)escape{
    CGPoint point = ccp(self.position.x, 0 - CELL_SIZE.height);
    
    id moveAction = [CCMoveTo actionWithDuration:MONSTER_MOVING_DURATION position:point];
    id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(didEscape)];
    id sequenceAction = [CCSequence actions:moveAction, callFuncAction, nil];
    [self runAction:sequenceAction];
    
    //    Fade(255, 0, Global.BUG_MOVING_DURATION);
    self.attachedToCell = nil;
    
    //    if (CoreLogic.CurrentGameLevel.Health > 0)
    //    {
    //        TopBar.Current.DecreaseHealth(this.Health);
    //    }
    
    //    /* show escape warning */
    //    (LightsUp.GamePage.Current as LightsUp.GamePage).WarnEscape();
}

-(void)didEscape{
    [self removeMe];
}

-(void)removeMe{
    [BOARD removeMonster:self];
    [self removeFromParentAndCleanup:YES];
}

#pragma makr - Score
-(void)addScore{
    int unitScore = 100;
    switch (self.monsterType)
    {
        case MonsterType_Small:
            unitScore = 100;
            break;
        case MonsterType_Drunk:
            unitScore = 200;
            break;
        case MonsterType_Strong:
            unitScore = 300;
            break;
        case MonsterType_Fast:
            unitScore = 300;
            break;
        case MonsterType_Queen:
            unitScore = 400;
            break;
        case MonsterType_King:
            unitScore = 500;
            break;
        default:
            break;
    }
    
    [BOARD showScore:unitScore at:self.position];
    
    //    todo
    //    TopBar.Current.AddScore(unitScore);
}

@end
