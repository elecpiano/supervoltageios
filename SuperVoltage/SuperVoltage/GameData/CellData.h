//
//  CellData.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-22.
//  Copyright (c) 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperVoltageClasses.h"

@interface CellData : NSObject

@property (nonatomic) CellType cellType;
@property (nonatomic) int cellRotation;
@property (nonatomic) int boardRow;
@property (nonatomic) int boardColumn;

@end
