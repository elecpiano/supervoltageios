//
//  GameLevel.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-31.
//  Copyright (c) 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation GameLevel{
//    int _level;
//    NSDictionary *gameLevels;
    NSDictionary *_levelData;
    NSMutableArray *monsterWaves;
}

#pragma mark - Lifecycle
-(id)initWithLevelData:(NSDictionary *)levelData{
    if ((self = [super init])) {
//        _level = levelNumber;
        _levelData = levelData;
        [self initArrays];
//        [self loadGameLevels];
    }
    return self;
}

-(void)initArrays{
    monsterWaves = [[NSMutableArray alloc] init];
}

//#pragma mark - persistance
//-(void)loadGameLevels{
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameLevels" ofType:@"plist"];
//    gameLevels = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//}

#pragma mark - Monster
//-(void)loatMonsterWavePattern{
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MonsterPattern" ofType:@"plist"];
//    presetMonsterWavePattern = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//}

-(void)rePopulateMonsterWaves{
    [monsterWaves removeAllObjects];
//    NSString *levelKey = [NSString stringWithFormat:@"%d",_level];
//    NSDictionary *levelDict = [GAME.gameLevelGroups objectForKey:levelKey];
    NSArray *waves = [_levelData objectForKey:@"MonsterWavePattern"];
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
//    NSString *levelKey = [NSString stringWithFormat:@"%d",_level];
//    NSDictionary *levelDict = [gameLevels objectForKey:levelKey];
    NSNumber *balanceNum = [_levelData objectForKey:@"BatteryBalance"];
    return [balanceNum intValue];
}

@end
