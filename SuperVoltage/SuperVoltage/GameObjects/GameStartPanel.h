//
//  GameStartPanel.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-13.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SuperVoltageClasses.h"

@interface GameStartPanel : PausePanelBase {
    
}

-(id)initWithLayer:(CCLayer *)layer;
-(void)setLevel:(int)level;

@end
