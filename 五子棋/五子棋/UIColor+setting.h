//
//  UIColor+setting.h
//  wq
//
//  Created by 高增洪 on 16-4-29.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BACKGROUND_COLOR 0xF8F8F8


@interface UIColor (setting)
+ (UIColor *)colorWithIntegerValue:(NSUInteger)value alpha:(CGFloat)alpha;
@end
