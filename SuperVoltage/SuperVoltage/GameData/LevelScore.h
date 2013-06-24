//
//  LevelData.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-24.
//  Copyright (c) 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelScore : NSObject

@property (nonatomic) int level;
@property (nonatomic) int stars;

-(id)initWithLevel:(int)level stars:(int)stars;

@end
