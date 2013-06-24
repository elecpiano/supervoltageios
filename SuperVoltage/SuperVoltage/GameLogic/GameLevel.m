//
//  GameLevel.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-31.
//  Copyright (c) 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation GameLevel{
//    NSDictionary *presetMonsterWavePattern;
    int _level;
    NSDictionary *gameLevels;
    NSMutableArray *monsterWaves;
}

#pragma mark - Lifecycle
-(id)initWithLevelNumber:(int)levelNumber{
    if ((self = [super init])) {
        _level = levelNumber;
        [self initArrays];
//        [self loatMonsterWavePattern];
        [self loadGameLevels];
    }
    return self;
}

-(void)initArrays{
    monsterWaves = [[NSMutableArray alloc] init];
}

#pragma mark - persistance
-(void)loadGameLevels{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameLevels" ofType:@"plist"];
    gameLevels = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

#pragma mark - Monster
//-(void)loatMonsterWavePattern{
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MonsterPattern" ofType:@"plist"];
//    presetMonsterWavePattern = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//}

-(void)rePopulateMonsterWaves{
    [monsterWaves removeAllObjects];
    NSString *levelKey = [NSString stringWithFormat:@"%d",_level];
    NSDictionary *levelDict = [gameLevels objectForKey:levelKey];
    NSArray *waves = [levelDict objectForKey:@"MonsterWavePattern"];
    for (NSArray *wave in waves) {
        [monsterWaves addObject:wave];
    }
}

-(NSArray *)getMonsterWave{
    if ([monsterWaves count] <= 0)
    {
        [self rePopulateMonsterWaves];
    }
    
    int randomIndex = arc4random() % [monsterWaves count];
    NSArray *wave = [monsterWaves objectAtIndex:randomIndex];
    [monsterWaves removeObject:wave];
    
    return wave;
}

-(int)initialBatteryBalance{
    NSString *levelKey = [NSString stringWithFormat:@"%d",_level];
    NSDictionary *levelDict = [gameLevels objectForKey:levelKey];
    NSNumber *balanceNum = [levelDict objectForKey:@"BatteryBalance"];
    return [balanceNum intValue];
}

@end
