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

@interface ViewController () <AwesomeMenuDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) AwesomeMenu *awesome;
@property (assign, nonatomic) BOOL isShowClass;
@property (nonatomic,strong) UITableView *moreTableview;
@property (nonatomic,strong) NSArray *titleAry;
@end

@implementation ViewController
-(NSArray *)titleAry
{
    if (_titleAry == nil) {
        //右边更多操作标题与图片数组
        _titleAry = @[@"1",@"2",@"3",@"4",@"5"];
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
    //油价
    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"youjia"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"menuBg"] highlightedContentImage:[UIImage imageNamed:@"menuBg"]];
    //手机
    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"apple"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"menuBg"] highlightedContentImage:[UIImage imageNamed:@"menuBg"]];
    //快递
    AwesomeMenuItem *item4 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"shop"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"menuBg"] highlightedContentImage:[UIImage imageNamed:@"menuBg"]];
    
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
    
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeRightMoreView)]];
    
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
    if (self.isShowClass) {//正在显示匪类
        [UIView animateWithDuration:0.2 animations:^{
            
            //            self.view.y = 0;
            //            self.view.x = 0;
            
            self.view.userInteractionEnabled = YES;
            [_moreTableview removeFromSuperview];
            CGAffineTransform form = CGAffineTransformMakeTranslation(0, 0);
            
            self.view.transform = CGAffineTransformScale(form, 1.0,1.0);;
        } completion:^(BOOL finished) {
            self.isShowClass = NO;
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
            //            BOSSWeatherController *weather = [[BOSSWeatherController alloc]init];
            //            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:weather];
            //            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 1:{//油价
            //            BOSSPriceController *price = [[BOSSPriceController alloc]init];
            //            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:price];
            //            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 2:{//手机
            //            BOSSPhoneController *phone = [[BOSSPhoneController alloc]init];
            //            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:phone];
            //            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 3:{//快递
            //            BOSSExpressController *express = [[BOSSExpressController alloc]init];
            //            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:express];
            //            [self presentViewController:nav animated:YES completion:nil];
            
            break;
        }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor =[UIColor clearColor];
    }
    //设置cell的边框
    cell.layer.borderColor=[UIColor whiteColor].CGColor;
    cell.layer.borderWidth=0.5;
    
    cell.textLabel.text = self.titleAry[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.titleAry[indexPath.row]);
    [self closeRightMoreView];
}

@end
