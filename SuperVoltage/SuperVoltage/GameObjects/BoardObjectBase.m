//
//  Monster.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-31.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation BoardObjectBase{

}

#pragma mark - Lifecycle

#pragma mark - Cell

#pragma mark - Position
-(int)boardRow{
    if (self.attachedToCell) {
        return self.attachedToCell.boardRow;
    }
    return 0;
}

-(int)boardColumn{
    if (self.attachedToCell) {
        return self.attachedToCell.boardColumn;
    }
    return 0;
}

-(CGPoint)whereItShouldBe{
    return ccp(CELL_SIZE.width * [self boardColumn] + BOARD_ORIGIN.x, CELL_SIZE.height * [self boardRow] + BOARD_ORIGIN.y);
}

-(void)goToWhereItShouldBe:(ccTime)duration{
    CCMoveTo *action = [CCMoveTo actionWithDuration:duration position:[self whereItShouldBe]];
    [self runAction:action];
}

-(void)prepareToAppear{
    CGPoint point = ccp(BOARD_ORIGIN.x + CELL_SIZE.width * [self boardColumn], BOARD_ORIGIN.y + CELL_SIZE.height*BOARD_ROW_COUNT);
    [self setPosition:point];
}

-(void)appear{
    id moveAction = [CCMoveTo actionWithDuration:self.appearDuration position:[self whereItShouldBe]];
    id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(didAppear)];
    id sequenceAction = [CCSequence actions:moveAction, callFuncAction ,nil];
    [self runAction:sequenceAction];
}

-(void)didAppear{
    //virtual method
}

#pragma mark - Burn
-(void)burn:(int)damage{
    //virtual method
}

-(void)didBurn{
    //virtual method
}

@end
