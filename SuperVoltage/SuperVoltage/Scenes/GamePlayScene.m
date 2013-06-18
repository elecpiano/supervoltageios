//
//  GamePlayScene.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-17.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation GamePlayScene{
    
}

#pragma mark - Lifecycle

static GamePlayScene *instance;
+(GamePlayScene *)sharedInstance{
    @synchronized(self)
    {
        if (!instance){
            instance = [GamePlayScene node];
        }
        return instance;
    }
}

-(id)init{
    self = [super init];
    if (self!=nil) {
//        [self addChild:[TestLayer node] z:1];
        [self addChild:BOARD];
        [self scheduleUpdate];
    }
    return self;
}

-(void)onExit{
    instance = nil;
    [super onExit];
}

#pragma mark - GameState

//static GameState _gameState = GameState_Idle;
//+(GameState)gameState{
//    @synchronized(self){
//        return _gameState;
//    }
//}
//
//+(void)setGameState:(GameState)gameState{
//    @synchronized(self){
//        _gameState = gameState;
//    }
//}

#pragma mark - Update

-(void)update:(ccTime)delta{
    [self updateBurning];
    [self updateDropping];
    [self updateFilling];
    [self updateMonsterMoving];
    [self updateBonus];
    [self updateBombing];
}

-(void)updateBurning{
    if (GAME.gameState == GameState_Burning)
    {
        if (GAME.burningCellsCount == 0)
        {
            /* try start bombing, if no bomb triggered, start dropping. */
            if (![self tryStartBomb])
            {
                [self drop];
            }
        }
    }
}

-(void)drop{
    //todo
    GAME.droppingCellsCount = [BOARD dropCells];
    GAME.gameState = GameState_Dropping;
}

-(void)updateDropping{
    if (GAME.gameState == GameState_Dropping)
    {
        if (GAME.droppingCellsCount == 0)
        {
            [self fill];
        }
    }
}

-(void)fill{
    GAME.fillingCellsCount = [BOARD fillMatrix];
    GAME.gameState = GameState_Filling;
}

-(void)updateFilling{
    if (GAME.gameState == GameState_Filling)
    {
        if (GAME.fillingCellsCount == 0)
        {
            BOOL hintDetected = [BOARD refreshMatrix:nil];
            if(hintDetected){
                /* setting the GameState to Chain will not halt the game forever,
                 * since the hint is shown, the firestarter cell will
                 * be calculating the hint duration and set up a fire spontaneously,
                 * setting the GameState to Burning. */
                GAME.gameState = GameState_Chain;
            }
            else if ([BOARD isGameOver]) {
                [BOARD gameOver];
            }
            else{
                [self moveMonsters];
            }
        }
    }
}

-(void)moveMonsters{
    [BOARD moveMonsters];
    GAME.gameState = GameState_MonsterMoving;
}

-(void)updateMonsterMoving{
    if (GAME.gameState == GameState_MonsterMoving) {
        if (GAME.movingMonstersCount == 0) {
            /* try start bombing, if no bomb triggered, start awarding. */
            if (![self tryStartBomb])
            {
                [self awardBonus];
            }
        }
    }
}

-(void)awardBonus{
    [BOARD awardBonus];
    GAME.gameState = GameState_BonusAwarding;
}

-(void)updateBonus{
    if (GAME.gameState == GameState_BonusAwarding) {
        if (GAME.awardingBonusesCount == 0) {
            GAME.gameState = GameState_Idle;
        }
    }
}

-(BOOL)tryStartBomb{
    return [BOARD tryStartBomb];
}

-(void)updateBombing{
    if (GAME.gameState == GameState_Bombing)
    {
        if (GAME.explodingBombCount == 0)
        {
            [self drop];
//            /* a bomb explosion may trigger another bomb, so let's check again */
//            if (![self tryStartBomb])
//            {
//                [self drop];
//            }
        }
    }
}

@end
