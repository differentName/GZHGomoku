//
//  GZHFeatureVC.H
//
//  Created by 高增洪 on 16/4/6.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import "GZHFeatureVC.h"
#import "UIView+MJExtension.h"
#import "UMSocial.h"
#define imageNum 4
@interface GZHFeatureVC ()<UIScrollViewDelegate>
@property(nonatomic,assign) CGRect screenBounds;
@property(nonatomic,strong) UIPageControl *pageController;
@property (nonatomic,strong) UIButton *shareBtn;
@end
@implementation GZHFeatureVC
- (void)loadView
{
    [super loadView];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.screenBounds = screenBounds;
    //创建ScrollView并设置frame
    UIScrollView *feature = [[UIScrollView alloc]initWithFrame:screenBounds];
    //设置代理  监听view的滑动
    feature.delegate = self;
    //设置ScrollView内容的尺寸 一定要设置  否则不能滑动  0说明在竖直方向上不能滑动
    feature.contentSize = CGSizeMake(screenBounds.size.width * imageNum, 0);
    //设置ScrollView的内容
    for (int i = 0; i < imageNum; i++) {
        //创建ImageView并添加图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d",i+1];
        UIImage *image = [UIImage imageNamed:name];
        UIImageView *img = [[UIImageView alloc]initWithFrame:screenBounds];
        img.image = image;
         //设置ImageView的位置
        img.mj_x = img.frame.size.width * i;
        //将ImageView添加到ScrollView上
        [feature addSubview:img];
        //当滑动到最后一张时添加按钮
        if (i == imageNum - 1) {
            img.userInteractionEnabled = YES;//开启交互模式
            /**
             *添加分享按钮
             */
            [self setShareBtnOnImageView:img];
            /**
             *添加进入按钮
             */
            [self setEnterBtnOnImageView:img];
            
        }
    }
    //开启自动分页
    feature.pagingEnabled = YES;
    //取消水平方向上的滚动条
    feature.showsHorizontalScrollIndicator = NO;
    //取消弹簧效果
    feature.bounces = NO;
    //将ScrollView添加到控制器的view上
    [self.view addSubview:feature];
    //添加pageController
    [self addPageController];
}

/**
 *设置分享按钮
 */
- (void)setShareBtnOnImageView:(UIImageView *)img
{
    //创建按钮
    UIButton *shareBtn = [[UIButton alloc]init];
    
    shareBtn.hidden = YES;
    
    self.shareBtn = shareBtn;
    //设置按钮的尺寸
    shareBtn.mj_size = CGSizeMake(100, 30);
    //设置按钮的位置
    shareBtn.centerX = CGRectGetMidX (self.screenBounds);
    shareBtn.centerY = self.screenBounds.size.height * 0.63;
    //设置按钮的标题
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    //设置按钮标题的字体及颜色
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置按钮的背景图片
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    //给按钮绑定监听器
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    //将按钮添加到imageView上
    [img addSubview:shareBtn];
}

/**
 *设置进入按钮
 */
- (void)setEnterBtnOnImageView:(UIImageView *)img
{
    //创建按钮
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 50)];
    //设置按钮的标题
    [enterBtn setTitle:@"进入游戏" forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    enterBtn.clipsToBounds = YES;
    enterBtn.layer.cornerRadius = 6;
    enterBtn.backgroundColor = [UIColor blackColor];
    //设置按钮的背景图片
//    [enterBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
//    [enterBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    //设置按钮的尺寸
//    enterBtn.mj_size = enterBtn.currentBackgroundImage.size;
    //设置按钮的位置
    enterBtn.centerX = CGRectGetMidX (self.screenBounds);
    enterBtn.centerY = self.screenBounds.size.height * 0.75;
    //给按钮绑定监听器
    [enterBtn addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
    //将按钮添加到imageView上
    [img addSubview:enterBtn];
}

/**
 *设置pageController
 */
- (void)addPageController
{
    
    UIPageControl *pageController = [[UIPageControl alloc]init];
    self.pageController = pageController;
    pageController.numberOfPages = imageNum;
    pageController.pageIndicatorTintColor = [UIColor whiteColor];
    pageController.currentPageIndicatorTintColor = [UIColor greenColor];
    pageController.centerX = CGRectGetMidX(self.screenBounds);
    pageController.centerY = self.screenBounds.size.height * 0.98;
    [self.view addSubview:pageController];
}
/**
 *点击分享按钮要做的事情
 */
- (void)share:(UIButton *)shareBtn
{
    shareBtn.selected = !shareBtn.selected;
    if (shareBtn.selected == YES) {
        
        [[UMSocialControllerService defaultControllerService] setShareText:@"最近我在玩:五子棋 华丽的界面、高超的棋艺、方便的操作,真是刺激,快快来和我一决高下吧!,我在这等你哦:http://www.pgyer.com/wuziqi" shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:nil];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
}

/**
 *点击进入按钮要做的事情
 */
- (void)enter
{
    
    //拿到主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //切换主窗口的控制器
    window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GZHHomeController"];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark ----UIScrollViewDelegate
//根据滚动的位置判断页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageController.currentPage =  (int)((scrollView.contentOffset.x + self.screenBounds.size.width * 0.5) / self.screenBounds.size.width);
}
@end
