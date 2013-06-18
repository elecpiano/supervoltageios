//
//  TestLayer.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-23.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TestLayer : CCLayer {
    
}

@property (nonatomic,strong) NSMutableArray *allCells;

+(TestLayer *)sharedInstance;

@end
