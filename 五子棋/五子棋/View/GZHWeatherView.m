//
//  GZHWeatherView.m
//  五子棋
//
//  Created by 高增洪 on 16/3/23.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHWeatherView.h"
#import "GZHWeatherModel.h"
@interface GZHWeatherView()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *wendu;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;

@end
@implementation GZHWeatherView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
    }
    
    //获得nib视图数组
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GZHWeatherView" owner:self options:nil];
    //得到第一个UIView
    UIView *tmpCustomView = [nib objectAtIndex:0];
    tmpCustomView.frame = frame;
    //添加视图
    self = (GZHWeatherView *)tmpCustomView;
//    　NSNumber *bl = (NSNumber*) CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("SBBacklightLevel" ), CFSTR("com.apple.springboard")));
//    　previousBacklightLevel = [bl floatValue];
    return self;
}
- (void)setModel:(GZHWeatherModel *)model
{
    _model = model;
    NSLog(@"%@",model.text);
    self.timeLabel.text = model.day;
    self.wendu.text = [NSString stringWithFormat:@"%@℃~%@℃",model.low,model.high];
    self.windLabel.text = model.wind;
    self.iconImg.image = [UIImage imageNamed:[self selectedWeatherIconWithName:model.text]];
}


- (NSString *)selectedWeatherIconWithName:(NSString *)str{
    if ([str containsString:@"晴"]) {
        return @"sunny";
    }else if([str containsString:@"雾"]||[str containsString:@"霾"]){
        return @"fog";
    }else if([str containsString:@"雨"]&&[str containsString:@"雪"]){
        return @"yujiaxue";
    }else if([str containsString:@"雨"]){
        return @"yu";
    }else if([str containsString:@"雪"]){
        return @"xue";
    }else if([str containsString:@"阴"]){
        return @"yin";
    }else if ([str containsString:@"闪"]){
        return @"light";
    }else{
        return @"duoyun";
    }
}

@end
