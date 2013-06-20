//
//  Constants.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-19.
//  Copyright (c) 2013年 namiapps. All rights reserved.
//

#pragma mark - Board

//extern const int BOARD_ROW_COUNT;
//extern const int BOARD_COLUMN_COUNT;
/* The reason to use #define instead of const, is to use two-dimensional array for cellMatrix in BoardLayer */
#define BOARD_ROW_COUNT 8
#define BOARD_COLUMN_COUNT 5
#pragma mark - Board

//static int BOARD_ROW_COUNT = 8;
//static int BOARD_COLUMN_COUNT = 5;
//static CGPoint BOARD_ORIGIN = {55,55};
static CGFloat BURNING_DURATION = 0.6;//0.6;

#pragma mark - Cell

//static CGSize CELL_SIZE = {50,50};
static CGFloat CELL_DROP_DURATION = 0.3;
static CGFloat CELL_ROTATION_DURATION = 0.15;//0.15;
static CGFloat CELL_GLOW_DURATION = 0.8;//0.8;
static int CELL_COUNT_MAX_I = 12;//12;
static int CELL_COUNT_MAX_L = 40;//40;
static int CELL_COUNT_MAX_T = 4;//4;
static int CELL_COUNT_MAX_X = 2;//2;
static int CELL_COUNT_MAX_H = 1;//1;
static int CELL_COUNT_MAX_U = 0;//1;

#pragma mark - Monster
static CGFloat MONSTER_MOVING_DURATION = 0.3;
static CGFloat MONSTER_ANGRY_DURATION = 0.3;
static CGFloat MONSTER_FLASHING_INTERVAL = 0.05;
static CGFloat MONSTER_SCORE_FADING_DURATION = 0.25;
static CGFloat MONSTER_SCORE_FLOATING_DURATION = 1;

#pragma mark - Electric Effect
//static CGFloat ELECTRIC_NODE_RADIUS = 8;

#pragma mark - Particle System

#pragma mark - Scene
static CGFloat SCENE_TRANSITION_DURATION = 0.5;

#pragma mark - Bonus
static CGFloat CONGRATULATION_ACTION_DURATION = 0.5;
static CGFloat BONUS_MOVEMENT_DURATION = 0.5;
static int BOMB_DAMAGE = 99;
static CGFloat BOMBING_DURATION = 1;
static CGFloat CLOUD_FLICKER_INTERVAL = 1;

#pragma mark - GameOver
static CGFloat PAUSE_PANEL_MOVEMENT_DURATION = 0.3;

#pragma mark - Home Layer
static CGFloat SUNSHINE_ROTATION_INTERVAL = 8;

#pragma mark - Z Index
// home layer
static int Z_INDEX_HOME_LAYER_BASE = 1;//background
static int Z_INDEX_HOME_LAYER_TITLE = 2;
static int Z_INDEX_HOME_LAYER_MENU = 3;
static int Z_INDEX_HOME_LAYER_PAUSE_PANEL = 4;//pause panel

// board layer
static int Z_INDEX_BOARD_LAYER_1 = 1;
static int Z_INDEX_BOARD_LAYER_2 = 2;
static int Z_INDEX_BOARD_LAYER_3 = 3;//monster, bonus, game pause panel, etc.
static int Z_INDEX_BOARD_LAYER_4 = 4;//burn score
static int Z_INDEX_BOARD_LAYER_5 = 5;//top bar label
static int Z_INDEX_BOARD_LAYER_PAUSE_PANEL = 6;//pause panel

//Z_INDEX_BOARD_LAYER_3
static int Z_INDEX_SPARKLE = 10;
static int Z_INDEX_BOMB_FLAME = 20;
static int Z_INDEX_MONSTER = 30;
static int Z_INDEX_MONSTER_EYE = 31;
static int Z_INDEX_BONUS = 40;
static int Z_INDEX_CONGRATULATION = 50;
static int Z_INDEX_TOP_BAR = 60;
static int Z_INDEX_TOP_BAR_BATTERY = 61;


#pragma mark - Enum

typedef enum {
    GameState_Idle=0,
    GameState_CellRotating,
    GameState_Burning,
    GameState_Bombing,
    GameState_Storming,
    GameState_Dropping,
    GameState_Filling,
    GameState_Chain,
    GameState_MonsterMoving,
    GameState_BonusAwarding,
    GameState_Paused
} GameState;

typedef enum {
    CellType_I=0,
    CellType_L=1,
    CellType_T=2,
    CellType_X=3,
    CellType_H=4,
    CellType_U=5,/* unknown */
} CellType;

typedef enum {
    CellState_Normal=0,
    CellState_LeftConnected=1,
    CellState_RightConnected=2,
    CellState_Hint=3,
    CellState_Glow=4,
    CellState_Burnt=5
} CellState;

typedef enum{
    MonsterType_Small=0,
    MonsterType_Drunk=1,
    MonsterType_Strong=2,
    MonsterType_Fast=3,
    MonsterType_Queen=4,
    MonsterType_King=5
} MonsterType;

typedef enum {
    Direction_Top=0,
    Direction_Left=1,
    Direction_Bottom=2,
    Direction_Right=3
} Direction;

typedef enum {
    BonusType_Combo,
    BonusType_Chain
}BonusType;

#pragma mark - Struct

//struct CellData {
//    CellType cellType;
//    int cellRotation;
//    int boardRow;
//    int boardColumn;
//};
//typedef struct CellData CellData;

#pragma mark - Macro
/*** screen adaption ***/
#define WIN_SIZE [[CCDirector sharedDirector] winSize]
#define WINCENTER ccp(WIN_SIZE.width/2, WIN_SIZE.height/2)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define dscale(n) (IS_IPAD ? n*2 : n)
#define dccp(x,y) (IS_IPAD ? ccp(x*2,y*2) : ccp(x,y))
#define dchoose(i,j) (IS_IPAD ? j : i)

/*** game logic related ***/
#define GAME [GamePlayScene sharedInstance]
#define BOARD [BoardLayer sharedInstance]
#define CELL_AT_MATRIX(ROW,COLUMN) [[BoardLayer sharedInstance] cellAtMatrix:ROW column:COLUMN]
#define SET_CELL_AT_MATRIX(CELL,ROW,COLUMN) [[BoardLayer sharedInstance] setCellAtMatrix:CELL row:ROW column:COLUMN]
#define REFRESH_MATRIX(EXCEPT_FOR) [[BoardLayer sharedInstance] refreshMatrix:EXCEPT_FOR]
#define A_PLACE_TO_HIDE ccp(-WIN_SIZE.width,-WIN_SIZE.height)
#define HIDE_GAME_OBJ(OBJ) OBJ.sprite.position = ccp(-WIN_SIZE.width,-WIN_SIZE.height)
#define HIDE_CCNODE(NODE) NODE.position = ccp(-WIN_SIZE.width,-WIN_SIZE.height)
#define HIDE_SPRITE(SPRITE) SPRITE.position = ccp(-WIN_SIZE.width,-WIN_SIZE.height)

#define CELL_SIZE (CGSize){dscale(50),dscale(50)}
#define BOARD_ORIGIN (CGPoint){WINCENTER.x-(BOARD_COLUMN_COUNT-1)*CELL_SIZE.width/2,WINCENTER.y-(BOARD_ROW_COUNT-1)*CELL_SIZE.height/2}
#define ELECTRIC_NODE_RADIUS dscale(7)

#define CLOUD_POINT ccp(WIN_SIZE.width/2, WINCENTER.y + (BOARD_ROW_COUNT+1)*CELL_SIZE.height/2)
#define BATTERY_POSITION ccp(dscale(20),WIN_SIZE.height-dscale(50))



