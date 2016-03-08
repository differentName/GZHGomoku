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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //启动界面延迟1.5秒
    [NSThread sleepForTimeInterval:1.5];
    
    //友盟社会化分享
    [UMSocialData setAppKey:@"56dcfeec67e58e6f530020d5"];
    [UMSocialWechatHandler setWXAppId:@"wxcbc6a6dacb710eb7" appSecret:@"6d0392a072cc19a44832ab54f82fe6cb" url:@"https://itunes.apple.com/cn/genre/yin-le/id34"];
    //    wx98658a977b1dfbd0
    [UMSocialQQHandler setQQWithAppId:@"1105159385" appKey:@"jzmmLGxMw4j4uH6Q" url:@"https://itunes.apple.com/cn/genre/yin-le/id34"];
    
    //友盟分析
    [MobClick startWithAppkey:@"56dcfeec67e58e6f530020d5" reportPolicy:BATCH   channelId:@""];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
