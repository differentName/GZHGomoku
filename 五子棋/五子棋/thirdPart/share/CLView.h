//
//  CLView.h
//  弹出视图
//
//  Created by 高 增洪 on 16/1/29.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void (^RRBlock)(NSInteger index);


@interface CLView : UIView


/*
 *  为actionsheet上小视图
 *  按照 高度120（90（按钮60*60）+30）来设计
 */



@property (nonatomic,strong) UIButton *sheetBtn;

@property (nonatomic,strong) UILabel *sheetLab;


@property (nonatomic,copy) RRBlock block;


- (void)selectedIndex:(RRBlock)block;

@end
