//
//  Monster.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-31.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SuperVoltageClasses.h"

@interface BoardObjectBase : GameObject

@property (nonatomic,strong) Cell *attachedToCell;
@property (nonatomic) CGFloat appearDuration;

-(int)boardRow;
-(int)boardColumn;
-(CGPoint)whereItShouldBe;
-(void)goToWhereItShouldBe:(ccTime)duration;
-(void)prepareToAppear;
-(void)appear;
-(void)didAppear;
-(void)burn:(int)damage;
-(void)didBurn;

@end
