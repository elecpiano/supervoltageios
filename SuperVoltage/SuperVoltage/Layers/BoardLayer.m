//
//  BoardLayer.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-23.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "BoardLayer.h"
#import "SuperVoltage.h"

@implementation BoardLayer{
    CCSpriteBatchNode *cellSpritesheet;
    CCSpriteBatchNode *electricSpritesheet;
    CCSpriteBatchNode *monsterSpritesheet;
    CCSpriteBatchNode *pausePanelSpritesheet;
    
    Cell *cellMatrix[BOARD_ROW_COUNT][BOARD_COLUMN_COUNT];

    NSMutableArray *availableCellTypes;
    NSMutableArray *availableCellRotations;
    NSMutableArray *cellReusePool;
    NSMutableArray *allCells;
    NSMutableArray *treeOnFire;
    NSMutableArray *monstersOnStage;
    NSMutableArray *bonusQueue;
    
    int cellCount_I;
    int cellCount_L;
    int cellCount_T;
    int cellCount_X;
    int cellCount_H;
    int cellCount_U;
    
    NSNumber *CellTypeObj_I;
    NSNumber *CellTypeObj_L;
    NSNumber *CellTypeObj_T;
    NSNumber *CellTypeObj_X;
    NSNumber *CellTypeObj_H;
    NSNumber *CellTypeObj_U;
    
    NSNumber *CellRotationObj_0;
    NSNumber *CellRotationObj_1;
    NSNumber *CellRotationObj_2;
    NSNumber *CellRotationObj_3;
    
    CCParticleSystem *particleSystem;
    
    Sparkle *sparkleLeft;
    Sparkle *sparkleTop;
    Sparkle *sparkleRight;
    Sparkle *sparkleBottom;
    
    BOOL usePresets;
    BOOL lightningBurn;
    
    Battery *battery;
    BOOL dischargeEnabled;
    BOOL dischargeBatteryAfterBurning;
}

#pragma mark - Lifecycle

static BoardLayer *instance;
+(BoardLayer *)sharedInstance{
    @synchronized(self)
    {
        if (!instance){
            instance = [BoardLayer node];
        }
        return instance;
    }
}

-(id) init{
	if( (self=[super init])) {
        [self loadSpriteSheet];
        [self initArrays];
        [self initMenu];
        [self initBurningEffect];
        [self initSparkle];
        [self initTopBar];
	}
	return self;
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    
    /* Setting the Gamestate to Dropping without any cells are actually dropping,
     * is to cause the GamePage to proceed on to fill() method. */
    GAME.gameState = GameState_Dropping;
}

-(void)onExit{
    instance = nil;
    [super onExit];
}

#pragma mark - Initialization
-(void)initArrays{    
    [self initCellReusePool];
    
    availableCellTypes = [[NSMutableArray alloc] init];
    availableCellRotations = [[NSMutableArray alloc] init];
    
    CellTypeObj_I = [[NSNumber alloc] initWithInt:CellType_I];
    CellTypeObj_L = [[NSNumber alloc] initWithInt:CellType_L];
    CellTypeObj_T = [[NSNumber alloc] initWithInt:CellType_T];
    CellTypeObj_X = [[NSNumber alloc] initWithInt:CellType_X];
    CellTypeObj_H = [[NSNumber alloc] initWithInt:CellType_H];
    CellTypeObj_U = [[NSNumber alloc] initWithInt:CellType_U];
    
    CellRotationObj_0 = [[NSNumber alloc] initWithInt: 0];
    CellRotationObj_1 = [[NSNumber alloc] initWithInt: 1];
    CellRotationObj_2 = [[NSNumber alloc] initWithInt: 2];
    CellRotationObj_3 = [[NSNumber alloc] initWithInt: 3];
    
    monstersOnStage = [[NSMutableArray alloc] init];
    bonusQueue = [[NSMutableArray alloc] init];
    self.triggeredBombs = [[NSMutableArray alloc] init];
    self.explodingBombs = [[NSMutableArray alloc] init];
    self.bombingTargets =[[NSMutableArray alloc] init];
}

-(void)initMenu{
    // restart game
    CCMenuItem *menuItemRestart = [CCMenuItemFont itemWithString:@"Quit" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:SCENE_TRANSITION_DURATION scene:[LevelPickLayer scene] ]];
    }];
    
    CCMenuItem *menuItemTest = [CCMenuItemFont itemWithString:@"test" block:^(id sender) {
        [self test];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems: menuItemTest, menuItemRestart, nil];
    
    [menu alignItemsHorizontallyWithPadding:20];
    [menu setPosition:ccp(WIN_SIZE.width/2, WIN_SIZE.height - 50)];
    
    // Add the menu to the layer
    [self addChild:menu];
}

-(void)loadSpriteSheet{
    //cell
    cellSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"CellTexture.png"];
    [self addChild:cellSpritesheet z:Z_INDEX_BOARD_LAYER_1];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CellTexture.plist"];
    
    //cell
    electricSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"ElectricTexture.png"];
    [self addChild:electricSpritesheet z:Z_INDEX_BOARD_LAYER_2];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ElectricTexture.plist"];
    
    //monster
    monsterSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"MonsterTexture.png"];
    [self addChild:monsterSpritesheet z:Z_INDEX_BOARD_LAYER_3];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MonsterTexture.plist"];
    
    //pause panel
    pausePanelSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"PausePanelTexture.png"];
    [self addChild:pausePanelSpritesheet z:Z_INDEX_BOARD_LAYER_PAUSE_PANEL];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PausePanelTexture.plist"];
}

#pragma mark - cell reuse pool
-(void)initCellReusePool{
    int totalCellCount = BOARD_COLUMN_COUNT*BOARD_ROW_COUNT;
    cellReusePool = [[NSMutableArray alloc] initWithCapacity:totalCellCount];
    allCells = [[NSMutableArray alloc] initWithCapacity:totalCellCount];
    
    int count_I = CELL_COUNT_MAX_I;
    int count_L = CELL_COUNT_MAX_L;
    int count_T = CELL_COUNT_MAX_T;
    int count_X = CELL_COUNT_MAX_X;
    int count_H = CELL_COUNT_MAX_H;
    int count_U = CELL_COUNT_MAX_U;
    
    CellType cellType;
    
    for (int i=0; i<totalCellCount; i++) {
        if (count_U>0) {
            cellType = CellType_U;
            count_U--;
        }
        else if (count_H>0) {
            cellType = CellType_H;
            count_H--;
        }
        else if (count_X>0) {
            cellType = CellType_X;
            count_X--;
        }
        else if (count_T>0) {
            cellType = CellType_T;
            count_T--;
        }
        else if (count_I>0) {
            cellType = CellType_I;
            count_I--;
        }
        else if (count_L>0) {
            cellType = CellType_L;
            count_L--;
        }
        
        Cell *cell = [[Cell alloc] initWithLayer:self spritesheet:cellSpritesheet];
        HIDE_GAME_OBJ(cell);
        [cellReusePool addObject:cell];
        [allCells addObject:cell];
        cell.cellType = cellType;
    }
}

-(void)pushCellForReuse:(Cell *)cell{
    [cellReusePool addObject:cell];
}

-(Cell *)popCellFromReusePool{
    Cell *cell = [cellReusePool objectAtIndex:0];
    [cellReusePool removeObjectAtIndex:0];
    return cell;
//    int index = arc4random() % [cellReusePool count];
//    Cell *cell = [cellReusePool objectAtIndex:index];
//    [cellReusePool removeObject:cell];
//    return cell;
}

#pragma mark - Matrix

-(Cell *)cellAtMatrix:(int)row column:(int)column{
    Cell *cell = cellMatrix[row][column];
    return cell;
}

-(void)setCellAtMatrix:(Cell *)cell row:(int)row column:(int)column{
    cellMatrix[row][column] = cell;
}

-(int)dropCells{
    int droppingCount = 0;
    for (int column = (BOARD_COLUMN_COUNT - 1); column >= 0; column--)
    {
        int emptyCellCount = 0;
        for (int row = 0; row < BOARD_ROW_COUNT; row++)
        {
            Cell *cell = CELL_AT_MATRIX(row, column);
            if (!cell)
            {
                emptyCellCount++;
            }
            else if (emptyCellCount > 0)
            {
                //reset the status of dropping bubble
                cell.cellState = CellState_Normal;
                
                /* The dropping distance equals to the number of empty cells found bellow the cell.
                 * In order to understand the relationship between the emptyCellCount and dropping depth,
                 * you'd better draw a matrix of cells and do some graphical simulation.*/
                int newRow = cell.boardRow - emptyCellCount;
                [cell dropTo:newRow];
                droppingCount++;
                
                //todo
                //                /*tag bug's dropping status*/
                //                if (bubble.AttachedBug != null)
                //                {
                //                    bubble.AttachedBug.ShouldMoveForward = false;
                //                }
                
            }
        }
    }
    return droppingCount;
}

-(int)fillMatrix{
    NSMutableArray *cellsToAdd = [[NSMutableArray alloc] init];
    
    Cell *cell;
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    
    for (int row=0; row<BOARD_ROW_COUNT; row++) {
        for (int column = 0; column<BOARD_COLUMN_COUNT; column++) {
            cell = CELL_AT_MATRIX(row, column);
            if (cell) {
                continue;
            }
            
            /* get a free cell */
//            cell = [self popRandomCell];
            cell = [self popCellFromReusePool];
            
            [self prepareCell:cell byDenying:NO];
            
            // to test if the cell is acceptable
            BOOL leftBorderConnected = NO;
            BOOL rightBorderConnected = NO;
            
            [tree removeAllObjects];
            [self buildTree:cell forTree:tree leftConnectionDetector:&leftBorderConnected rightConnectionDetector:&rightBorderConnected];
            
            while (leftBorderConnected && rightBorderConnected)
            {
                //deny the cell, loop until get a correct one
                BOOL heHasDoneHisBest = [self prepareCell:cell byDenying:YES];
                if (heHasDoneHisBest)
                {
                    //can not find any acceptable cell, let it be
                    break;
                }
                
                [tree removeAllObjects];
                [self buildTree:cell forTree:tree leftConnectionDetector:&leftBorderConnected rightConnectionDetector:&rightBorderConnected];
            }
            
            [cell rotateToQuartersImmediately:cell.cellRotation];
            cell.boardColumn = column;
            cell.boardRow = row;
            
            SET_CELL_AT_MATRIX(cell, row, column);
            [cellsToAdd addObject:cell];
            [self updateCellCountForType:cell.cellType increasing:YES];
        }
    }
    
//    [self tryInjectUnkownCell:cellsToAdd];
    
    for (Cell *theCell in cellsToAdd)
    {
        [theCell prepareToAppear];
        [theCell fill];
    }
    
    return [cellsToAdd count];
}

-(BOOL)refreshMatrix:(Cell *)exceptForCell{
    self.fireStarter = nil;
    BOOL hintDetected = NO;
    NSMutableArray *refreshCells = [[NSMutableArray alloc] init];
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    
    if (exceptForCell) {
        SET_CELL_AT_MATRIX(nil,exceptForCell.boardRow,exceptForCell.boardColumn);
    }
    
    Cell *cell;
    for (int row=0; row<BOARD_ROW_COUNT; row++) {
        for (int column=0; column<BOARD_COLUMN_COUNT; column++) {
            cell = CELL_AT_MATRIX(row, column);
            if (cell) {
                [refreshCells addObject:cell];
            }
        }
    }
    
    while ([refreshCells count] > 0)
    {
        cell = [refreshCells objectAtIndex:0];
        
        BOOL leftBorderConnected = NO;
        BOOL rightBorderConnected = NO;
        
        [tree removeAllObjects];
        [self buildTree:cell forTree:tree leftConnectionDetector:&leftBorderConnected rightConnectionDetector:&rightBorderConnected];
        
        if (leftBorderConnected && rightBorderConnected)
        {
            hintDetected = YES;
            self.fireStarter = [tree objectAtIndex:0];
            //                //todo
            //                //audio
            //                Bubble.SEI_ConnectionHint.Stop();
            //                Bubble.SEI_ConnectionHint.Play();
        }
        
        for (Cell *cell_1 in tree)
        {
            [cell_1 updateCellState:leftBorderConnected connectedToRight:rightBorderConnected];
        }
        
        for (Cell *cell_2 in tree)
        {
            [refreshCells removeObject:cell_2];
        }
    }
    
    if (exceptForCell) {
        SET_CELL_AT_MATRIX(exceptForCell,exceptForCell.boardRow,exceptForCell.boardColumn);
    }
    
    return hintDetected;
}

-(void)setFire:(Cell *)fireStarter dischargeBatteryAfterBurn:(BOOL)toDischarge{
    dischargeBatteryAfterBurning = toDischarge;
    //    NSLog(@"setFire:[%d,%d]",fireStarter.boardRow,fireStarter.boardColumn);
    treeOnFire = [[NSMutableArray alloc] init];
    BOOL uselessBoolLeft=NO;
    BOOL uselessBoolRight=NO;
    [self buildTree:fireStarter forTree:treeOnFire leftConnectionDetector:&uselessBoolLeft rightConnectionDetector:&uselessBoolRight];
    
    GAME.burningCellsCount = [treeOnFire count];
    GAME.gameState = GameState_Burning;
    
    for (Cell *cell in treeOnFire)
    {
        if (cell.boardColumn == 0 && cell.antennaLeft)
        {
            /* Initial fire, has no passingInFlame*/
            [cell burnFrom:Direction_Left electricFlow:nil];
        }
    }
    
    //    todo
    //    (GamePage.Current as GamePage).PlayBurningSoundEffect();
    
    //chain bonus detect
    self.successiveBurnCount ++;
    [self performSelector:@selector(didBurn) withObject:self afterDelay:BURNING_DURATION];
}

-(void)didBurn{
    for (Cell *cell in treeOnFire) {
        [cell didBurn];
    }
    
    [self clearBurningEffect];
    [self tryCongratulateCombo];

    //update battery balance
    if (dischargeEnabled) {
        if (dischargeBatteryAfterBurning && self.successiveBurnCount <= 1) {
            dischargeBatteryAfterBurning = NO;
            [battery discharge:1];
        }
    }

    GAME.burningCellsCount = 0;
}

#pragma mark - Cell

-(void)updateCellCountForType:(CellType)cellType increasing:(BOOL)increasing{
    int num = increasing ? 1 : -1;
    switch (cellType) {
        case CellType_I:
            cellCount_I += num;
            break;
        case CellType_L:
            cellCount_L += num;
            break;
        case CellType_T:
            cellCount_T += num;
            break;
        case CellType_X:
            cellCount_X += num;
            break;
        case CellType_H:
            cellCount_H += num;
            break;
        case CellType_U:
            cellCount_U += num;
            break;
        default:
            break;
    }
}

/*****************
 Each time the 'cell' parameter is set null, this method starts a new round of random picking.
 Return value of YES indicates that no acceptable cell/rotation is found and the cell has not changed at all.
 ***************/
-(BOOL)prepareCell:(Cell *)cell byDenying:(BOOL)deny{
    BOOL iHaveDoneMyBest = NO;
    
    if (!deny) {
        [self resetAvailableCellTypes];
        [self resetAvailableCellRotations];
        cell.cellType = [self getRandomCellType];
        cell.cellRotation = [self getRandomCellRotation];
    }
    else{
        [self removeAvailableCellRotation:cell.cellRotation];
        if ([availableCellRotations count] == 0) { // all rotations are denied, so let's try another cell type
            [self removeAvailableCellType:cell.cellType];
            if ([availableCellTypes count] == 0) { // all types and rotations are denied, let it be
                iHaveDoneMyBest = YES;
            }
            else{
                cell.cellType = [self getRandomCellType];
                [self resetAvailableCellRotations];
                cell.cellRotation = [self getRandomCellRotation];
            }
        }
        else{
            cell.cellRotation = [self getRandomCellRotation];
        }
    }
    
    return iHaveDoneMyBest;
}

-(void)resetAvailableCellTypes{
    [availableCellTypes removeAllObjects];
    
    if (cellCount_I<CELL_COUNT_MAX_I) {
        [availableCellTypes addObject:CellTypeObj_I];
    }
    if (cellCount_L<CELL_COUNT_MAX_L) {
        [availableCellTypes addObject:CellTypeObj_L];
    }
    if (cellCount_T<CELL_COUNT_MAX_T) {
        [availableCellTypes addObject:CellTypeObj_T];
    }
    if (cellCount_X<CELL_COUNT_MAX_X) {
        [availableCellTypes addObject:CellTypeObj_X];
    }
    if (cellCount_H<CELL_COUNT_MAX_H) {
        [availableCellTypes addObject:CellTypeObj_H];
    }
    if (cellCount_U<CELL_COUNT_MAX_U) {
        [availableCellTypes addObject:CellTypeObj_U];
    }
}

-(CellType)getRandomCellType{
    int index = arc4random() % [availableCellTypes count];
    NSNumber *num = [availableCellTypes objectAtIndex:index];
    return (CellType)[num intValue];
}

-(void)removeAvailableCellType:(CellType)cellType{
    NSNumber *cellTypeObj;
    
    switch (cellType) {
        case CellType_I:
            cellTypeObj = CellTypeObj_I;
            break;
        case CellType_L:
            cellTypeObj = CellTypeObj_L;
            break;
        case CellType_T:
            cellTypeObj = CellTypeObj_T;
            break;
        case CellType_X:
            cellTypeObj = CellTypeObj_X;
            break;
        case CellType_H:
            cellTypeObj = CellTypeObj_H;
            break;
        case CellType_U:
            cellTypeObj = CellTypeObj_U;
            break;
        default:
            break;
    }
    
    [availableCellTypes removeObject:cellTypeObj];
}

-(void)resetAvailableCellRotations{
    [availableCellRotations removeAllObjects];
    
    [availableCellRotations addObject:CellRotationObj_0];
    [availableCellRotations addObject:CellRotationObj_1];
    [availableCellRotations addObject:CellRotationObj_2];
    [availableCellRotations addObject:CellRotationObj_3];
}

-(int)getRandomCellRotation{
    int index = arc4random() % [availableCellRotations count];
    NSNumber *num = [availableCellRotations objectAtIndex:index];
    return [num intValue];
}

-(void)removeAvailableCellRotation:(int)cellRotation{
    NSNumber *cellRotationObj;
    
    switch (cellRotation) {
        case 0:
            cellRotationObj = CellRotationObj_0;
            break;
        case 1:
            cellRotationObj = CellRotationObj_1;
            break;
        case 2:
            cellRotationObj = CellRotationObj_2;
            break;
        case 3:
            cellRotationObj = CellRotationObj_3;
            break;
        default:
            break;
    }
    
    [availableCellRotations removeObject:cellRotationObj];
}

-(void)buildTree:(Cell *)cell forTree:(NSMutableArray *)tree
leftConnectionDetector:(BOOL *)leftBorderConnected rightConnectionDetector:(BOOL *)rightBorderConnected{
    [tree addObject:cell];
    
    if (cell.boardColumn == 0 && cell.antennaLeft) {
        *leftBorderConnected = YES;
    }
    else if (cell.boardColumn == (BOARD_COLUMN_COUNT - 1) && cell.antennaRight){
        *rightBorderConnected = YES;
    }
    
    NSMutableArray *connectedCells = [cell collectConnectedCells];
    
    if ([connectedCells count] > 0)
    {
        for (Cell *theCell in connectedCells) {
            if (![tree containsObject:theCell] && theCell.cellType != CellType_U) {
                [self buildTree:theCell forTree:tree leftConnectionDetector:leftBorderConnected rightConnectionDetector:rightBorderConnected];
            }
        }
    }
}

-(void)removeCell:(Cell *)cell{
    if ([cellReusePool containsObject:cell]) {
        NSLog(@"%@%d,%d",@"duplicate removal",cell.boardRow,cell.boardColumn);
        return;
    }
    
    SET_CELL_AT_MATRIX(nil, cell.boardRow, cell.boardColumn);
    [self pushCellForReuse:cell];
    [self updateCellCountForType:cell.cellType increasing:NO];
    HIDE_GAME_OBJ(cell);
}

#pragma mark - Monster
-(void)moveMonsters{
    [self tryCongratulateChain];
    if (!dischargeEnabled) {
        dischargeEnabled = YES;
    }

    /* move existing monsters forward/around using Lower-First principle */
    for (int row = 0; row < BOARD_ROW_COUNT; row++)
    {
        for (int column = 0; column < BOARD_COLUMN_COUNT; column++)
        {
            Cell *cell = CELL_AT_MATRIX(row, column);
            if (cell && cell.attachedMonster)
            {
                [cell.attachedMonster moveForward];
            }
        }
    }
    
    [self addMonsters];
    
    GAME.gameState = GameState_MonsterMoving;
}

-(void)addMonsters{
    NSMutableArray *newMonsters = [[NSMutableArray alloc] init];
    
    //check for tutorial
    if (usePresets)
    {
        //        newBugs = InitTutorialBugs();
    }
    else
    {
        /* if it is a Lightning Burn, then check if there is any monster on the screen.
         * If there is, then do NOT add new enemy. */
        if (lightningBurn && [monstersOnStage count] > 0)
        {
            return;
        }
        
        NSArray *monsterWave = [GAME.currentGameLevel getMonsterWave];
        
        for (NSNumber *monsterTypeNum in monsterWave) {
            MonsterType monsterType = (MonsterType)[monsterTypeNum intValue];
            Monster *monster = [[Monster alloc] initWithLayer:self spritesheet:monsterSpritesheet monsterType:monsterType];
            [newMonsters addObject:monster];
        }
        
        //get empty cell in the first row
        NSMutableArray *startingLine = [[NSMutableArray alloc] init];
        for (int column = 0; column < BOARD_COLUMN_COUNT; column++)
        {
            Cell *cell = CELL_AT_MATRIX(BOARD_ROW_COUNT-1, column);
            if (!cell.attachedMonster)
            {
                [startingLine addObject:cell];
            }
        }
        
        /* put new bugs into empty cells, until there's no more empty cells, then give up */
        for (Monster *monster in newMonsters)
        {
            if ([startingLine count] <= 0)
            {
                break;
            }
            int index = arc4random() % [startingLine count];
            monster.attachedToCell = [startingLine objectAtIndex:index];
            [monstersOnStage addObject:monster];
            [startingLine removeObjectAtIndex:index];
        }
    }
    
    for (Monster *monster in newMonsters)
    {
        if (monster)
        {
            [monster prepareToAppear];
            [monster appear];
        }
    }
}

-(void)removeMonster:(Monster *)monster{
    [monstersOnStage removeObject:monster];
}

#pragma mark - Electric Effect
-(void)initBurningEffect{
    self.electricEffect = [[ElectricEffect alloc] initWithSpritesheet:electricSpritesheet frameName:@"ElectricTexture.png"];
    [self addChild:self.electricEffect];
}

-(void)clearBurningEffect{
    [self.electricEffect clearFlows];
}

#pragma mark - Sparkle
-(void)initSparkle{
    sparkleLeft = [Sparkle node];
    sparkleTop = [Sparkle node];
    sparkleRight = [Sparkle node];
    sparkleBottom = [Sparkle node];
    
    //	sparkleLeft.texture = [[CCTextureCache sharedTextureCache] addImage: @"Spark1.png"];
    //    sparkleTop.texture = [[CCTextureCache sharedTextureCache] addImage: @"Spark1.png"];
    //    sparkleRight.texture = [[CCTextureCache sharedTextureCache] addImage: @"Spark1.png"];
    //    sparkleBottom.texture = [[CCTextureCache sharedTextureCache] addImage: @"Spark1.png"];
    
    //    sparkleLeft.visible = NO;
    //    sparkleTop.visible = NO;
    //    sparkleRight.visible = NO;
    //    sparkleBottom.visible = NO;
    
    [self addChild:sparkleLeft z:Z_INDEX_SPARKLE];
    [self addChild:sparkleTop z:Z_INDEX_SPARKLE];
    [self addChild:sparkleRight z:Z_INDEX_SPARKLE];
    [self addChild:sparkleBottom z:Z_INDEX_SPARKLE];
}

-(void)sparkleFlash:(Cell *)cell{
    //only cells that are connected to electric source should sparkle
    if (cell.cellState == CellState_Normal)
    {
        return;
    }
    
    if (cell.connectedCellLeft || (cell.boardColumn == 0 && cell.antennaLeft))
    {
        CGPoint pos = ccp(cell.position.x - CELL_SIZE.width/2,cell.position.y);
        [sparkleLeft flashAt:pos];
    }
    if (cell.connectedCellTop)
    {
        CGPoint pos  = ccp(cell.position.x,cell.position.y + CELL_SIZE.height/2);
        [sparkleTop flashAt:pos];
    }
    if (cell.connectedCellRight || (cell.boardColumn == (BOARD_COLUMN_COUNT - 1) && cell.antennaRight))
    {
        CGPoint pos = ccp(cell.position.x + CELL_SIZE.width/2,cell.position.y);
        [sparkleRight flashAt:pos];
    }
    if (cell.connectedCellBottom)
    {
        CGPoint pos  = ccp(cell.position.x,cell.position.y - CELL_SIZE.height/2);
        [sparkleBottom flashAt:pos];
    }
}

#pragma mark - Bonus
-(void)tryCongratulateCombo{
    if (self.currentRoundMonsterKillCount <= 1)
    {
        self.currentRoundMonsterKillCount = 0;
        return;
    }
    
//    /* Award Score Bonus */
//    int bonusScore = Global.COMBO_UNIT_PRICE * (self.currentRoundMonsterKillCount - 1);
//    TopBar.Current.AddScore(bonusScore);
//    ComboBonusScore.LoadText(BonusFont, "+" + bonusScore.ToString());
//    ComboBonusScore.SetPosition(Global.BONUS_SCORE_POSITION);
//    this.Components.Add(ComboBonusScore);
//    ComboBonusScore.Blink(5, Global.BonusBlinkInterval,
//                          sender =>
//                          {
//                              this.Components.Remove(ComboBonusScore);
//                          });
    
    /* Queue Combo Award */
    [self queueBonus:BonusType_Combo count:(self.currentRoundMonsterKillCount-1)];
    
    /* Visual Congratulation */
    Congratulation *congratulation = [[Congratulation alloc] initWithLayer:self spritesheet:monsterSpritesheet bonusType:BonusType_Combo];
    [congratulation show];
    
    /* Reset for next round's counting */
    self.currentRoundMonsterKillCount = 0;
}

-(void)tryCongratulateChain{    
    if (self.successiveBurnCount <= 1)
    {
        self.successiveBurnCount = 0;
        return;
    }
    
//    /* Award Score */
//    int bonusScore = Global.CHAIN_UNIT_PRICE * CoreLogic.ChainCount;
//    TopBar.Current.AddScore(bonusScore);
//    ChainBonusScore.LoadText(BonusFont, "+" + bonusScore.ToString());
//    ChainBonusScore.SetPosition(Global.BONUS_SCORE_POSITION);
//    this.Components.Add(ChainBonusScore);
//    ChainBonusScore.Blink(5, Global.BonusBlinkInterval,
//                          sender =>
//                          {
//                              this.Components.Remove(ChainBonusScore);
//                          });
//    
    /* Queue Chain Award */
    [self queueBonus:BonusType_Chain count:(self.successiveBurnCount-1)];
    
    /* Visual Congratulation */
    Congratulation *congratulation = [[Congratulation alloc] initWithLayer:self spritesheet:monsterSpritesheet bonusType:BonusType_Chain];
    [congratulation show];
    
    /* Reset for next round's counting */
    self.successiveBurnCount = 0;
}

-(void)queueBonus:(BonusType)bonusType count:(int)count{
    //todo : make better bonus for larger count
    for (int n=0; n<count; n++) {
        NSNumber *bonusTypeNum = [NSNumber numberWithInt:bonusType];
        [bonusQueue addObject:bonusTypeNum];
    }
}

-(void)awardBonus{
    NSMutableArray *bonuses = [[NSMutableArray alloc] init];
    NSMutableArray *exceptions = [[NSMutableArray alloc] init];
    for (NSNumber *bonusTypeNum in bonusQueue)
    {
        BOOL emptyCellFound = NO;
        Cell *cell = nil;
        
        while(!emptyCellFound)
        {
            int index = arc4random() % [allCells count];
            cell = [allCells objectAtIndex:index];
            
            if (cell.attachedMonster || cell.attachedCloud || cell.attachedBomb)
            {
                [exceptions addObject:cell];
                [allCells removeObject:cell];
                emptyCellFound = NO;
            }
            else
            {
                emptyCellFound = YES;
            }
        }
        
        BonusType bonusType = (BonusType)[bonusTypeNum intValue];
        BoardObjectBase *bonus;
        switch (bonusType) {
            case BonusType_Combo:
                bonus = [[Cloud alloc] initWithLayer:self spritesheet:monsterSpritesheet];
                break;
            case BonusType_Chain:
                bonus = [[Bomb alloc] initWithLayer:self spritesheet:monsterSpritesheet];
                break;
            default:
                break;
        }
        
        bonus.attachedToCell = cell;
        [bonuses addObject:bonus];
    }
    
    for (Cell *cell in exceptions) {
        [allCells addObject:cell];
    }
    [exceptions removeAllObjects];
    [bonusQueue removeAllObjects];
    
    for (BoardObjectBase *bonus in bonuses) {
        [bonus prepareToAppear];
        [bonus appear];
    }
}

-(BOOL)tryStartBomb{
    BOOL bombStarted = NO;
    if ([self.triggeredBombs count]>0) {
        for (Bomb *bomb in self.triggeredBombs) {
            [bomb explode];/*this can also cause successive explosion on other bombs*/
        }
        [self.triggeredBombs removeAllObjects];
        
//        for (Cell *target in self.bombingTargets) {
//            NSLog(@"%@%d,%d",@"bomb target:",target.boardRow,target.boardColumn);
//            [target bomb];
//        }
        
        bombStarted = YES;
        GAME.gameState = GameState_Bombing;
    }
    [self performSelector:@selector(didBomb) withObject:self afterDelay:BOMBING_DURATION];
    return bombStarted;
}

-(void)didBomb{
    for (Bomb *bomb in self.explodingBombs) {
        [bomb didExplode];
    }
    [self.explodingBombs removeAllObjects];
    
    for (Cell *target in self.bombingTargets) {
        [target didBomb];
    }
    [self.bombingTargets removeAllObjects];
    
    GAME.explodingBombCount = 0;
}

#pragma mark - Burn Score

-(void)showScore:(int)score at:(CGPoint)showPosition{
    NSString *scoreString = [NSString stringWithFormat:@"%d", score];
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:scoreString fontName:@"Arial-BoldMT" fontSize:dscale(20)];
    scoreLabel.position = showPosition;
    
    [self addChild:scoreLabel z:Z_INDEX_BOARD_LAYER_4];
    
    id moveUpAction1 = [CCMoveBy actionWithDuration:MONSTER_SCORE_FADING_DURATION position:ccp(0, CELL_SIZE.height/2)];
    id fadeInAction = [CCFadeIn actionWithDuration:MONSTER_SCORE_FADING_DURATION];
    id spawnAction1 = [CCSpawn actions:moveUpAction1, fadeInAction, nil];
    
    id moveUpAction2 = [CCMoveBy actionWithDuration:MONSTER_SCORE_FLOATING_DURATION position:ccp(0, dscale(5))];
    
    id moveUpAction3 = [CCMoveBy actionWithDuration:MONSTER_SCORE_FADING_DURATION position:ccp(0, CELL_SIZE.height/2)];
    id fadeOutAction = [CCFadeOut actionWithDuration:MONSTER_SCORE_FADING_DURATION];
    id spawnAction3 = [CCSpawn actions: moveUpAction3, fadeOutAction, nil];
    
    id callFuncAction = [CCCallFuncN actionWithTarget:self selector:@selector(didAddScore:)];
    id sequenceAction = [CCSequence actions:spawnAction1, moveUpAction2, spawnAction3,callFuncAction, nil];
    
    [scoreLabel runAction:sequenceAction];
}

-(void)didAddScore:(id)sender{
    [sender removeFromParentAndCleanup:YES];
}

#pragma mark - Top Bar
-(void)initTopBar{
    battery = [[Battery alloc] initWithLayer:self spritesheet:monsterSpritesheet];
    [battery recharge:[GAME.currentGameLevel initialBatteryBalance]];
}
//
//#pragma mark - GameLevel
//-(void)loadGameLevel{
//    
//}

#pragma mark - Game Over
-(BOOL)isGameOver{
    BOOL gameIsOver = NO;
    if ([battery balance] <= 0) {
        gameIsOver = YES;
    }
    return gameIsOver;
}

-(void)gameOver{
    GAME.gameState = GameState_Paused;
    GameOverPanel *gameOverPanel = [[GameOverPanel alloc] initWithLayer:self spritesheet:pausePanelSpritesheet];
    [gameOverPanel show];
}

#pragma mark - Test
-(void)test{
    CCSprite *sprite1 = [CCSprite spriteWithFile:@"Icon-72.png"];
    CCSprite *sprite2 = [CCSprite spriteWithFile:@"ElectricTexture.png"];
    CCLabelTTF *label1 = [CCLabelTTF labelWithString:NSLocalizedString(@"GameOver_Title", nil) fontName:@"Marker Felt" fontSize:32];
    
    sprite1.position = ccp(0,0);
    sprite2.position = ccp(50,50);
    label1.position = ccp(-50,-50);
    
    CCNode *nd = [CCNode node];
    [nd addChild:sprite1];
    [nd addChild:sprite2];
    [nd addChild:label1];
    
    nd.position = WINCENTER;
    [self addChild:nd];
    nd.zOrder = 99;
    
    id moveAction = [CCMoveBy actionWithDuration:1 position:ccp(0, -100)];
    [nd runAction:moveAction];
}

-(void)test2{
    id moveAction = [CCMoveBy actionWithDuration:1 position:ccp(0, 100)];
    [cellSpritesheet runAction:moveAction];
}

@end






























