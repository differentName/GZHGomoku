//
//  GZHGomokuGameEngine.h
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

// 游戏引擎

#import <Foundation/Foundation.h>
#import "GZHGomokuChessPoint.h"
#import "GZHGomokuEnvisionStack.h"
#import "GZHGomokuChessboard.h"
typedef NS_ENUM(NSUInteger, GZHGameSoundType) {
    GZHGameSoundTypeError,
    GZHGameSoundTypeStep,
    GZHGameSoundTypeVictory,
    GZHGameSoundTypeFailed,
    GZHGameSoundTypeTimeOver
};

typedef NS_ENUM(NSUInteger, GZHGameErrorType) {
    GZHGameErrorTypeChessAxist,
    GZHGameErrorTypeComputerIsChessing,
};

typedef NS_ENUM(NSUInteger, GZHGameStatu) {
    GZHGameStatuPlayChessing,
    GZHGameStatuComputerChessing,
    GZHGameStatuFinished
};


@class GZHGomokuGameEngine;
@protocol GZHGomokuGameEngineProtocol <NSObject>

-(void)game:(GZHGomokuGameEngine*)game updateSences:(GZHGomokuChessPoint*)point;

-(void)game:(GZHGomokuGameEngine*)game finish:(BOOL)success;

-(void)game:(GZHGomokuGameEngine*)game error:(GZHGameErrorType)errorType;

-(void)game:(GZHGomokuGameEngine*)game playSound:(GZHGameSoundType)soundType;

-(void)game:(GZHGomokuGameEngine *)game statuChange:(GZHGameStatu)gameStatu;

-(void)gameRestart:(GZHGomokuGameEngine*)game;

-(void)game:(GZHGomokuGameEngine*)game undo:(GZHGomokuChessPoint*)point;


@end

@interface GZHGomokuGameEngine : NSObject

@property(nonatomic,strong)id<GZHGomokuGameEngineProtocol>delegate;
@property(nonatomic,strong)GZHGomokuEnvisionStack * envisionStack;
@property(nonatomic,strong)GZHGomokuChessboard * chessBoard;
@property(nonatomic)GZHGameStatu gameStatu;
@property(nonatomic)NSInteger maxDepth;
@property(nonatomic)BOOL playerFirst;  //  YES : 玩家先手（黑棋）  NO :玩家后手(白棋)

+(instancetype)game;

-(void)playerChessDown:(NSInteger)row line:(NSInteger)line;

-(void)reStart;

-(BOOL)undo;

-(void)begin;


@end
