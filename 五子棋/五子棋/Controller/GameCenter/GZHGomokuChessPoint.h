//
//  GZHGomokuChessPoint.h
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

// 棋盘的某个棋子落子点

#import <Foundation/Foundation.h>
#import "GZHGomokuChessElement.h"

@class GZHGomokuChessPoint;

@protocol GZHGomokuChessPointProtocol <NSObject>

-(void)chessPointStatuChanged:(GZHGomokuChessPoint*)point;

@end

@interface GZHGomokuChessPoint : NSObject

@property(nonatomic,strong)GZHGomokuChessElement * chess;
@property(nonatomic)GZHGomokuChessType  virtualChessType;  // 该位子上的虚拟棋子类型 （仅当chess 为空时有效）
@property(nonatomic,readonly)NSInteger row;
@property(nonatomic,readonly)NSInteger line;
@property(nonatomic)BOOL couldEnum;
@property(nonatomic,strong)id<GZHGomokuChessPointProtocol>delegate;
+(instancetype)pointAtRow:(NSInteger)row line:(NSInteger)row;

-(void)statuChanged;

@end
