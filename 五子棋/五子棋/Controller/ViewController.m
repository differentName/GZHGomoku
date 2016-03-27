//
//  ViewController.m
//  五子棋
//
//  Created by 高增洪 on 16/3/2.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "ViewController.h"
#import "GZHGomokuGameSencesViewController.h"
#import "GZHGomokuOverViewController.h"
#import "GZHHttpTool.h"
#import "GZHGameNewsHomeController.h"
#import "AwesomeMenu.h"
#import "UIView+AutoLayout.h"
#import "MBProgressHUD+MJ.h"
#import <MessageUI/MessageUI.h>
#import "GZHAboutMeController.h"
#import "GZHRightCell.h"
#import "GZHPetalView.h"
#import "UMSocial.h"
#import "GZHExpressController.h"
#import <ZXingObjC/ZXingObjC.h>
#import "ScannerViewController.h"
#import "GZHWeatherController.h"
#import "GZHSettingController.h"
@interface ViewController () <AwesomeMenuDelegate,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,GZHPetalViewDelegate,ScannerViewControllerDelegate>
@property (nonatomic,strong) AwesomeMenu *awesome;
@property (assign, nonatomic) BOOL isShowClass;
@property (nonatomic,strong) UITableView *moreTableview;
@property (nonatomic,strong) NSArray *titleAry;
@property (nonatomic,strong) GZHPetalView *menu;
@property (weak, nonatomic) IBOutlet UIButton *enterGameBtn;
@property (weak, nonatomic) IBOutlet UIButton *gameNewsBtn;
@property (weak, nonatomic) IBOutlet UIButton *gameSettingBtn;
@property (weak, nonatomic) IBOutlet UIButton *gameRightBtn;
@property (nonatomic,strong) UITapGestureRecognizer *openGesture;
@end

@implementation ViewController
-(NSArray *)titleAry
{
    if (_titleAry == nil) {
        //右边更多操作标题与图片数组
        _titleAry = @[@"清除缓存",@"关于我们",@"意见反馈",@"给我好评",@"分享游戏"];
    }
    return _titleAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加右下角按钮
    [self addAwesomeMenu];
    
    //默认情况下右边拓展菜单是关闭的
    self.isShowClass = NO;
    
    //添加右边更多选项区域
    [self addMoreTableview];
    
    //增加侧滑手势
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openRightMoreView)];
    
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    
    //增加分享界面
    [self addShareGameSoftView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alreadyShow) name:@"alreadyShow" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alreadyHidden) name:@"alreadyHidden" object:nil];
}

//分享花瓣展开时
- (void)alreadyShow{
    [self btnIsUserInteractionEnabled:NO];

}

//分享花瓣关闭时
- (void)alreadyHidden{
    [self btnIsUserInteractionEnabled:YES];

}

//设置按钮是否可用
- (void)btnIsUserInteractionEnabled:(BOOL)userInteractionEnabled{
    self.awesome.userInteractionEnabled = userInteractionEnabled;
    self.gameNewsBtn.userInteractionEnabled = userInteractionEnabled;
    self.gameRightBtn.userInteractionEnabled = userInteractionEnabled;
    self.gameSettingBtn.userInteractionEnabled = userInteractionEnabled;
    self.enterGameBtn.userInteractionEnabled = userInteractionEnabled;
}
//增加分享界面
- (void)addShareGameSoftView{
    NSArray *images = @[[UIImage imageNamed:@"sinaShareIcon"],[UIImage imageNamed:@"qqShareIcon.png"],[UIImage imageNamed:@"wechatShareIcon"],[UIImage imageNamed:@"friendShareIcon"],];
    self.menu = [[GZHPetalView alloc] init];
    self.menu.delegate = self;
    self.menu.buttonImages = images;
    [self.view addSubview:self.menu];

}


/**添加右边更多选项区域*/
- (void)addMoreTableview
{
    _moreTableview = [[UITableView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100*([UIScreen mainScreen].bounds.size.width/320), 0, 100*([UIScreen mainScreen].bounds.size.width/320), [UIScreen mainScreen].bounds.size.height)];
    
    _moreTableview.contentInset = UIEdgeInsetsMake(([UIScreen mainScreen].bounds.size.height - 44*self.titleAry.count)/2, 0, 0, 0);
    
    _moreTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _moreTableview.backgroundColor = [UIColor clearColor];
    _moreTableview.delegate = self;
    _moreTableview.dataSource = self;
    
//    [[UIApplication sharedApplication].keyWindow insertSubview:_moreTableview belowSubview:self.view];
    
}

/**
 *  添加右下角按钮
 */
- (void)addAwesomeMenu
{
    //开始按钮
    AwesomeMenuItem *start = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"menu"] highlightedImage:[UIImage imageNamed:@"menu"] ContentImage:[UIImage imageNamed:@"menuBg"] highlightedContentImage:[UIImage imageNamed:@"menuBg"]];
    
    //周边按钮
    //天气
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"weather"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"menuBg"] highlightedContentImage:[UIImage imageNamed:@"menuBg"]];
    //快递
    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"shop"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"menuBg"] highlightedContentImage:[UIImage imageNamed:@"menuBg"]];
    //扫描二维码
    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"scan"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"menuBg"] highlightedContentImage:[UIImage imageNamed:@"menuBg"]];
    //搜索
    AwesomeMenuItem *item4 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"baidu"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"menuBg"] highlightedContentImage:[UIImage imageNamed:@"menuBg"]];
    
    NSArray *itemsAry = @[item1,item2,item3,item4];
    AwesomeMenu *awesome = [[AwesomeMenu alloc]initWithFrame:CGRectZero startItem:start menuItems:itemsAry];
    self.awesome = awesome;
    
    //设置代理 监听按钮的点击
    awesome.delegate = self;
    //设置透明度
    awesome.alpha = 0.3;
    
    //设置点击开始按钮时不旋转
    awesome.rotateAddButton = NO;
    
    //设置开始按钮的位置
    awesome.startPoint = CGPointMake(50, 150);
    
    //设置周边按钮的位置  四分一圆
    awesome.menuWholeAngle = M_PI_2;
    
    //设置awesome的布局
    UIWindow *lastWindow = [UIApplication sharedApplication].windows.lastObject;
    [lastWindow addSubview:awesome];
    [awesome autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:lastWindow withOffset:-10];
    [awesome autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:lastWindow withOffset:-130];
    [awesome autoSetDimensionsToSize:CGSizeMake(60,60)];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.awesome.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.awesome.hidden = YES;
}

- (void)dealloc
{
    [self.awesome removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self closeRightMoreView];
}


//进入游戏
- (IBAction)enterGame:(UIButton *)sender {
    
    [self closeRightMoreView];
    UIStoryboard *three=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //每次进入界面重新开盘
    GZHGomokuGameEngine *engine = [GZHGomokuGameEngine game];
    [engine reStart];
    
    [self.navigationController pushViewController:[three instantiateViewControllerWithIdentifier:@"GZHGomokuGameSencesViewController"] animated:YES];
}

//五子趣闻
- (IBAction)konwologe:(UIButton *)sender {
    
    [self closeRightMoreView];
    
    GZHGameNewsHomeController *newsController = [[GZHGameNewsHomeController alloc]init];
    [self.navigationController pushViewController:newsController animated:YES];
}

//游戏设置
- (IBAction)gameSetting:(UIButton *)sender {
    
    [self closeRightMoreView];
    
    GZHSettingController *setting = [[GZHSettingController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
    
}

//右上角更多选项按钮
- (IBAction)rightMoreBtn:(UIButton *)sender {
    
    if (self.isShowClass == NO) {//
        [self openRightMoreView];
    }else{
        [self closeRightMoreView];
    }
}
//打开右边更多选项按钮
- (void)openRightMoreView{
    
    //设置keyWindow的背景颜色
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bgImage"]];
    
#warning mark - 这个手势会影响到push出的自控制器的交互效果 所以要在关闭右边更多功能界面时销毁
    UITapGestureRecognizer *openGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeRightMoreView)];
    self.openGesture = openGesture;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:openGesture];
    
    [UIView animateWithDuration:0.2 animations:^{
        //            self.view.y = 60;
        //            self.view.x = 100;
        CGAffineTransform form = CGAffineTransformMakeTranslation(-100,60);
        self.view.transform = CGAffineTransformScale(form, 0.7, 0.7);;
        [[UIApplication sharedApplication].windows.lastObject addSubview:_moreTableview];
    }completion:^(BOOL finished) {
        self.isShowClass = YES;
    }];
}

//关闭右边更多选项按钮
- (void)closeRightMoreView{
    if (self.isShowClass) {//正在显示分类
        [UIView animateWithDuration:0.2 animations:^{
            
            //            self.view.y = 0;
            //            self.view.x = 0;
            
            self.view.userInteractionEnabled = YES;
            [_moreTableview removeFromSuperview];
            CGAffineTransform form = CGAffineTransformMakeTranslation(0, 0);
            
            self.view.transform = CGAffineTransformScale(form, 1.0,1.0);;
        } completion:^(BOOL finished) {
            self.isShowClass = NO;
            [[UIApplication sharedApplication].keyWindow removeGestureRecognizer:self.openGesture];
        }];
    }
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
}


#pragma  mark    AwesomeMenu代理方法
//点击开始按钮 即将进行动画时调用
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    menu.alpha = 1;
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    
    [self closeRightMoreView];
}

- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu
{
    menu.alpha = 0.3;
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
}

//点击了周边按钮
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    menu.alpha = 0.3;
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    
    switch (idx) {
        case 0:{//天气
            GZHWeatherController *weather = [[GZHWeatherController alloc]init];
            [self.navigationController pushViewController:weather animated:YES];
            break;
        }
        case 1:{//快递
            GZHExpressController *express = [[GZHExpressController alloc]init];
            [self.navigationController pushViewController:express animated:YES];
            break;
        }
        case 2:{//二维码
            ScannerViewController *svc=[[ScannerViewController alloc]init];
            svc.delegate=self;
            [self presentViewController:svc animated:YES completion:nil];
            break;
        }
        case 3:{//搜索
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
            break;
        }
    }
    
}

#pragma  mark  GZHPetalViewDelegate
- (void)GZHPetalView:(GZHPetalView *)menu didSelectedButtonAtIndex:(NSUInteger)index{
    
    [menu hide];
#warning - mark 这个地址等版本功能完善后改为蒲公英对应的下载的地址  另外关于我们模块中的二维码也要更新
    [[UMSocialControllerService defaultControllerService] setShareText:@"最近我在玩:五子棋 华丽的界面、高超的棋艺、方便的操作,真是刺激,快快来和我一决高下吧!,我在这等你哦:http://www.baidu.com" shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:nil];
    
    switch (index) {
        case 0://微博
            NSLog(@"微博");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
            
        case 1://QQ
            NSLog(@"QQ");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
        case 2://微信
            NSLog(@"微信");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
            
        case 3://朋友圈
            NSLog(@"朋友圈");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
            
        default:
            
            break;
    }
}


#pragma  mark    tablview代理方法  数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    GZHRightCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[GZHRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor =[UIColor clearColor];
    }
    //设置cell的边框
    cell.layer.borderColor=[UIColor whiteColor].CGColor;
    cell.layer.borderWidth=0.5;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rightIcon%d",indexPath.row+1]];
    cell.textLabel.text = self.titleAry[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self closeRightMoreView];
    
    if (indexPath.row == 0) {//清除缓存
        // 缓存文件夹的路径
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        //文件管理者
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        [mgr removeItemAtPath:caches error:nil];//移除文件夹
        
        [MBProgressHUD showMessage:@"缓存清理中"];
        
        NSTimer *myTimer = [NSTimer timerWithTimeInterval:1.2 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
        
        [[NSRunLoop  currentRunLoop]addTimer:myTimer forMode:NSDefaultRunLoopMode];
    }else if (indexPath.row == 1){//关于我们
        [self.navigationController pushViewController:[[GZHAboutMeController alloc] init] animated:YES];
    
    }else if (indexPath.row == 2){//意见反馈
        [self displayComposerSheet];
        
    }else if (indexPath.row == 3){//给我好评
            [MBProgressHUD showSuccess:@"谢谢您的支持"];
        
    }else if (indexPath.row == 4){//分享游戏
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareGameSoft" object:nil];
        
    }
}

//提示缓存清理完毕
- (void)timerFired{
    
    [MBProgressHUD hideHUD];
    
    [MBProgressHUD showSuccess:@"清除完毕"];
}

//邮件反馈功能
- (void)displayComposerSheet {
    if (![MFMailComposeViewController canSendMail]) {//设备不支持发邮件
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请配置邮件"
                                                        message:@"你的设备不支持发邮件，需要你配置你的设备"
                                                       delegate:self
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil,nil];
        [alert show];
        return;
    } else {//设备支持发邮件
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:[NSString stringWithFormat:@"意见反馈"]];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"object_c@126.com", nil];
        [picker setToRecipients:toRecipients];
        NSString *emailBody = @"我的意见是...";
        [picker setMessageBody:emailBody isHTML:NO];
        NSLog(@"还未弹出");
        [self presentViewController:picker animated:YES completion:nil];
        NSLog(@"弹出完毕");
    }
}

// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
