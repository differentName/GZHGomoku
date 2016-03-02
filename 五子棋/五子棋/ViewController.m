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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.hidesBottomBarWhenPushed = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UIStoryboard *three=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    [self presentViewController:[three instantiateViewControllerWithIdentifier:@"GZHGomokuGameSencesViewController"] animated:YES completion:nil];
    
    [self.navigationController pushViewController:[three instantiateViewControllerWithIdentifier:@"GZHGomokuGameSencesViewController"] animated:YES];
    
//    [UIApplication sharedApplication].keyWindow.rootViewController = [three instantiateViewControllerWithIdentifier:@"GZHGomokuGameSencesViewController"];

}

@end
