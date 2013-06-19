//
//  CCNineGridSprite.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-19.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCNineGridSprite : CCNode {
    
}

@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat edge;

+(id)spriteWithFile:(NSString *)filePath edge:(CGFloat)edge;

//@property (nonatomic) CGFloat fixTop;
//@property (nonatomic) CGFloat fixRight;
//@property (nonatomic) CGFloat fixBottom;
//@property (nonatomic) CGFloat fixLeft;

@end
