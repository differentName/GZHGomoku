//
//  GZHGomokuChessboard.h
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//


// 棋局的抽象

#define RowCount 15
#define CenterRow 8

#import <Foundation/Foundation.h>
#import "GZHGomokuChessPoint.h"



@interface NSNumber (cache)
+(NSNumber*)cahceNumber:(NSInteger)value;
@end



@interface GZHGomokuChessboard : NSObject<GZHGomokuChessPointProtocol>
@property(nonatomic,strong,readonly)NSArray * points;
@property(nonatomic,strong)NSArray * successPoints; //胜利的五个子
+(instancetype)newChessboard;

-(GZHGomokuChessPoint*)pointAtRow:(NSInteger)row line:(NSInteger)line;

-(BOOL)couldChessDowm:(GZHGomokuChessPoint*)point;


-(NSInteger)calculate;

-(NSInteger)determine; // 0: 谁也没胜 ， 1 : 黑棋胜利   2:  白棋胜利

-(void)enumerateFrom:(GZHGomokuChessPoint*)point callback:(BOOL(^)(GZHGomokuChessPoint*))callback; // 从最后落子点的周围开始枚举

@end
