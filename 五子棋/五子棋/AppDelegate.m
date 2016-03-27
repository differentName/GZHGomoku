//
//  AppDelegate.m
//  五子棋
//
//  Created by 高增洪 on 16/3/2.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "MobClick.h"
#import "MobClickSocialAnalytics.h"
#import "CCLocationManager.h"
#import "GZHFeatureVC.h"
@interface AppDelegate ()<CLLocationManagerDelegate>
@property (nonatomic,strong) CCLocationManager *locationMag;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建窗口  并作为主窗口显示出来
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    self.window = window;
    
    
    application.windows.lastObject.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    //获取用户当前所在城市
    dispatch_async(dispatch_get_main_queue(), ^{
        self.locationMag = [CCLocationManager shareLocation];
        [self.locationMag getCity:^(NSString *addressString) {
            _cityName = addressString;
            NSLog(@"!!!!!!!!!!!!!!!!%@",_cityName);
        }];
        
        [self.locationMag getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            _longitude = locationCorrrdinate.longitude;
            _latitude = locationCorrrdinate.latitude;
            NSLog(@"!!!!!!!!!!!!!!!!%f--%f",_longitude,_latitude);
        }];
    });

    //启动界面延迟1.5秒
    [NSThread sleepForTimeInterval:1.5];
    
    //友盟社会化分享
    [UMSocialData setAppKey:@"56dcfeec67e58e6f530020d5"];
    [UMSocialWechatHandler setWXAppId:@"wxcbc6a6dacb710eb7" appSecret:@"6d0392a072cc19a44832ab54f82fe6cb" url:@"https://itunes.apple.com/cn/genre/yin-le/id34"];
    //    wx98658a977b1dfbd0
    [UMSocialQQHandler setQQWithAppId:@"1105159385" appKey:@"jzmmLGxMw4j4uH6Q" url:@"https://itunes.apple.com/cn/genre/yin-le/id34"];
    
    //友盟分析
    [MobClick startWithAppkey:@"56dcfeec67e58e6f530020d5" reportPolicy:BATCH   channelId:@""];
    
    [self isShowFeature];

    return YES;
}
- (void)isShowFeature{
    /**判断是否显示版本新特性*/
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //1>读取上次打开此软件时的版本号（上次的版本号存在沙盒里，从沙盒中读取）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:@"version"];
    //2>读取这个打开时软件的版本号（存储在info.plist文件中）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    //3>比较两个版本号是否相同，相同则不展示，不相同则展示版本新特性
    NSLog(@"%@---%@",lastVersion,currentVersion);
    if ([currentVersion isEqualToString:lastVersion]) {//前后版本相同  不展示版本新特性
        window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GZHHomeController"];
    }else{
        GZHFeatureVC *featureVc = [[GZHFeatureVC alloc]init];
        window.rootViewController = featureVc;
        //将这个的版本号存储在沙盒里，key就是1>读取沙盒信息的那个key
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"version"];
        [[NSUserDefaults standardUserDefaults]synchronize];//立即同步
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     [[UIScreen mainScreen] setBrightness: 0.5];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
