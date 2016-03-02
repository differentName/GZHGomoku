//
//  GZHGomokuBaseStack.h
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GZHGomokuChessPoint.h"
@interface GZHGomokuBaseStack : NSObject

-(NSInteger)depth;
-(void)push:(GZHGomokuChessPoint*)element;
-(GZHGomokuChessPoint*)pop;
-(void)reuse;
-(GZHGomokuChessPoint*)getTopElement;
@end
