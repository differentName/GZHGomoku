//
//  GZHGomokuPieceView.h
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZHGomokuChessPoint.h"
@interface GZHGomokuPieceView : UIView
@property(nonatomic,strong)GZHGomokuChessPoint * point;
+(instancetype)piece:(GZHGomokuChessPoint*)point;
-(void)setSelected:(BOOL)selected;

@end
