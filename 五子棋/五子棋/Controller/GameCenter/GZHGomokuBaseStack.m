//
//  GZHGomokuBaseStack.m
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import "GZHGomokuBaseStack.h"

@interface GZHGomokuBaseStack ()
@property(nonatomic,strong)NSMutableArray * datas;
@end

@implementation GZHGomokuBaseStack

-(void)reuse
{
    _datas=[NSMutableArray array];
}
-(instancetype)init
{
    self=[super init];
    if (self) {
        _datas=[NSMutableArray array];
    }
    return self;
}

-(void)push:(GZHGomokuChessPoint*)element
{
    if (element) {
        [element statuChanged];
        [_datas addObject:element];
    }
}

-(GZHGomokuChessPoint*)pop
{
    if (_datas.count==0) {
        return nil;
    }
    GZHGomokuChessPoint * point=[_datas objectAtIndex:_datas.count-1];
    point.chess=nil;
    [point statuChanged];
    [_datas removeObjectAtIndex:_datas.count-1];
    return point;
}
-(NSInteger)depth
{
    return _datas.count;
}

-(GZHGomokuChessPoint*)getTopElement
{
    return [_datas lastObject];
}

@end
