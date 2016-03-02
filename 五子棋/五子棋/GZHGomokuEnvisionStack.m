//
//  GZHGomokuEnvisionStack.m
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import "GZHGomokuEnvisionStack.h"

@implementation GZHGomokuValue
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.value=0;
    }
    return self;
}
@end


@interface GZHGomokuEnvisionStack ()
@property(nonatomic,strong)NSMutableArray * values;

@end

@implementation GZHGomokuEnvisionStack
-(instancetype)init
{
    self=[super init];
    if (self ) {
        _values=[NSMutableArray array];
    }
    return self;
}
-(void)reuse
{
 //   NSLog(@"\n\n\n\n\n\n\n **********************");
    [super  reuse];
    _maxPoint=nil;
    _maxValue=nil;
    _values=[NSMutableArray array];
}

-(void)push:(GZHGomokuChessPoint*)element type:(GZHGomokuChessType)type
{
    if (element.chess!=nil) {
        return;
    }
    element.virtualChessType=type;
    [super push:element];
    [_values addObject:[[GZHGomokuValue alloc]init]];
}

-(GZHGomokuChessPoint*)onlyPop
{
    NSInteger depth=[self depth];
    if (depth==0) {
        return nil;
    }
    GZHGomokuChessPoint * point=[super pop];
    point.virtualChessType=GZHGomokuChessTypeEmpty;
    [_values removeObjectAtIndex:_values.count-1];
    return point;
}

-(GZHGomokuChessPoint*)pop
{
    NSInteger depth=[self depth];
    if (depth==0) {
        return nil;
    }
    GZHGomokuChessPoint * point=[super pop];
    point.virtualChessType=GZHGomokuChessTypeEmpty;
    GZHGomokuValue * value=[_values lastObject];
    if (depth==1) {
        if (_maxValue==nil) {
            _maxValue=[[GZHGomokuValue alloc]init];
            _maxValue.value=value.value;
            _maxPoint=point;
         //   NSLog(@"ROW: %d , LINE:%d  score :%d",point.row,point.line,self.maxValue.value);
        }
        if (value.value>_maxValue.value) {
            _maxValue.value=value.value;
            _maxPoint=point;
         //   NSLog(@"ROW: %d , LINE:%d  score :%d",point.row,point.line,self.maxValue.value);
        }
    }
    [_values removeObjectAtIndex:_values.count-1];
    if (_values.count>0) {
        GZHGomokuValue * valueBottom=[_values lastObject];
        if (valueBottom.hasValue) {
            if (depth%2==0) {
                valueBottom.value=valueBottom.value<value.value?valueBottom.value:value.value;
            }else{
                valueBottom.value=valueBottom.value>value.value?valueBottom.value:value.value;
            }
        }else{
            valueBottom.value=value.value;
            valueBottom.hasValue=YES;
        }
    }
    return point;
}

-(void)pushLeafValue:(NSInteger)value
{
    GZHGomokuValue * valueBottom=[_values lastObject];
    valueBottom.hasValue=YES;
    valueBottom.value=value;
}

-(BOOL)pruning
{
    NSInteger depth=[self depth];
    if (depth>0) {
        GZHGomokuValue * bottomValue=[_values lastObject];
        GZHGomokuValue *secondValue;
        if (depth>1) {
            secondValue=[_values objectAtIndex:depth-2];
        }else if(self.maxValue){
            secondValue=self.maxValue;
        }
        if (secondValue) {
            if (depth%2==0) {
                if (bottomValue.value>=secondValue.value) {
                    return YES;
                }else{
                    return NO;
                }
            }else{
                if (bottomValue.value<=secondValue.value) {
                    return YES;
                }else{
                    return NO;
                }
            }
        }
    }
    return NO;
}



@end
