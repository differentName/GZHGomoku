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
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.hidesBottomBarWhenPushed = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)enterGame:(UIButton *)sender {
    UIStoryboard *three=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self.navigationController pushViewController:[three instantiateViewControllerWithIdentifier:@"GZHGomokuGameSencesViewController"] animated:YES];
}
- (IBAction)konwologe:(UIButton *)sender {
    GZHGameNewsHomeController *newsController = [[GZHGameNewsHomeController alloc]init];
    [self.navigationController pushViewController:newsController animated:YES];
}

- (IBAction)gameSetting:(UIButton *)sender {
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
}

@end
