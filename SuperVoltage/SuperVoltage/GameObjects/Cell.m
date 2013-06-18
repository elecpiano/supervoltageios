//
//  Cell.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-17.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation Cell{
    NSString *spriteFrameNamePart_1;
    NSString *spriteFrameNamePart_2;
    CCSprite *glowSprite;
    Direction burntFrom;
    
    ElectricFlow *flowAtTop;
    ElectricFlow *flowAtLeft;
    ElectricFlow *flowAtBottom;
    ElectricFlow *flowAtRight;
}

#pragma mark - Lifecycle
-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *) spritesheet{
    if ((self = [super initWithLayer:layer])) {
        self.sprite = [CCSprite spriteWithSpriteFrame:[self frameFromCellType:self.cellType cellState:CellState_Normal]];
        [spritesheet addChild:self.sprite];
        [self initGlow:spritesheet];
    }
    return self;
}

-(void)initGlow:(CCSpriteBatchNode *) spritesheet{
    glowSprite = [CCSprite spriteWithSpriteFrame:[self frameFromCellType:self.cellType cellState:CellState_Glow]];
    [spritesheet addChild:glowSprite z:5];
    HIDE_SPRITE(glowSprite);
}

-(void)onEnter{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

-(void)onExit{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

-(void)removeMe{
    self.attachedBomb = nil;
    self.attachedCloud = nil;
    self.attachedMonster = nil;
    [BOARD removeCell:self];
}

#pragma mark - Sprite Frame
-(CCSpriteFrame *)frameFromCellType:(CellType)cellType cellState:(CellState)cellState{
    switch (cellType) {
        case CellType_I:
            spriteFrameNamePart_1 = @"I_";
            break;
        case CellType_L:
            spriteFrameNamePart_1 = @"L_";
            break;
        case CellType_T:
            spriteFrameNamePart_1 = @"T_";
            break;
        case CellType_X:
            spriteFrameNamePart_1 = @"X_";
            break;
        case CellType_H:
            spriteFrameNamePart_1 = @"H_";
            break;
        case CellType_U:
            spriteFrameNamePart_1 = @"U_";
            break;
        default:
            break;
    }
    
    switch (cellState)
    {
        case CellState_Normal:
            spriteFrameNamePart_2 = @"Normal.png";
            break;
        case CellState_LeftConnected:
            spriteFrameNamePart_2 = @"Left.png";
            break;
        case CellState_RightConnected:
            spriteFrameNamePart_2 = @"Right.png";
            break;
        case CellState_Hint:
            spriteFrameNamePart_2 = @"Hint.png";
            break;
        case CellState_Glow:
            spriteFrameNamePart_2 = @"Glow.png";
            break;
        case CellState_Burnt:
            spriteFrameNamePart_2 = @"Burnt.png";
            break;
        default:
            break;
    }
    
    NSString *frameName = [NSString stringWithFormat:@"%@%@", spriteFrameNamePart_1, spriteFrameNamePart_2];
    //    NSLog(@"%@",frameName);
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    
    return frame;
}

#pragma mark - Cell Type

-(void)setCellType:(CellType)cellType{
    _cellType = cellType;
    [self updateAntennas];
    [self.sprite setDisplayFrame:[self frameFromCellType:self.cellType cellState:self.cellState]];
    [glowSprite setDisplayFrame:[self frameFromCellType:self.cellType cellState:CellState_Glow]];
}

#pragma mark - Cell State
-(void)setCellState:(CellState)cellState{
    _cellState = cellState;
    [self.sprite setDisplayFrame:[self frameFromCellType:self.cellType cellState:self.cellState]];
    
    /* GameState_CellRotating means this call is made due to the Matrix refreshing called at the beginning of a cell rotation.
     We don't want the hint glow happen too often, and make sure it does only when a rotation is completed. */
    if (GAME.gameState == GameState_CellRotating) {
        [self stopGlow];
    }
    else if (cellState == CellState_Hint) {
        [self glow];
    }
    
    //todo
    // PlayHintAnimation();
    //        //audio
    //        if (leftBorderDetected && rightBorderDetected)
    //        {
    //            SEI_ConnectionHint.Stop();
    //            SEI_ConnectionHint.Play();
    //        }
}

-(void)updateCellState:(BOOL)leftConnected connectedToRight:(BOOL)rightConnected{
    if (!leftConnected && !rightConnected)
    {
        self.cellState = CellState_Normal;
    }
    else if (leftConnected && !rightConnected)
    {
        self.cellState = CellState_LeftConnected;
    }
    else if (!leftConnected && rightConnected)
    {
        self.cellState = CellState_RightConnected;
    }
    else if (leftConnected && rightConnected)
    {
        self.cellState = CellState_Hint;
    }
}

-(void)glow{
    id fadeInAction = [CCFadeIn actionWithDuration:CELL_GLOW_DURATION*0.5];
    id fadeOutAction = [CCFadeOut actionWithDuration:CELL_GLOW_DURATION*0.5]; //[fadeInAction reverse];
    id glowCompletedAction = [CCCallFunc actionWithTarget:self selector:@selector(glowCompleted)];
    id glowAction = [CCSequence actions:fadeInAction, fadeOutAction,glowCompletedAction, nil];
    
    [self showGlow];
    [glowSprite runAction:glowAction];
}

-(void)stopGlow{
    [glowSprite stopAllActions];
    HIDE_SPRITE(glowSprite);
}

-(void)showGlow{
    glowSprite.opacity = 0;
    glowSprite.position = self.position;
    glowSprite.rotation = self.sprite.rotation;
}

-(void)glowCompleted{
    if (BOARD.fireStarter == self) {
        [BOARD setFire:self dischargeBatteryAfterBurn:YES];
    }
    HIDE_SPRITE(glowSprite);
}

#pragma mark - Touch
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (GAME.gameState != GameState_Idle) {
        return YES;
    }
    if ([self containsTouch:touch] ) {
        [self rotateByOneQuarter];
        return YES;
    }
    return NO;
}

#pragma mark - Rotation
-(void)setCellRotation:(int)cellRotation{
    _cellRotation = cellRotation % 4;
}

-(void)rotateToQuartersImmediately:(int)quarters{
    [self setCellRotation:quarters];
    [self updateAntennas];
    self.sprite.rotation = self.cellRotation * 90;
}

-(void)rotateByOneQuarter{
    [self beforeAnimatedRotation];

    [self setCellRotation:(self.cellRotation + 1)];
    [self updateAntennas];
    
    id rotateAction = [CCRotateTo actionWithDuration:CELL_ROTATION_DURATION angle:self.cellRotation*90];
    id scaleAction1 = [CCScaleTo actionWithDuration:CELL_ROTATION_DURATION/2 scale:0.7];
    id scaleAction2 = [CCScaleTo actionWithDuration:CELL_ROTATION_DURATION/2 scale:1.0];
    id scaleActions = [CCSequence actions:scaleAction1, scaleAction2, nil];
    id onCompleteAction = [CCCallFunc actionWithTarget:self selector:@selector(animatedRotationComplete)];
    id spawnActions = [CCSpawn actions:rotateAction,scaleActions,nil];
    id sequenceAction = [CCSequence actions:spawnActions, onCompleteAction ,nil];
    
    [self.sprite runAction:sequenceAction];
}

-(void)beforeAnimatedRotation{
    GAME.gameState = GameState_CellRotating;/* this line MUST be executed as the first step of a rotation */
    [self setCellState:CellState_Normal];
    REFRESH_MATRIX(self);
}

-(void)animatedRotationComplete{    
    GAME.gameState = GameState_Idle;
    REFRESH_MATRIX(nil);
    [BOARD sparkleFlash:self];
    
    //todo
    //        if (CoreLogic.CurrentGameLevel.CurrentGameState == GameState.Burning)
    //        {
    //            return;
    //        }
    
    
    
    //todo
    //        CoreLogic.RotationSparkle.Flash(this);
    
    //    //audio
    //    if (leftBorderDetected && rightBorderDetected)
    //    {
    //        SEI_ConnectionHint.Stop();
    //        SEI_ConnectionHint.Play();
    //    }
}

-(void)updateAntennas{
    switch (self.cellType)
    {
        case CellType_I:
        {
            if (self.cellRotation == 0 || self.cellRotation == 2)
            {
                self.antennaTop = self.antennaBottom = YES;
                self.antennaLeft = self.antennaRight = NO;
            }
            else if (self.cellRotation == 1 || self.cellRotation == 3)
            {
                self.antennaTop = self.antennaBottom = NO;
                self.antennaLeft = self.antennaRight = YES;
            }
            break;
        }
        case CellType_L:
        {
            if (self.cellRotation == 0)
            {
                self.antennaTop = self.antennaRight = YES;
                self.antennaBottom = self.antennaLeft = NO;
            }
            else if (self.cellRotation == 1)
            {
                self.antennaTop = self.antennaLeft = NO;
                self.antennaBottom = self.antennaRight = YES;
            }
            else if (self.cellRotation == 2)
            {
                self.antennaTop = self.antennaRight = NO;
                self.antennaBottom = self.antennaLeft = YES;
            }
            else if (self.cellRotation == 3)
            {
                self.antennaTop = self.antennaLeft = YES;
                self.antennaBottom = self.antennaRight = NO;
            }
            break;
        }
        case CellType_T:
        {
            if (self.cellRotation == 0)
            {
                self.antennaLeft = self.antennaRight = self.antennaBottom = YES;
                self.antennaTop = NO;
            }
            else if (self.cellRotation == 1)
            {
                self.antennaLeft = self.antennaTop = self.antennaBottom = YES;
                self.antennaRight = NO;
            }
            else if (self.cellRotation == 2)
            {
                self.antennaLeft = self.antennaRight = self.antennaTop = YES;
                self.antennaBottom = NO;
            }
            else if (self.cellRotation == 3)
            {
                self.antennaTop = self.antennaRight = self.antennaBottom = YES;
                self.antennaLeft = NO;
            }
            break;
        }
        case CellType_X:
        {
            self.antennaLeft = self.antennaRight = self.antennaTop = self.antennaBottom = YES;
            break;
        }
        case CellType_H:
        {
            if (self.cellRotation == 0)
            {
                self.antennaRight = self.antennaTop = self.antennaLeft = NO;
                self.antennaBottom = YES;
            }
            else if (self.cellRotation == 1)
            {
                self.antennaBottom = self.antennaRight = self.antennaTop = NO;
                self.antennaLeft = YES;
            }
            else if (self.cellRotation == 2)
            {
                self.antennaLeft = self.antennaBottom = self.antennaRight = NO;
                self.antennaTop = YES;
            }
            else if (self.cellRotation == 3)
            {
                self.antennaTop = self.antennaLeft = self.antennaBottom = NO;
                self.antennaRight = YES;
            }
            break;
        }
        case CellType_U:
        {
            self.antennaLeft = self.antennaRight = self.antennaTop = self.antennaBottom = NO;
            break;
        }
        default:
            break;
    }
}

#pragma mark - Position
-(CGPoint)whereItShouldBe{
    return ccp(CELL_SIZE.width * self.boardColumn + BOARD_ORIGIN.x, CELL_SIZE.height * self.boardRow + BOARD_ORIGIN.y);
}

-(void)goToWhereItShouldBe:(ccTime)duration{
    CCMoveTo *action = [CCMoveTo actionWithDuration:duration position:[self whereItShouldBe]];
    [self.sprite runAction:action];
}

-(void)prepareToAppear{
    CGPoint point = ccp(CELL_SIZE.width * self.boardColumn+BOARD_ORIGIN.x,CELL_SIZE.height * self.boardRow + WIN_SIZE.height);
    [self setPosition:point];
}

-(void)dropTo:(int)targetRow{
    SET_CELL_AT_MATRIX(nil, self.boardRow, self.boardColumn);
    self.boardRow = targetRow;
    
    id moveAction = [CCMoveTo actionWithDuration:CELL_DROP_DURATION position:[self whereItShouldBe]];
    id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(didDrop)];
    id sequenceAction = [CCSequence actions:moveAction, callFuncAction, nil];
    [self runAction:sequenceAction];
    
    BoardObjectBase *attachment;
    if (self.attachedMonster) {
        attachment = self.attachedMonster;
    }
    else if (self.attachedCloud) {
        attachment = self.attachedCloud;
    }
    else if (self.attachedBomb) {
        attachment = self.attachedBomb;
    }
    
    if (attachment) {
        id moveActionCopy = [moveAction copy];
        [attachment runAction:moveActionCopy];
    }
    
    if (self.attachedMonster) {
        self.attachedMonster.shouldMoveForward = NO;
    }
}

-(void)didDrop{
    SET_CELL_AT_MATRIX(self, self.boardRow, self.boardColumn);
    GAME.droppingCellsCount --;
}

-(void)fill{
    self.cellState = CellState_Normal;
    CGFloat duration = self.boardRow * 0.1 + 0.1;
    id moveAction = [CCMoveTo actionWithDuration:duration position:[self whereItShouldBe]];
    id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(didFill)];
    id sequenceAction = [CCSequence actions:moveAction, callFuncAction ,nil];
    [self.sprite runAction:sequenceAction];
}

-(void)didFill{
    GAME.fillingCellsCount --;
}

#pragma mark - Connection
-(NSMutableArray *)collectConnectedCells{
    self.connectedCellTop = nil;
    self.connectedCellRight = nil;
    self.connectedCellBottom = nil;
    self.connectedCellLeft = nil;
    
    NSMutableArray *connectedCells = [[NSMutableArray alloc] init];
    
    if (self.antennaTop && self.boardRow < (BOARD_ROW_COUNT-1)) {
        Cell *cellAtTop = CELL_AT_MATRIX(self.boardRow + 1, self.boardColumn);
        if (cellAtTop != nil && (cellAtTop.antennaBottom || cellAtTop.cellType == CellType_U))
        {
            [connectedCells addObject:cellAtTop];
            self.connectedCellTop = cellAtTop;
        }
    }
    
    if (self.antennaRight && self.boardColumn < (BOARD_COLUMN_COUNT-1)) {
        Cell *cellAtRight = CELL_AT_MATRIX(self.boardRow, self.boardColumn+1);
        if (cellAtRight != nil && (cellAtRight.antennaLeft || cellAtRight.cellType == CellType_U))
        {
            [connectedCells addObject:cellAtRight];
            self.connectedCellRight = cellAtRight;
        }
    }
    
    if (self.antennaBottom && self.boardRow > 0) {
        Cell *cellAtBottom = CELL_AT_MATRIX(self.boardRow - 1, self.boardColumn);
        if (cellAtBottom != nil && (cellAtBottom.antennaTop || cellAtBottom.cellType == CellType_U))
        {
            [connectedCells addObject:cellAtBottom];
            self.connectedCellBottom = cellAtBottom;
        }
    }
    
    if (self.antennaLeft && self.boardColumn > 0) {
        Cell *cellAtLeft = CELL_AT_MATRIX(self.boardRow, self.boardColumn-1);
        if (cellAtLeft != nil && (cellAtLeft.antennaRight || cellAtLeft.cellType == CellType_U))
        {
            [connectedCells addObject:cellAtLeft];
            self.connectedCellLeft = cellAtLeft;
        }
    }
    
    return connectedCells;
}

#pragma mark - Burn
-(void)burnFrom:(Direction)burnFrom electricFlow:(ElectricFlow *)passingInElectricFlow{
    if (self.cellState == CellState_Burnt)
    {
        return;
    }
    
//    NSLog(@"BCCount:%d,[%d,%d]%@", GAME.burningCellsCount,self.boardRow,self.boardColumn,@"burn");
    
    self.cellState = CellState_Burnt;
    burntFrom = burnFrom;
    
    if (self.cellType == CellType_U) {
        [self burnUnknownCell];
    }
    else
    {
        [self showElectricFlow:burnFrom electricFlow:passingInElectricFlow];
        [self burnNeighbours];
    }
    
    if (self.cellType != CellType_U) {
        //monster
        if (self.attachedMonster) {
            [self.attachedMonster burn:1];
        }
        else if (self.attachedCloud) {
            [self.attachedCloud burn:1];
        }
        else if (self.attachedBomb) {
            [self.attachedBomb burn:1];
        }
    }
}

-(void)showElectricFlow:(Direction)burnFrom electricFlow:(ElectricFlow *)passingInElectricFlow{
    //add electric flow
    ElectricFlow *flow;
    CGPoint point;
    int radius;
    
    if (!passingInElectricFlow)
    {
        passingInElectricFlow = [BOARD.electricEffect addFlow];
        point = ccp(self.position.x - CELL_SIZE.width/2, self.position.y);
        [passingInElectricFlow addNode:point radius:0];
    }
    
    //add center point as node
    [passingInElectricFlow addNode:self.position radius:ELECTRIC_NODE_RADIUS];
    
    if (self.antennaRight && burnFrom != Direction_Right)
    {
        flow = passingInElectricFlow;
        passingInElectricFlow = nil;
        radius = self.boardColumn == (BOARD_COLUMN_COUNT - 1) ? 0 : ELECTRIC_NODE_RADIUS;
        point = ccp(self.position.x + CELL_SIZE.width/2, self.position.y);
        [flow addNode:point radius:radius];
        flowAtRight = flow;
    }
    if (self.antennaTop && burnFrom != Direction_Top)
    {
        if (!passingInElectricFlow)
        {
            passingInElectricFlow = [BOARD.electricEffect addFlow];
            [passingInElectricFlow addNode:self.position radius:ELECTRIC_NODE_RADIUS];            
        }
        flow = passingInElectricFlow;
        passingInElectricFlow = nil;
        point = ccp(self.position.x, self.position.y + CELL_SIZE.height/2);
        [flow addNode:point radius:ELECTRIC_NODE_RADIUS];
        flowAtTop = flow;
    }
    if (self.antennaBottom && burnFrom != Direction_Bottom)
    {
        if (!passingInElectricFlow)
        {
            passingInElectricFlow = [BOARD.electricEffect addFlow];
            [passingInElectricFlow addNode:self.position radius:ELECTRIC_NODE_RADIUS];
        }
        flow = passingInElectricFlow;
        passingInElectricFlow = nil;
        point = ccp(self.position.x, self.position.y - CELL_SIZE.height/2);
        [flow addNode:point radius:ELECTRIC_NODE_RADIUS];
        flowAtBottom = flow;
    }
    if (self.antennaLeft && burnFrom != Direction_Left)
    {
        if (!passingInElectricFlow)
        {
            passingInElectricFlow = [BOARD.electricEffect addFlow];
            [passingInElectricFlow addNode:self.position radius:ELECTRIC_NODE_RADIUS];
        }
        flow = passingInElectricFlow;
        passingInElectricFlow = nil;
        point = ccp(self.position.x - CELL_SIZE.width/2, self.position.y);
        [flow addNode:point radius:ELECTRIC_NODE_RADIUS];
        flowAtLeft = flow;
    } 
}

-(void)burnNeighbours{
    if (self.connectedCellTop && burntFrom != Direction_Top)
    {
        [self.connectedCellTop burnFrom:Direction_Bottom electricFlow:flowAtTop];
    }
    if (self.connectedCellLeft && burntFrom != Direction_Left)
    {
        [self.connectedCellLeft burnFrom:Direction_Right electricFlow:flowAtLeft];
    }
    if (self.connectedCellBottom && burntFrom != Direction_Bottom)
    {
        [self.connectedCellBottom burnFrom:Direction_Top electricFlow:flowAtBottom];
    }
    if (self.connectedCellRight && burntFrom != Direction_Right)
    {
        [self.connectedCellRight burnFrom:Direction_Left electricFlow:flowAtRight];
    }
}

//todo: call this method when burning animation is over
-(void)didBurn{
//    HIDE_SPRITE(glowSprite); /* to make sure it's hidden, it just doesn't get hidden when successive burn occurs */
    GAME.burningCellsCount--;
    BOOL shouldBeRemoved = YES;
    if (self.attachedMonster)
    {
        if (self.attachedMonster.health > 0)
        {
            self.cellState = CellState_Normal;
            shouldBeRemoved = NO;
        }
        [self.attachedMonster didBurn];
    }
    
    if (shouldBeRemoved) {
        [self removeMe];
    }
    
//    NSLog(@"BCCount:%d,[%d,%d]%@", GAME.burningCellsCount,self.boardRow,self.boardColumn,@"didBurn");
}

#pragma mark - Unknown
-(void)burnUnknownCell{
    CCRotateBy *rotateAction = [CCRotateBy actionWithDuration:BURNING_DURATION*0.5 angle:360];
    CCScaleTo *shrinkAction = [CCScaleTo actionWithDuration:BURNING_DURATION*0.5 scale:0];
    CCSpawn *spawnAction = [CCSpawn actions:rotateAction, shrinkAction, nil];
    CCCallFunc *onCompleteAction = [CCCallFunc actionWithTarget:self selector:@selector(turnIntoKnownCell)];
    CCSequence *sequenceAction = [CCSequence actions:spawnAction, onCompleteAction, nil];
    [self.sprite runAction:sequenceAction];
}

-(void)turnIntoKnownCell{
    [BOARD updateCellCountForType:CellType_U increasing:NO];
    //cell type
    int randomInt = arc4random() % 4; // turn into either of I, L, T, X. But no H, U
    self.cellType = (CellType)randomInt;
    [BOARD updateCellCountForType:self.cellType increasing:YES];
    
    //cell rotation
    randomInt = arc4random() % 4;
    [self rotateToQuartersImmediately:randomInt];
    
    //cell state
    self.cellState = CellState_Normal;
    
    CCScaleTo *expandAction = [CCScaleTo actionWithDuration:BURNING_DURATION*0.5 scale:1];
    [self.sprite runAction:expandAction];
}

#pragma mark - Bomb
-(void)bomb{
    self.cellState = CellState_Burnt;
    //process attachments
    if (self.attachedMonster)
    {
        [self.attachedMonster burn:BOMB_DAMAGE];
    }
    else if (self.attachedCloud)
    {
        [self.attachedCloud burn:BOMB_DAMAGE];
    }
    else if (self.attachedBomb) {
        [self.attachedBomb explode];
    }
}

-(void)didBomb{
    if (self.attachedMonster)
    {
        [self.attachedMonster didBurn];
    }
    
    [self removeMe];
}


@end
