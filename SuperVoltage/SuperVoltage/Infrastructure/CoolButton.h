//
//  CoolButton.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-20.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CoolButton : CCMenuItemSprite {
    
}

+(id)itemWithFile:(NSString *)image block:(void(^)(id sender))block;

@end
