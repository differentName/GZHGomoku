//
//  GZHGomokuLinePoints.m
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-3.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import "GZHGomokuLinePoints.h"
#import "GZHGomokuChessModelTemplate.h"
#import "GZHGomokuChessPoint.h"

/**
 *
 *  每一个棋的状态可由两位的比特位来表示  00, 01 ,10
 *  GZHGomokuChessTypeBlack (黑棋)   01  ==1
 *
 *  GZHGomokuChessTypeWhite (白棋)   10  ==2
 *
 *  GZHGomokuChessTypeEmpty (空位)   11  ==3
 */

@interface GZHGomokuLinePoints ()

@end

@implementation GZHGomokuLinePoints
-(NSInteger)calculate
{
    if (!self.statuChange) {
        return self.lastScore;
    }
    self.statuChange=NO;
    long long modelValue=[self modelValue];
    if (modelValue==_lastModelValue) {
        return _lastScore;
    }
    _lastScore=[[GZHGomokuChessModelTemplate shareTemplete] calculateScoreWithModelValue:modelValue];
    _lastModelValue=modelValue;
    return _lastScore;
}
-(NSInteger)count
{
    return self.array.count;
}

-(instancetype)initWithArray:(NSArray*)array
{
    self=[super init];
    if (self) {
        self.statuChange=YES;
        self.array=array;
    }
    return self;
}

-(id)objectAtIndex:(NSUInteger)index
{
    return [self.array objectAtIndex:index];
}

-(long long)modelValue
{
    long long value=0;
    NSInteger blackCount=0;
    NSInteger whiteCount=0;
    for (NSInteger i=0; i<self.array.count; i++) {
        GZHGomokuChessPoint * point=[self objectAtIndex:i];
        NSInteger ret=3;
        if (point.chess!=nil) {
            if (point.chess.type==GZHGomokuChessTypeWhite) {
                ret=2;
                whiteCount++;
            }else if(point.chess.type==GZHGomokuChessTypeBlack){
                ret=1;
                blackCount++;
            }
        }else if(point.virtualChessType==GZHGomokuChessTypeBlack){
            ret=1;
            blackCount++;
        }else if(point.virtualChessType==GZHGomokuChessTypeWhite){
            ret=2;
            whiteCount++;
        }
        value+=ret;
        value=value<<2;
    }
    if (blackCount+whiteCount==0) {
        value=0;
    }
    return value;
}





@end
