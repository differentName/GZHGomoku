//
//  GZHWeatherController.m
//  周边按钮
//心知天气 API
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GZHWeatherController.h"
#import "GZHHttpTool.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "GZHWeatherModel.h"
#import "GZHWeatherView.h"
#import "GZHWeatherSuggestionController.h"
@interface GZHWeatherController ()
{
    AppDelegate *_apppdelegate;
}
//@property(nonatomic,strong) BOSSWeatherModel *model;

//当前用户所在的城市的经纬度
@property(nonatomic,assign) double lat;
@property(nonatomic,assign) double lon;
@property (weak, nonatomic) IBOutlet UIImageView *bgview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerview;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *tiganwendu;
@property (weak, nonatomic) IBOutlet UILabel *wendu;
@property (weak, nonatomic) IBOutlet UILabel *fengsu;
@property (weak, nonatomic) IBOutlet UILabel *shidu;
@property (weak, nonatomic) IBOutlet UILabel *nengjiandu;
@property (weak, nonatomic) IBOutlet UIScrollView *bottleView;
@property (nonatomic,strong) NSDictionary *dict;
@end

@implementation GZHWeatherController
- (NSDictionary *)dict
{
    if (_dict == nil) {
        _dict = [NSDictionary dictionary];
    }
    return _dict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollerview.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height+10);
    
    //AppDelegate对象
    _apppdelegate = [UIApplication sharedApplication].delegate;
    _lat = _apppdelegate.latitude;
    _lon = _apppdelegate.longitude;
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [MBProgressHUD showMessage:@"信息加载中"];
    //发送请求
    [self loadWeatherData];
    
    //设置导航栏背景颜色图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_black"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    //设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //设置导航栏标题字体大小及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    self.navigationItem.title = @"天气信息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"指南" style:UIBarButtonItemStylePlain target:self action:@selector(loadMoreWeatherData)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.bottleView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2.5, 0);

}

//天气指南
- (void)loadMoreWeatherData
{
    GZHWeatherSuggestionController *suggestion = [[GZHWeatherSuggestionController alloc]init];
    suggestion.dict = self.dict;
    [self.navigationController pushViewController:suggestion animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *dataStr = [formatter stringFromDate:[NSDate date]];
    int time = [dataStr intValue];
    
    if (time>=18||time<=06) {//晚上
        self.bottleView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    }
    else{//早上
        self.bottleView.backgroundColor = [UIColor clearColor];
    }
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


// //设置天气数据
//- (void)setModel:(BOSSWeatherModel *)model
//{
//    self.weather.text = model.text;
//    self.cityName.text = model.city_name;
//    self.wendu.text = model.temperature;
//    self.shidu.text = model.humidity;
//    self.winddirection.text = model.wind_direction;
//    self.windrank.text = model.wind_scale;
//    self.beginTime.text = model.sunrise;
//    self.endTime.text = model.sunset;
//}
//加载天气情况
- (void)loadWeatherData
{
    [MBProgressHUD hideHUD];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"key"] = @"CH1NOVBKN1";
    NSLog(@"%f---%f",_lat,_lon);
    if (_apppdelegate.latitude && _apppdelegate.longitude) {
        dict[@"city"] = [NSString stringWithFormat:@"%f:%f",_lat,_lon];
    }else{
        dict[@"city"] = @"33.93:116.40";
    }
    dict[@"language"] = @"zh-chs";
    dict[@"unit"] = @"c";
    [GZHHttpTool get:@"https://api.thinkpage.cn/v2/weather/all.json" params:dict success:^(id json) {
//        NSLog(@"%@",json);
        if ([json[@"status" ] isEqualToString:@"OK"]) {
            self.cityName.text = [json[@"weather"] firstObject][@"city_name"];
            self.timeLabel.text = [[json[@"weather"] firstObject][@"last_update"] componentsSeparatedByString:@"T"].firstObject;
            self.tiganwendu.text = [NSString stringWithFormat:@"%@℃",[json[@"weather"] firstObject][@"now"][@"feels_like"]];
            self.wendu.text =[NSString stringWithFormat:@"%@℃~%@℃",[[json[@"weather"] firstObject][@"future"]firstObject][@"low"], [[json[@"weather"] firstObject][@"future"]firstObject][@"high"]];
            self.fengsu.text =  [NSString stringWithFormat:@"%@风:%@m/s",[json[@"weather"] firstObject][@"now"][@"wind_direction"],[json[@"weather"] firstObject][@"now"][@"wind_speed"]];
            
            self.shidu.text = [NSString stringWithFormat:@"%@%%",[json[@"weather"] firstObject][@"now"][@"humidity"]];
            
            self.nengjiandu.text = [NSString stringWithFormat:@"%@km",[json[@"weather"] firstObject][@"now"][@"visibility"]];
            self.weatherIcon.image = [UIImage imageNamed:[self selectedWeatherIconWithName:[json[@"weather"] firstObject][@"now"][@"text"]]];
            
            self.bgview.image = [UIImage imageNamed:[self selectedWeatherBgImgWithName:[json[@"weather"] firstObject][@"now"][@"text"]]];
            
//            self.dict = [json[@"weather"] firstObject][@"now"][@"feels_like"]];
            self.dict = [json[@"weather"] firstObject][@"today"][@"suggestion"];
            
            NSArray *weatherAry = [GZHWeatherModel objectArrayWithKeyValuesArray:[json[@"weather"] firstObject][@"future"]];
            for (int i = 0; i<weatherAry.count; i++) {
                GZHWeatherView *weatherView = [[GZHWeatherView alloc]initWithFrame:CGRectMake(self.bottleView.frame.size.width/4*i, 0, self.bottleView.frame.size.width/4, self.bottleView.frame.size.height)];
                weatherView.model = weatherAry[i];
                [self.bottleView addSubview:weatherView];
            }
            
        }else{
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"无法确定您当前的位置"];
    }];
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


- (NSString *)selectedWeatherBgImgWithName:(NSString *)str{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *dataStr = [formatter stringFromDate:[NSDate date]];
    int time = [dataStr intValue];

    if ([str containsString:@"晴"]) {
        if (time>=18||time<=06) {//晚上
            return @"bg_night_sunny";
        }
        else{//早上
            return @"bg_sunny";
        }
    }else if([str containsString:@"雾"]||[str containsString:@"霾"]||[str containsString:@"阴"]){
        if (time>=18||time<=06) {//晚上
            return @"bg_night_fog";
        }
        else{//早上
            return @"bg_fog";
        }
    }else if([str containsString:@"雨"]){
        if (time>=18||time<=06) {//晚上
            return @"bg_night_rain";
        }
        else{//早上
            return @"bg_rain";
        }
    }else if([str containsString:@"雪"]){
        if (time>=18||time<=06) {//晚上
            return @"bg_night_snow";
        }
        else{//早上
            return @"bg_snow";
        }
    }else if ([str containsString:@"闪"]){
        if (time>=18||time<=06) {//晚上
            return @"bg_night_light";
        }
        else{//早上
            return @"bg_light";
        }
    }else{
        return @"bg_weather";
    }
}


@end
