//
//  GZHSettingController.m
//  五子棋
//
//  Created by 高增洪 on 16/3/24.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHSettingController.h"
#import "GZHExplainController.h"
@interface GZHSettingController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerview;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *SoundBtn;
@property (weak, nonatomic) IBOutlet UIButton *bgSoundBtn;

@end

@implementation GZHSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollerview.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height+10);
    
    self.title = @"游戏设置";
    self.slider.value = [[UIScreen mainScreen] brightness];
    //设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //设置导航栏背景颜色图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_black"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    //设置导航栏标题字体大小及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}


- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    //获取Documents目录
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"test.plist"];
    //使用一个字典来接受数据
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSNumber *number = [dict objectForKey:@"soundOpen"];
    if ([number intValue]==1) {
        //        [self.btnSound setSelected:!number.boolValue];
        self.SoundBtn.selected = YES;
    }else{
        self.SoundBtn.selected = NO;
    }
    if (dict==nil) {
        self.SoundBtn.selected = YES;
    }
    
    NSString *filePath2 = [docPath stringByAppendingPathComponent:@"test2.plist"];
    //使用一个字典来接受数据
    NSDictionary *dict2 = [NSDictionary dictionaryWithContentsOfFile:filePath2];
    NSNumber *number2 = [dict2 objectForKey:@"bgSoundOpen"];
    if ([number2 intValue]==1) {
        self.bgSoundBtn.selected = YES;
    }else{
        self.bgSoundBtn.selected = NO;
    }
    
    if (dict2==nil) {
        self.bgSoundBtn.selected = YES;
    }
    NSLog(@"%@",dict2);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)changeSliderValue:(UISlider *)sender {
    [[UIScreen mainScreen] setBrightness: sender.value];
}
- (IBAction)voiceOfSmall:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    NSNumber * number=[NSNumber numberWithBool:self.SoundBtn.selected];
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:@"test.plist"];
    //新建一个字典
    NSDictionary *array = @{@"soundOpen":number};
    //将数组存储到文件中
    [array writeToFile:filePath atomically:YES];
}
- (IBAction)voiceOfAll:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    NSNumber * number=[NSNumber numberWithBool:self.bgSoundBtn.selected];
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:@"test2.plist"];
    //新建一个字典
    NSDictionary *array = @{@"bgSoundOpen":number};
    //将数组存储到文件中
    [array writeToFile:filePath atomically:YES];

}
- (IBAction)explain:(UIButton *)sender {
    
    [self.navigationController pushViewController:[[GZHExplainController alloc] init] animated:YES];
}

- (IBAction)change:(UIButton *)sender {
}
@end
