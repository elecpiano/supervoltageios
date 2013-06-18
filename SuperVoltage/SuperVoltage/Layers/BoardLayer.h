//
//  BoardLayer.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-23.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SuperVoltageClasses.h"

@interface BoardLayer : CCLayer {
    
}

//@property (nonatomic,strong) NSMutableArray *allCells;
@property (nonatomic,strong) Cell *fireStarter;
@property (nonatomic,strong) ElectricEffect *electricEffect;
@property (nonatomic) int currentRoundMonsterKillCount;
@property (nonatomic) int successiveBurnCount;
@property (nonatomic,strong) NSMutableArray *triggeredBombs;
@property (nonatomic,strong) NSMutableArray *explodingBombs;
@property (nonatomic,strong) NSMutableArray *bombingTargets;

+(BoardLayer *)sharedInstance;
-(Cell *)cellAtMatrix:(int)row column:(int)column;
-(void)setCellAtMatrix:(Cell *)cell row:(int)row column:(int)column;
-(void)buildTree:(Cell *)cell forTree:(NSMutableArray *)connectionTree leftConnectionDetector:(BOOL *)leftBorderConnected rightConnectionDetector:(BOOL *)rightBorderConnected;
-(BOOL)refreshMatrix:(Cell *)exceptForCell;
-(void)updateCellCountForType:(CellType)cellType increasing:(BOOL)increasing;
-(int)dropCells;
-(int)fillMatrix;
-(void)setFire:(Cell *)fireStarter dischargeBatteryAfterBurn:(BOOL)toDischarge;
-(void)removeCell:(Cell *)cell;
-(void)sparkleFlash:(Cell *)cell;
-(void)moveMonsters;
-(void)removeMonster:(Monster *)monster;
-(void)showScore:(int)score at:(CGPoint)showPosition;
-(void)awardBonus;
-(BOOL)tryStartBomb;
-(BOOL)isGameOver;
-(void)gameOver;

@end
