//
//  AppDelegate.h
//  五子棋
//
//  Created by 高增洪 on 16/3/2.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//当前用户所在的城市
@property(nonatomic,copy) NSString *cityName;

//当前用户所在的城市的经纬度
@property(nonatomic,assign) double latitude;
@property(nonatomic,assign) double longitude;

@end

