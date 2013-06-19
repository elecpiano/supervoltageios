//
//  LevelPickLayer.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-19.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation LevelPickLayer{
    
}

#pragma mark - Scene

+(CCScene *)scene{
    CCScene *scene = [CCScene node];
    LevelPickLayer *layer = [LevelPickLayer node];
    [scene addChild:layer];
    return scene;
}

#pragma mark - Lifecycle
-(id)init{
    if ((self = [super init])) {
        
    }
    return self;
}

#pragma mark - Initialization
-(void)initPageTitle{
    
}

-(void)initLevels{

}

@end
