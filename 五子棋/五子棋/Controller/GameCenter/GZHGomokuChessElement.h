//
//  GZHGomokuChessElement.h
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

// 棋子
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GZHGomokuChessType) {
    GZHGomokuChessTypeEmpty=0, // 空白
    GZHGomokuChessTypeBlack=1, // 黑子
    GZHGomokuChessTypeWhite=2, // 白子
};

@interface GZHGomokuChessElement : NSObject
@property(nonatomic,readonly) GZHGomokuChessType type;
+(instancetype)getChess:(GZHGomokuChessType)type;
@end
