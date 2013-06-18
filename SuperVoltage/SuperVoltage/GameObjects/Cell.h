//
//  Cell.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-17.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SuperVoltageClasses.h"

@interface Cell : GameObject <CCTouchOneByOneDelegate>{
    
}

@property (nonatomic) int boardColumn;
@property (nonatomic) int boardRow;
@property (nonatomic) int cellRotation;

@property (nonatomic) CellType cellType;
@property (nonatomic) CellState cellState;

@property (nonatomic) BOOL antennaTop;
@property (nonatomic) BOOL antennaRight;
@property (nonatomic) BOOL antennaBottom;
@property (nonatomic) BOOL antennaLeft;

@property (nonatomic,strong) Cell *connectedCellTop;
@property (nonatomic,strong) Cell *connectedCellRight;
@property (nonatomic,strong) Cell *connectedCellBottom;
@property (nonatomic,strong) Cell *connectedCellLeft;

@property (nonatomic,strong) Monster *attachedMonster;
@property (nonatomic,strong) Cloud *attachedCloud;
@property (nonatomic,strong) Bomb *attachedBomb;

-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *) spritesheet;
-(void)rotateToQuartersImmediately:(int)quarters;
-(void)rotateByOneQuarter;
-(NSMutableArray *)collectConnectedCells;
-(void)updateCellState:(BOOL)leftConnected connectedToRight:(BOOL)rightConnected;

-(void)prepareToAppear;
-(CGPoint)whereItShouldBe;
-(void)goToWhereItShouldBe:(ccTime)duration;
-(void)dropTo:(int)targetRow;
-(void)fill;

-(void)burnFrom:(Direction)burnFrom electricFlow:(ElectricFlow *)passingInElectricFlow;
-(void)didBurn;
-(void)bomb;
-(void)didBomb;

@end
