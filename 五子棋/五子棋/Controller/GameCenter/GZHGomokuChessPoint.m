//
//  GZHGomokuChessPoint.m
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import "GZHGomokuChessPoint.h"

@implementation GZHGomokuChessPoint
+(instancetype)pointAtRow:(NSInteger)row line:(NSInteger)line 
{
    return [[GZHGomokuChessPoint alloc]initWithRow:row line:line];
}
-(instancetype)initWithRow:(NSInteger)row line:(NSInteger)line
{
    self=[super init];
    if (self) {
        _row=row;
        _line=line;
    }
    return self;
}
-(void)statuChanged
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(chessPointStatuChanged:)]) {
        [self.delegate chessPointStatuChanged:self];
    }
}

@end
