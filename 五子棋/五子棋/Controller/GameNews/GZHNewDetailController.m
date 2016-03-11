//
//  GZHNewDetailController.m
//  五子棋
//
//  Created by 高增洪 on 16/3/3.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHNewDetailController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UMSocial.h"
#import "CLAnimationView.h"
@interface GZHNewDetailController ()
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation GZHNewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"趣闻详情";
    
    self.playBtn.clipsToBounds = YES;
    self.playBtn.layer.cornerRadius = 10;
    
    self.nameLabel.text = self.titleName;
    
    //设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //设置分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"export"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    
}
//返回上层界面
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//分享
- (void)share{
    CLAnimationView *animationView = [[CLAnimationView alloc]initWithTitleArray:@[@"微博",@"微信",@"朋友圈",@"QQ"] picarray:@[@"share_page_weibo_icon",@"share_page_wechat_icon",@"share_page_wechat_moment_icon",@"share_page_qq_icon"]];
    [animationView selectedWithIndex:^(NSInteger index) {
        NSLog(@"你选择的index ＝＝ %ld",(long)index);
        [self shareWithIndex:index Content:[NSString stringWithFormat:@"我正在学习:%@,链接地址为:%@ 你也快来看看吧n(*≧▽≦*)n",self.titleName,self.content] Img:nil];
    }];
    [animationView CLBtnBlock:^(UIButton *btn) {
        NSLog(@"你点了取消按钮");
    }];
    
    [animationView show];
    
}

- (void)shareWithIndex:(NSInteger)index Content:(NSString *)content Img:(NSString *)img{
    [[UMSocialControllerService defaultControllerService] setShareText:content.length>0?content:@"快来和我一决高下!"  shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:nil];
    switch (index) {
        case 1:
            NSLog(@"分享到微博");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            break;
        case 2:
            NSLog(@"分享到微信");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
            
        case 3:
            NSLog(@"分享到朋友圈");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
            
        case 4:
            NSLog(@"分享到QQ");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
        default:
            break;
    }
    
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

- (IBAction)playVideo:(id)sender {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_content]];
}

@end
