//
//  GZHGomokuOverViewController.h
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-4.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZHGomokuOverViewController : UIViewController
@property(nonatomic)BOOL success;
@property(nonatomic)NSInteger stepCount;
@property(nonatomic,strong)UIImage * backImage;
@property(nonatomic,copy)void(^callback)();
@end
