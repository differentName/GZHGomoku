//
//  GZHGomokuEnvisionStack.h
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GZHGomokuBaseStack.h"


// 搜索栈，寻找最佳棋步

@interface GZHGomokuValue : NSObject
@property(nonatomic)NSInteger value;
@property(nonatomic)BOOL hasValue;

@end

@interface GZHGomokuEnvisionStack : GZHGomokuBaseStack
@property(nonatomic)BOOL playerFirst;  //  YES : 玩家先手（黑棋）  NO :玩家后手(白棋)
@property(nonatomic,strong)GZHGomokuValue* maxValue;
@property(nonatomic,strong,readonly)GZHGomokuChessPoint * maxPoint;

-(void)push:(GZHGomokuChessPoint*)element type:(GZHGomokuChessType)type;

-(void)pushLeafValue:(NSInteger)value;   // 设置叶子节点的值

-(BOOL)pruning;   //是否需要剪枝

-(void)reuse;

-(GZHGomokuChessPoint*)onlyPop;

@end
