//
//  GameLevel.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-31.
//  Copyright (c) 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameLevel : NSObject

//@property (nonatomic) int level;

//-(id)initWithLevelNumber:(int)levelNumber;
-(id)initWithLevelData:(NSDictionary *)levelData;
-(NSArray *)getMonsterWave;
-(int)initialBatteryBalance;

@end
