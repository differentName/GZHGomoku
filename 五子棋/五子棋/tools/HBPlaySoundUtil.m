//
//  HBPlaySoundUtil.m
//  wq8
//
//  Created by 高增洪 on 16-4-16.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import "HBPlaySoundUtil.h"
#import <AVFoundation/AVFoundation.h>
@interface HBPlaySoundUtil()
@property (nonatomic,strong) AVAudioPlayer *player;
@end
@implementation HBPlaySoundUtil
-(id)initForPlayingVibrate
{
    self=[super init];
    if(self){
         soundID = kSystemSoundID_Vibrate; 
    }
    return self;
}
-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type
{
    self=[super init];
    _type=1;
    if(self){
        NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:resourceName ofType:type];
        if (path) {
            SystemSoundID theSoundID;
            OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
            if (error == kAudioServicesNoError) {
                soundID = theSoundID;
            }else {
                NSLog(@"Failed to create sound ");
            }
        }
    }
    return self;
}
-(id)initForPlayingSoundEffectWith:(NSString *)filename
{
    self=[super init];
    _type=2;
    if(self){
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (fileURL != nil)
        {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError){
                soundID = theSoundID;
            }else {
                NSLog(@"Failed to create sound ");
            }
        }
    }
    return self;
}

-(void)play
{
    AudioServicesPlaySystemSound(soundID);
}

+(id)shareForPlayingVibrate
{
    static HBPlaySoundUtil * util=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util=[[HBPlaySoundUtil alloc]initForPlayingVibrate];
    });
    return util;
}
+(id)sharePlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type
{
    static HBPlaySoundUtil * util=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util=[[HBPlaySoundUtil alloc]initForPlayingSystemSoundEffectWith:resourceName ofType:type];
    });
    return util;
}
+(id)shareForPlayingSoundEffectWith:(NSString *)filename;
{
    if (filename==nil) {
        return nil;
    }
    static NSMutableDictionary * dic=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic=[NSMutableDictionary dictionary];
    });
    HBPlaySoundUtil * util=[dic objectForKey:filename];
    if (util==nil) {
        util=[[HBPlaySoundUtil alloc]initForPlayingSoundEffectWith:filename];
        [dic setObject:util forKey:filename];
    }
    return util;
}
- (void)playBgVoice{
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"BgMusic" ofType:@"mp3"]] error:nil];//使用本地URL创建
    _player = player;
    player.volume =0.2;//0.0-1.0之间
    player.numberOfLoops = 99999;//默认只播放一次
    [player play];//播放
}

- (void)stopBgVoice{
    if (_player) {
        [_player stop];//停止
    }
}
@end
