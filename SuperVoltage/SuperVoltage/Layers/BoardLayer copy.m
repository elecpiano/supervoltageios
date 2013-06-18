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
    Cell *cellMatrix[BOARD_ROW_COUNT][BOARD_COLUMN_COUNT];
    
    NSMutableArray *allCells;
    NSMutableArray *availableCellRotations;
    NSMutableArray *cellReusePool;
    NSMutableArray *cellTypePool;/* this is used to track global counting for each cell types, in order to avoid too many X,T,I types of cells are at present */
    NSMutableArray *availableCellTypes;/* this is used to track available cell types for each Random-Cell-Picking round, and is based on cellTypePool*/
    
    NSNumber *CellRotationObj_0;
    NSNumber *CellRotationObj_1;
    NSNumber *CellRotationObj_2;
    NSNumber *CellRotationObj_3;
    
    NSNumber *CellTypeObj_I;
    NSNumber *CellTypeObj_L;
    NSNumber *CellTypeObj_T;
    NSNumber *CellTypeObj_X;
    NSNumber *CellTypeObj_H;
    NSNumber *CellTypeObj_U;
    
    int cellCount_I;
    int cellCount_L;
    int cellCount_T;
    int cellCount_X;
    int cellCount_H;
    int cellCount_U;
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

-(id) init
{
	if( (self=[super init])) {
        [self loadSpriteSheet];
        [self initArrays];
        [self initMenu];
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

#pragma mark - Local Variable Initialization & Clean UP
-(void)initArrays{
    self.fireStarters = [[NSMutableArray alloc] init];
    
    int totalCellCount = BOARD_COLUMN_COUNT*BOARD_ROW_COUNT;
    allCells = [[NSMutableArray alloc] initWithCapacity:totalCellCount];
    cellReusePool = [[NSMutableArray alloc] initWithCapacity:totalCellCount];
    for (int i=0; i<totalCellCount; i++) {
        Cell *cell = [[Cell alloc] initWithLayer:self Spritesheet:cellSpritesheet];
        HIDE_GAME_OBJ(cell);
        [cellReusePool addObject:cell];
        [allCells addObject:cell];
    }
    
    availableCellTypes = [[NSMutableArray alloc] init];
    availableCellRotations = [[NSMutableArray alloc] init];
    
    CellRotationObj_0 = [[NSNumber alloc] initWithInt: 0];
    CellRotationObj_1 = [[NSNumber alloc] initWithInt: 1];
    CellRotationObj_2 = [[NSNumber alloc] initWithInt: 2];
    CellRotationObj_3 = [[NSNumber alloc] initWithInt: 3];
    
    CellTypeObj_I = [[NSNumber alloc] initWithInt: CellType_I];
    CellTypeObj_L = [[NSNumber alloc] initWithInt: CellType_L];
    CellTypeObj_T = [[NSNumber alloc] initWithInt: CellType_T];
    CellTypeObj_X = [[NSNumber alloc] initWithInt: CellType_X];
    CellTypeObj_H = [[NSNumber alloc] initWithInt: CellType_H];
    CellTypeObj_U = [[NSNumber alloc] initWithInt: CellType_U];
    
    cellTypePool = [[NSMutableArray alloc] init];
    
    [cellTypePool addObject:CellTypeObj_I];
    [cellTypePool addObject:CellTypeObj_L];
    [cellTypePool addObject:CellTypeObj_T];
    [cellTypePool addObject:CellTypeObj_X];
    [cellTypePool addObject:CellTypeObj_H];
    [cellTypePool addObject:CellTypeObj_U];
}

//Cell *cell = cellMatrix[row][column];
//[cell removeFromParentAndCleanup:YES];

#pragma mark - menu
-(void)initMenu{
    // restart game
    CCMenuItem *menuItemRestart = [CCMenuItemFont itemWithString:@"Restart" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:SCENE_TRANSITION_DURATION scene:[HelloWorldLayer scene] ]];
    }];
    
    CCMenuItem *menuItemTest = [CCMenuItemFont itemWithString:@"test" block:^(id sender) {
        [self refreshMatrix:nil];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems: menuItemTest, menuItemRestart, nil];
    
    [menu alignItemsHorizontallyWithPadding:20];
    [menu setPosition:ccp(WIN_SIZE.width/2, WIN_SIZE.height - 50)];
    
    // Add the menu to the layer
    [self addChild:menu];
}

#pragma mark - Matrix

-(Cell *)cellAtMatrix:(int)row column:(int)column{
    Cell *cell = cellMatrix[row][column];
    return cell;
}

-(void)setCellAtMatrix:(Cell *)cell row:(int)row column:(int)column{
    cellMatrix[row][column] = cell;
}

-(void)loadSpriteSheet{
    cellSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"CellTexture.png"];
    [self addChild:cellSpritesheet];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CellTexture.plist"];
}

-(void)populateMatrix_old{
    allCells = [[NSMutableArray alloc] initWithCapacity:BOARD_ROW_COUNT * BOARD_COLUMN_COUNT];
    for (int row=0; row< BOARD_ROW_COUNT; row++) {
        for (int column=0; column<BOARD_COLUMN_COUNT; column++) {
            Cell *cell = [[Cell alloc] initWithLayer:self Spritesheet:cellSpritesheet];
            
            cell.boardRow = row;
            cell.boardColumn = column;
            
            int randomValue = arc4random() % 5;
            CellType cellType = (CellType)randomValue;
            [cell setCellType:cellType];
            
            [allCells addObject:cell];
            
            [cell prepareToAppear];
            [cell fill];
        }
    }
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
            cell = [self popCellForReuse];
            
            [self prepareCell:cell byDenying:NO];
            
            // to test if the cell is acceptable
            BOOL leftBorderConnected = NO;
            BOOL rightBorderConnected = NO;
            
            [tree removeAllObjects];
            [self buildTree:cell forTree:tree leftConnectionDetector:&leftBorderConnected rightConnectionDetector:&rightBorderConnected];
            
            while (leftBorderConnected && rightBorderConnected)
            {
                //deny the cell, loop until get a correct one
                BOOL noAcceptableCellFound = [self prepareCell:cell byDenying:YES];
                if (noAcceptableCellFound)
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
            [self updateCellTypePool:cell.cellType increase:YES];
            [cellsToAdd addObject:cell];
            
        }
    }
    
    for (Cell *theCell in cellsToAdd)
    {
        //        [theCell showOnLayer:self withSpritesheet:cellSpritesheet];
        [theCell prepareToAppear];
        [theCell fill];
    }
    
    return [cellsToAdd count];
}

-(BOOL)refreshMatrix:(Cell *)exceptForCell{
    [self.fireStarters removeAllObjects];
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
            [self.fireStarters addObject:[tree objectAtIndex:0]];
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

-(void)setFire:(Cell *)fireStarter{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    BOOL uselessBoolLeft=NO;
    BOOL uselessBoolRight=NO;
    [self buildTree:fireStarter forTree:tree leftConnectionDetector:&uselessBoolLeft rightConnectionDetector:&uselessBoolRight];
    
    for (Cell *cell in tree)
    {
        if (cell.boardColumn == 0 && cell.antennaLeft)
        {
            /* Initial fire, has no passingInFlame*/
            [cell burn:Direction_Left];
        }
    }
    
    //    todo
    //    (GamePage.Current as GamePage).PlayBurningSoundEffect();
    
    GAME.burningCellsCount += [tree count];
    GAME.gameState = GameState_Burning;
}

#pragma mark - Cell

-(void)pushCellForReuse:(Cell *)cell{
    [cellReusePool addObject:cell];
}

-(Cell *)popCellForReuse{
    Cell *cell = [cellReusePool objectAtIndex:0];
    [cellReusePool removeObject:cell];
    return cell;
}

/*****************
 Each time the 'cell' parameter is set null, this method starts a new round of random picking.
 Return value of YES indicates that no acceptable cell is found and the cell has not changed at all.
 ***************/
-(BOOL)prepareCell:(Cell *)cell byDenying:(BOOL)deny{
    CellType cellType = cell.cellType;
    int cellRotation = cell.cellRotation;
    
    if (!deny) {
        [self initAvailableCellTypes];
        [self initAvailableCellRotations];
        cellType = [self getRandomAvailableCellType];
        cellRotation = [self getRandomCellRotation];
    }
    else{
        [self removeAvailableCellRotation:cell.cellRotation];
        if ([availableCellRotations count] == 0) { //all rotations are denied, so let's pick another BubbleType
            [self removeAvailableCellType:cell.cellType];
            
            if ([availableCellTypes count] == 0)// all cell types and rotations have been tested, yet not successful
            {
                //can not find any acceptable cell
                return YES;
            }
            else
            {
                // get a new type of cell with a random rotation
                cellType = [self getRandomAvailableCellType];
                [self initAvailableCellRotations];
                cellRotation = [self getRandomCellRotation];
            }
        }
        else{
            cellRotation = [self getRandomCellRotation];
        }
    }
    
    cell.cellType = cellType;
    cell.cellRotation = cellRotation;
    return NO;
}

-(void)updateCellTypePool:(CellType)cellType increase:(BOOL)increase{
    int increment = increase?1:-1;
    switch (cellType) {
        case CellType_I:
            cellCount_I += increment;
            break;
        case CellType_L:
            cellCount_L += increment;
            break;
        case CellType_T:
            cellCount_T += increment;
            break;
        case CellType_X:
            cellCount_X += increment;
            break;
        case CellType_H:
            cellCount_H += increment;
            break;
        case CellType_U:
            cellCount_U += increment;
            break;
        default:
            break;
    }
    
    if (cellCount_I >= CELL_COUNT_MAX_I)
        [cellTypePool removeObject:CellTypeObj_I];
    else if (![cellTypePool containsObject:CellTypeObj_I])
        [cellTypePool addObject:CellTypeObj_I];
    
    if (cellCount_L >= CELL_COUNT_MAX_L)
        [cellTypePool removeObject:CellTypeObj_L];
    else if (![cellTypePool containsObject:CellTypeObj_L])
        [cellTypePool addObject:CellTypeObj_L];
    
    if (cellCount_T >= CELL_COUNT_MAX_T)
        [cellTypePool removeObject:CellTypeObj_T];
    else if (![cellTypePool containsObject:CellTypeObj_T])
        [cellTypePool addObject:CellTypeObj_T];
    
    if (cellCount_X >= CELL_COUNT_MAX_X)
        [cellTypePool removeObject:CellTypeObj_X];
    else if (![cellTypePool containsObject:CellTypeObj_X])
        [cellTypePool addObject:CellTypeObj_X];
    
    if (cellCount_H >= CELL_COUNT_MAX_H)
        [cellTypePool removeObject:CellTypeObj_H];
    else if (![cellTypePool containsObject:CellTypeObj_H])
        [cellTypePool addObject:CellTypeObj_H];
    
    if (cellCount_U >= CELL_COUNT_MAX_U)
        [cellTypePool removeObject:CellTypeObj_U];
    else if (![cellTypePool containsObject:CellTypeObj_U])
        [cellTypePool addObject:CellTypeObj_U];
    
}

-(CellType)getRandomAvailableCellType{
    int index = arc4random() % [availableCellTypes count];
    NSNumber *cellTypeObj = [availableCellTypes objectAtIndex:index];
    return (CellType)[cellTypeObj intValue];
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

-(void)initAvailableCellTypes{
    [availableCellTypes removeAllObjects];
    for (id type in cellTypePool) {
        [availableCellTypes addObject:type];
    }
}

-(void)initAvailableCellRotations{
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
            if (![tree containsObject:theCell]) {
                [self buildTree:theCell forTree:tree leftConnectionDetector:leftBorderConnected rightConnectionDetector:rightBorderConnected];
            }
        }
    }
}

-(void)removeCell:(Cell *)cell{
    SET_CELL_AT_MATRIX(nil, cell.boardRow, cell.boardColumn);
    [self pushCellForReuse:cell];
    HIDE_GAME_OBJ(cell);
    [self updateCellTypePool:cell.cellType increase:NO];
}

@end
