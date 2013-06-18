//
//  PausePanelBase.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-13.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SuperVoltageClasses.h"

@interface PausePanelBase : CCNode {
    
}

@property (nonatomic,strong) NSString *title;

-(id)initWithLayer:(CCLayer *)layer;
-(void)show;
-(void)hide;

@end
