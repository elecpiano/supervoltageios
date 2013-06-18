//
//  GamePlayScene.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-17.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SuperVoltageClasses.h"

@interface GamePlayScene : CCScene {
    
}

@property (nonatomic) GameState gameState;
@property (nonatomic) int burningCellsCount;
@property (nonatomic) int droppingCellsCount;
@property (nonatomic) int fillingCellsCount;
@property (nonatomic) int movingMonstersCount;
@property (nonatomic) int awardingBonusesCount;
@property (nonatomic) int explodingBombCount;

+(GamePlayScene *)sharedInstance;
//+(GameState)gameState;
//+(void)setGameState:(GameState)gameState;

@end
