//
//  HBPlaySoundUtil.h
//  wq8
//
//  Created by 高增洪 on 16-4-16.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface HBPlaySoundUtil : NSObject
{
    SystemSoundID soundID;
    int _type;
}
-(id)initForPlayingVibrate; //震动
-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type;  //系统声音
-(id)initForPlayingSoundEffectWith:(NSString *)filename;  //自定义声音

-(void)play;

+(id)shareForPlayingVibrate;
+(id)sharePlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type;
+(id)shareForPlayingSoundEffectWith:(NSString *)filename;

@end
