//
//  GZHSettingController.m
//  五子棋
//
//  Created by 高增洪 on 16/3/24.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHSettingController.h"
#import "GZHExplainController.h"
#import "MBProgressHUD+MJ.h"
@interface GZHSettingController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerview;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *SoundBtn;
@property (weak, nonatomic) IBOutlet UIButton *bgSoundBtn;
@property (weak, nonatomic) IBOutlet UIImageView *currentImg;
@property (nonatomic,strong)  UIView *bgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *cancleBtn;
@property (assign, nonatomic) int currentBgImgNum;
@property (nonatomic,strong) UIButton *currentBtn;
@property (nonatomic,strong) NSArray *nameAry;
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
    
    self.currentImg.clipsToBounds = YES;
    self.currentImg.layer.cornerRadius = 20;
    
    self.nameAry = @[@"泛舟湖上",@"湖光山色",@"粉墨登场",@"绿水青山",@"花开富贵",@"闲云野鹤",@"高山流水",@"儿时童趣",@"妙笔丹青",@"常规棋盘"];
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
    
    NSString *filePath3 = [docPath stringByAppendingPathComponent:@"test3.plist"];
    //使用一个字典来接受数据
    NSDictionary *dict3 = [NSDictionary dictionaryWithContentsOfFile:filePath3];
    NSLog(@"%@",dict3);
    if (dict3==nil) {
        self.currentBgImgNum = 0;
    }else{
    NSString *currentImgName = [dict3 objectForKey:@"currentBgImgName"];
    self.currentBgImgNum = [[currentImgName componentsSeparatedByString:@"_"].lastObject intValue];
    }
    
    self.currentImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"background_%d",self.currentBgImgNum]];
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
    [self addChangeBgimgView];
}

- (void)addChangeBgimgView{
    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    self.bgView = bgView;
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTapFrom)];
    [self.bgView addGestureRecognizer:singleRecognizer];
    
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    UIScrollView *iconScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,  [UIApplication sharedApplication].keyWindow.frame.size.height, [UIApplication sharedApplication].keyWindow.frame.size.width, 60)];
    iconScrollerView.contentSize = CGSizeMake(620, 0);
    iconScrollerView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:iconScrollerView];
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,[UIApplication sharedApplication].keyWindow.frame.size.height, [UIApplication sharedApplication].keyWindow.frame.size.width, 40)];
    self.cancleBtn = cancleBtn;
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(changeOrCancel:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancleBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, [UIApplication sharedApplication].keyWindow.frame.size.width, 30)];
    self.titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"游戏场景:%@",self.nameAry[self.currentBgImgNum]];
    [bgView addSubview:titleLabel];
    
    
    for (int i = 0 ; i<10 ; i++) {
        UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(10+(50+10)*i, 0, 50, 50)];
        [iconBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"background_%d",i]] forState:UIControlStateNormal];
        iconBtn.tag = i;
        iconBtn.backgroundColor = [UIColor clearColor];
        iconBtn.clipsToBounds = YES;
        iconBtn.layer.cornerRadius = 25;
        [iconScrollerView addSubview:iconBtn];
        [iconBtn addTarget:self action:@selector(addChangeBgimg:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:iconBtn.bounds];
//        img.backgroundColor = [UIColor greenColor];
        img.image = [UIImage imageNamed:@"tagIcon"];
        img.clipsToBounds = YES;
        img.layer.cornerRadius = 25;
        [iconBtn addSubview:img];
        if (i == self.currentBgImgNum) {
            img.hidden = NO;
            self.currentBtn = iconBtn;
        }else{
            img.hidden = YES;
        }
    }
    
    
    [UIView beginAnimations:nil context:nil]; // 开始动画
    [UIView setAnimationDuration:0.5]; // 动画时长
    /**
     *  图像向上移动
     */
    CGPoint scrollerViewPoint = iconScrollerView.center;
    scrollerViewPoint.y -= 100;
    [iconScrollerView setCenter:scrollerViewPoint];
    
    CGPoint cancleBtnPoint = cancleBtn.center;
    cancleBtnPoint.y -= 40;
    [cancleBtn setCenter:cancleBtnPoint];
    
    CGPoint titleLabelPoint = titleLabel.center;
    titleLabelPoint.y -= 135;
    [titleLabel setCenter:titleLabelPoint];
    
    [UIView commitAnimations]; // 提交动画
    
}
- (void)handleSingleTapFrom{
    
    self.currentImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"background_%d",self.currentBgImgNum]];
    [self.bgView removeFromSuperview];
}

- (void)changeOrCancel:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        [self handleSingleTapFrom];
    }else{
//        NSLog(@"设置成功");
        [MBProgressHUD showSuccess:@"设置成功"];
        
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        //还要指定存储文件的文件名称,仍然使用字符串拼接
        NSString *filePath = [docPath stringByAppendingPathComponent:@"test3.plist"];
        //新建一个字典
        NSDictionary *array = @{@"currentBgImgName":[NSString stringWithFormat:@"background_%d",self.currentBtn.tag]};
        //将数组存储到文件中
        [array writeToFile:filePath atomically:YES];
        
        [self viewWillAppear:YES];
        
        self.currentImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"background_%d",self.currentBtn.tag]];
        
        [self handleSingleTapFrom];
    }
}

- (void)addChangeBgimg:(UIButton *)btn{
    self.currentBtn.subviews.lastObject.hidden = YES;
    btn.subviews.lastObject.hidden = NO;
    self.currentBtn = btn;
    self.titleLabel.text = [NSString stringWithFormat:@"%d",btn.tag];
    self.currentImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"background_%d",btn.tag]];
     self.titleLabel.text = [NSString stringWithFormat:@"游戏场景:%@",self.nameAry[btn.tag]];
    [self.cancleBtn setTitle:@"确定" forState:UIControlStateNormal];
}
@end
