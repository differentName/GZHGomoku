//
//  GZHSettingController.m
//  五子棋
//
//  Created by 高增洪 on 16/3/24.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHSettingController.h"

@interface GZHSettingController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerview;
@property (weak, nonatomic) IBOutlet UISlider *slider;

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
}
- (IBAction)voiceOfAll:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)explain:(UIButton *)sender {
}

- (IBAction)change:(UIButton *)sender {
}
@end
