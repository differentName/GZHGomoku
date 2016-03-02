//
//  GZHGomokuChessElement.m
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import "GZHGomokuChessElement.h"

@implementation GZHGomokuChessElement
+(instancetype)getChess:(GZHGomokuChessType)type
{
    GZHGomokuChessElement * chess=[[GZHGomokuChessElement alloc]initWithType:type];
    return chess;
    
}
-(instancetype)initWithType:(GZHGomokuChessType)type{
    self=[super init];
    if (self) {
        _type=type;
    }
    return self;
}

@end
